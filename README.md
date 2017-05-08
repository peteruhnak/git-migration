# MCZ -> Git Migration
[![Build Status](https://travis-ci.org/peteruhnak/git-migration.svg?branch=master)](https://travis-ci.org/peteruhnak/git-migration) [![Coverage Status](https://coveralls.io/repos/github/peteruhnak/git-migration/badge.svg?branch=master)](https://coveralls.io/github/peteruhnak/git-migration?branch=master)

Utility to migrate code from SmalltalkHub (or any MCZ-based repo) to Git

**WARNING**
> This project is still experimental, so use it at your own risk. Although it is not going to break your (SmalltalkHub) project, it is possible that an error will be discovered and you will have to redo the migration
>
> resetting issues ~~#2~~, #4


This needlessly long readme explains three main parts:

1. [Migration using git fast-import](#usage---fast-import)
	* this should be the fastest and safest option
2. [Migration using GitFileTree](#usage---gitfiletree)
	* slower alternative, but also usable for smaller repos
3. [Visualizations](#visualizations)
	* if you just want to see pretty pictures of your MCZ history before you decide (or not) to migrate

(also see [For Developers](#for-developers) if you want to dig in the internals)

Table Of Contents

* [Possible Issues](#possible-issues)
* [Installation](#installation)
* [Usage - Fast Import](#usage---fast-import)
* [Usage - GitFileTree](#usage---gitfiletree)
* [Extras](#extras)
* [Visualizations](#visualizations)
* [For Developers](#for-developers)


## Possible Issues

I am not an expert on Monticello (and I've migrated to git two years ago, so I don't know why I even wrote this tool), so it is possible that there are edge cases that I haven't considered; if you run into a problem, feel free to open an issue (ideally with a pull request ;)).

* performance - this was improved somewhat (from tens of minutes to minutes) with fast-import format, however processing a larger repository can still take two or three minutes (PolyMath with 784 commits across 74 packages took ~3 minutes to generate 87MB import file; the git-fast-import itself took less than a second)
* relying on dependencies specified in Versions
	* these days dependencies are specified in ConfigurationOf/BaselineOf, but old approach relied on some other way, I am ignoring these dependencies to further improve perfomance, but I am not sure if it is safe for all repos
		* if you know how these works and you have a repository using them, then pull requests are welcome
* OSSubProcess/ProcessWrapper freezing/crashing
	* I have bad experience with ProcessWrapper on Windows (that's why I made [shell proxy](https://github.com/peteruhnak/pharo-shell-proxy/) for myself), and I had reports of OSSubProcess freezing on Mac; PW/OSS failing will require for the migration to restart
		* note that this problem affects only GitFileTree-based import; fast-import doesn't use them
* GitFileTree import doesn't preserve merge information
	* this doesn't impact the functionality of the code, only the metahistory is somewhat obscured
		* fast-import doesn't suffer from this and it will convert MCZ merges as git merges

## Prerequisites

* git installed in the system and available in `PATH`
* **Pharo 6+**
	* it should work in Pharo 5 too, however there are some weird unicode-related issues that were breaking the build… if you _must_ use it on Pharo 5, then let me know

## Installation

```smalltalk
Metacello new
	baseline: 'GitMigration';
	repository: 'github://peteruhnak/git-migration/repository';
	load.
```

## Usage - Fast Import

Fast Import generates a file for [git-fast-import](https://git-scm.com/docs/git-fast-import).

### Example

```smalltalk
migration := GitMigration on: 'peteruhnak/breaking-mcz'.
migration authors: {'PeterUhnak' -> #('Peter Uhnak' '<i.uhnak@gmail.com>')}.
migration
	fastImportCodeToDirectory: 'repository'
	initialCommit: '5793e82'
	to: 'D:/tmp/breaking-mcz2/import.txt'
```

### 1. Adding Repositories

Add your source repository (SmalltalkHub) to Pharo, e.g. via Monticello Browser

### 2. Find The Initial Commit SHA

The migration will need to know from which commit it should start. This will be typically the SHA of the current commit of the master branch; you don't need the full 40-char SHA, first e.g. 10 characters is enough.

The get the current commit, you can do the following

```bash
$ git log --oneline -n 1
```

### 3. Generating Import File

```smalltalk
"Specify the name of the source repository; I am sourcing from peteruhnak/breaking-mcz project on SmalltalkHub"
migration := GitMigration on: 'peteruhnak/breaking-mcz'.

"List all authors anywhere in the project's commits"
migration allAuthors. "#('PeterUhnak')"

"You must specify name and email for _every_ author"
"You must also specify the name/email for yourself (Author fullName), even if you didn't commit in the source repository"
"AuthorName (as shown in #allAuthors) -> #('Nicer Name' '<email.including-brackets@example.com>')"
migration authors: {
	'PeterUhnak' -> #('Peter Uhnak' '<i.uhnak@gmail.com>')
}.

"Run the migration, this might take a while
* the code directory is where the code will be stored (common practice is to have the code in `repository` subfolder)
* initialCommit is the commit from which the migration should start
* to is where the git-fast-import file should be stored"
migration
	fastImportCodeToDirectory: 'repository'
	initialCommit: '5793e82'
	to: 'D:/tmp/breaking-mcz2/import.txt'
```

### 4. Running The Import

Now get a terminal, go to the target git repository, and run the migration.

```bash
# import.txt is the file that you've created earlier
$ git fast-import < import.txt
# fast-import doesn't change the working directory, so we need to update it
$ git reset --hard master
```

Now you should see the changes, and `git log` should show you the entire history.

## Usage - GitFileTree

### Example

```smalltalk
migration := GitMigration on: 'peteruhnak/breaking-mcz'.
migration authors: {'PeterUhnak' -> #('Peter Uhnak' '<i.uhnak@gmail.com>')}.
migration migrateToGitFileTreeRepositoryNamed: 'breaking-mcz/repository'
```

### 1. Adding Repositories

Add your source repository (SmalltalkHub) and your target repository (local gitfiletree://) to Pharo, e.g. via Monticello Browser

### 2. Running Migration


```smalltalk
"Specify the name of the source repository; I am sourcing from peteruhnak/breaking-mcz project on SmalltalkHub"
migration := GitMigration on: 'peteruhnak/breaking-mcz'.

"List all authors anywhere in the project's commits"
migration allAuthors. "#('PeterUhnak')"

"You must specify name and email for _every_ author"
"AuthorName (as shown in #allAuthors) -> #('Nicer Name' '<email.including-brackets@example.com>')"
migration authors: {'PeterUhnak' -> #('Peter Uhnak' '<i.uhnak@gmail.com>')}.

"Run the migration, this might take a while
The target repository is found by string-matching so here the repo is in the folder 'breaking-mcz' and subfolder 'repository'"
migration migrateToGitFileTreeRepositoryNamed: 'breaking-mcz/repository'
```

## Git Tips

Forgetting all changes in the history and going back to previous state. (Useful if the migration is botched and you want to rollback all changes.)

```bash
$ git reset --hard SHA
```

## Extras

If you want to play around with the data before committing, read the following.

```smalltalk
migration := GitMigration on: 'peteruhnak/breaking-mcz'.
```

Downloading all MCZs from server; this needs to happen only once and can take a while for large repos.
```smalltalk
migration cacheAllVersions.
```

List all packages in the repository that have multiple roots; although rare, this could be either result of multiple people starting independently on the same package, or a mistake was made during committing.
GitMigration should be able to handle this correctly regardless.
```smalltalk
migration packagesWithMultipleRoots.
```

List all authors in the repository.
```smalltalk
migration allAuthors.
```

Dictionary of all packages and their _real_ (see later what's real) commits.
```smalltalk
versionsByPackage := migration versionsByPackage.
```

*All* versions of a package, whether there is actually an MCZ or not. With Monticello it is very easy to create a commit whose ancestor is not in the repository, so it is not obvious how the commit connects the previous ones.
Thankfully MCZ typically contains the hierarchy many steps back, so we can correctly reconstruct the whole tree.
```smalltalk
allVersions := migration completeAncestryOfPackageNamed: 'Somewhere'.
```

The versions in mcz are random, so we need to sort them in an order in which we can commit them to git. This means that all ancestry is honored (no child is commited before its parent), and "sibling" commits are sorted by date.
Note that we cannot just sort the commits by date, because the date might not follow the ancestry correctly (which can happen, especially if different timezones are involved, which MC doesn't keep track of)
```smalltalk
sorted := migration topologicallySort: allVersions.
```

Get the total ordering of all commits across all packages
```smalltalk
allVersionsOrdered := migration commitOrder.
```

## Visualizations

This requires [Roassal](http://agilevisualization.com/) to be installed (available in catalog).

In all visualizations hovering over an item will show a popup with more information, and clicking on item will open an inspector.
Keep in mind that running the command will not open a new window, so you have to either inspect it, or do-it-and-go in playground.

### Single Package Ancestry

Looking at raw data is not very insightful, so couple visualization are included:

Show the complete ancestry of a single package.
```smalltalk
migration := GitMigration on: 'peteruhnak/breaking-mcz'.
migration showAncestryTopologyOnPackageNamed: 'Somewhere'.
```

![](figures/package-ancestry.png)

* Red - root versions (versions with no parents, typically only a single initial commit)
* Blue - tail/head versions (versions with no children, typically the latest version(s))
* Purple - "virtual" versions that do not have a corresponding commit (this happens as mentioned earlier)

The number on the third line indicates in what order the packages will be commited (purple packages are listed, but are not commited, because there is no code to commit).
Keep in mind that the number in the commit (Somewhere-PeterUhnak.15) has no value, and can be easily changed (and broken by hand); `breaking-mcz` project was intentionally constructed to have the numbers semi-random to demonstrate this.



### Project Ancestry

To see all packages and history, you could do.

```smalltalk
migration showProjectAncestry.
```

![](figures/project-ancestry.png)

This is useful if you want to quickly glance at a project (and is also much faster to generate and use), but if want you can also add label

```smalltalk
migration showProjectAncestryWithLabels.
"or"
migration showProjectAncestryWithLabels: true.
```

![](figures/project-ancestry-labels.png)


### Limited Project Ancestry

If you have big project and want to look only at certain packages, you can do so. (In the image you can see that the longest chain has ancestry broken - red box at the end)

```
migration := GitMigration on: 'PolyMath/PolyMath'.
"or just a collection of package names"
migration showProjectAncestryOn: (allPackages copyWithoutAll: #('Monticello' 'ConfigurationOfSciSmalltalk'  'Math-RealInterval')).
```

![](figures/subset-packages-ancestry.png)

Adding labels works the same way

```
migration showProjectAncestryOn: aCollectionOfPackages withLabels: aBoolean
```

## For Developers

Some hints and random thoughts.
SmalltalkHub stores every commit in a separate MCZ file, which contains some metadata about the commit (name, ancestry, etc), as well as all the code. The code itself is not incremental, rather code in each zip is as-is.

This means that when GitFileTree is exporting, it will remove all files on the disk, unpack the MCZ file, and write all the code back to disk, and commit. Git is smart enough to only commit what has actually changed, however for GFT this operation is very IO intense - if you have 5k files in your code base and you changed just a single method (which is common), then 5k files will be removed and then added back... you can imagine what this does to the disk when performed 1000x times (once for each commit).

With fast-import I've made a workaround for this. A pseudo-repository `GitMigrationMemoryTreeGitRepository` is created that uses memory file system as the target directory. This way the fileout doesn't write to real disk and everything is kept in RAM, which improves the performance significantly.

Note however that instead of using `MemoryStore` I had to subclass it (`GitMigrationMemoryStore`) to properly handle path separators; on Windows, MemoryStore by itself will create files and directories with slashes (both forward and backward) in their names instead of creating a hierarchy, so my `GitMigrationMemoryStore` fixes this.

I am also subclassing `MemoryHandle` (`GitMigrationMemoryHandle`) and I've changed the `writeStream` of it to return `MultiByteBinaryOrTextStream`. This is because `MemoryStore` returns only an ordinary `WriteStream` which cannot handle unicode content and 那不是很好。 :)

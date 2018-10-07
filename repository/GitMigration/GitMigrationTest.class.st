Class {
	#name : #GitMigrationTest,
	#superclass : #TestCase,
	#instVars : [
		'migration'
	],
	#category : 'GitMigration-Tests'
}

{ #category : #running }
GitMigrationTest >> ensureAllCached [
	(MCCacheRepository uniqueInstance directory children
		noneSatisfy: [ :each | each basename = 'Somewhere-PeterUhnak.2.mcz' ])
		ifTrue: [ migration cacheAllVersions ]
]

{ #category : #running }
GitMigrationTest >> ensureGitFileTreeLoaded [
	(Smalltalk hasClassNamed: #MCFileTreeGitRepository)
		ifFalse: [ (CatalogProvider projectNamed: 'GitFileTree') installVersion: #stable ]
]

{ #category : #running }
GitMigrationTest >> ensureTestRepoLoaded [
	| repo |
	repo := MCSmalltalkhubRepository new.
	repo owner: 'peteruhnak'.
	repo project: 'breaking-mcz'.
	MCRepositoryGroup default addRepository: repo
]

{ #category : #running }
GitMigrationTest >> setUp [
	super setUp.
	self timeLimit: 1 minute.
	self ensureTestRepoLoaded.
	"	self ensureGitFileTreeLoaded."
	migration := GitMigration on: 'peteruhnak/breaking-mcz'.
	self ensureAllCached
]

{ #category : #'tests - accessing' }
GitMigrationTest >> testAllAuthors [
	| oldName |
	oldName := Author fullName.
	[ Author fullName: 'LocalUser'.
	self assert: (migration allAuthors includes: 'LocalUser') ]
		ensure: [ Author fullName: oldName ]
]

{ #category : #'tests - accessing' }
GitMigrationTest >> testAuthorsOk [
	self
		shouldnt: [ migration authors: {'PeterUhnak' -> #('Peter Uhnak' '<wherever@wherever.com>')} ]
		raise: NotFound
]

{ #category : #'tests - actions' }
GitMigrationTest >> testCacheAllVersions [
	| version |
	migration cacheAllVersions.
	version := MCCacheRepository uniqueInstance
		versionInfoFromFileNamed: 'Somewhere-PeterUhnak.2.mcz'.
	self assert: version name equals: 'Somewhere-PeterUhnak.2'
]

{ #category : #'tests - accessing' }
GitMigrationTest >> testCommitOrder [
	| commitOrder |
	commitOrder := migration commitOrder.
	self
		assert: (commitOrder collect: [ :each | (each name splitOn: '.') last asNumber ]) asArray
		equals: #(1 2 4 3 1 8 4 15 5 6 9 5 6 10 1)
]

{ #category : #'tests - accessing' }
GitMigrationTest >> testCompleteAncestry [
	| result |
	result := migration completeAncestryOfPackageNamed: 'CoSomewhere'.
	self
		assert: (result collect: #name) asArray sorted
		equals: #('CoSomewhere-PeterUhnak.1' 'CoSomewhere-PeterUhnak.4' 'CoSomewhere-PeterUhnak.5' 'CoSomewhere-PeterUhnak.6')
]

{ #category : #'tests - actions' }
GitMigrationTest >> testCompleteAncestry2 [
	| ancestry |
	ancestry := migration completeAncestryOfPackageNamed: 'Somewhere'.
	self
		assert: (ancestry collect: [ :each | (each name splitOn: '.') last asNumber ]) asArray sorted
		equals: #(1 2 4 3 8 15 5 6 7 9 10) sorted
]

{ #category : #'tests - accessing' }
GitMigrationTest >> testCompleteAncestryTrimmed [
	"https://github.com/peteruhnak/git-migration/issues/13"

	| result brokenVersion brokenAncestor |
	migration populateCaches.
	brokenVersion := migration versions
		detect: [ :each | each info name = 'CoSomewhere-PeterUhnak.5' ].
	brokenAncestor := MCVersionInfo
		name: ''
		id: UUID new
		message: 'I am broken'
		date: ''
		time: ''
		author: ''
		ancestors: #().
	brokenVersion info setAncestors: brokenVersion info ancestors , {brokenAncestor}.
	result := migration completeAncestryOfPackageNamed: 'CoSomewhere'.
	self
		assert: (result collect: #name) asArray sorted
		equals:
			#('CoSomewhere-PeterUhnak.1' 'CoSomewhere-PeterUhnak.4' 'CoSomewhere-PeterUhnak.5' 'CoSomewhere-PeterUhnak.6')
]

{ #category : #'tests - retrieving' }
GitMigrationTest >> testFindRepository [
	| repo |
	"fuel should be in the image by default afaik"
	repo := migration findRepositoryNamed: 'peteruhnak/breaking-mcz'.
	self assert: repo isNotNil.
	self assert: repo owner equals: 'peteruhnak'.
	self assert: repo project equals: 'breaking-mcz'
]

{ #category : #'tests - topology sorting' }
GitMigrationTest >> testIsRoot [
	self assert: (migration isRoot: 1 in: {1 -> 2}).
	self deny: (migration isRoot: 1 in: {2 -> 1})
]

{ #category : #'tests - retrieving' }
GitMigrationTest >> testOn [
	self assert: migration repository isNotNil.
	self assert: migration repository owner equals: 'peteruhnak'.
	self assert: migration repository project equals: 'breaking-mcz'
]

{ #category : #'tests - actions' }
GitMigrationTest >> testTopologicallySort [
	| ancestry sorted |
	ancestry := migration completeAncestryOfPackageNamed: 'Somewhere'.
	sorted := migration topologicallySort: ancestry.
	self
		assert: (sorted collect: [ :each | (each name splitOn: '.') last asNumber ]) asArray
		equals: #(1 2 4 3 8 15 5 6 7 9 10)
]

{ #category : #'tests - retrieving' }
GitMigrationTest >> testVersionInfo [
	| version |
	migration cacheAllVersions.
	version := migration versionInfoFromFileNamed: 'Somewhere-PeterUhnak.2.mcz'.
	self assert: version name equals: 'Somewhere-PeterUhnak.2'
]

{ #category : #'tests - accessing' }
GitMigrationTest >> testVersionsByPackage [
	self assert: migration versionsByPackage keys sorted equals: #(CoSomewhere EverythingIsBurning Somewhere)
]

{ #category : #'tests - accessing' }
GitMigrationTest >> testVersionsByPackageWithFilter [
	migration selectedPackageNames: #(CoSomewhere).
	self assert: migration versionsByPackage keys sorted equals: #(CoSomewhere)
]

"
I am the main user entrypoint for performing migration.

See class-side for an example, or read the docs ( https://github.com/peteruhnak/git-migration )
"
Class {
	#name : #GitMigration,
	#superclass : #Object,
	#instVars : [
		'authors',
		'repository',
		'cachedVersions',
		'completeAncestryCache',
		'versionsWithPackageNames',
		'versionsCache',
		'allAuthors',
		'selectedPackageNames',
		'onEmptyMessage',
		'ignoredFileNames'
	],
	#category : #GitMigration
}

{ #category : #'instance creation' }
GitMigration class >> on: aProjectName [
	^ self new
		projectName: aProjectName;
		yourself
]

{ #category : #accessing }
GitMigration >> allAuthors [
	allAuthors
		ifNil: [ | authorsSet |
			authorsSet := Set new.
			authorsSet add: Author fullName.
			self versions
				do: [ :each | 
					authorsSet add: each info author.
					authorsSet addAll: (self authorsInSnapshot: each veryDeepCopy snapshot) ]
				displayingProgress: [ :each | 'Loading authors... ' , each info name ].
			allAuthors := authorsSet asArray sorted ].
	^ allAuthors
]

{ #category : #accessing }
GitMigration >> authors: aCollection [
	authors := aCollection asDictionary
]

{ #category : #accessing }
GitMigration >> authorsInSnapshot: aSnapshot [
	| timeStamps |
	timeStamps := OrderedCollection new.
	aSnapshot definitions
		do: [ :each | 
			each isMethodDefinition
				ifTrue: [ timeStamps add: each timeStamp ].
			(each isClassDefinition and: [ (each isKindOf: MCClassTraitDefinition) not ])
				ifTrue: [ timeStamps add: each commentStamp ] ].
	^ (timeStamps collect: [ :each | each copyUpTo: Character space ]) \ #('' '<historical>')
]

{ #category : #actions }
GitMigration >> cacheAllVersions [
	| goSource allPackageNames packageNames|
	goSource := Gofer new repository: repository.
	allPackageNames := (repository allVersionNames collect: [ :each | each copyUpToLast: $- ]) asSet.
	packageNames := selectedPackageNames ifEmpty: [ allPackageNames ].
	(goSource allResolved
		select: [ :resolved | packageNames includes: resolved packageName ])
		do: [ :each | goSource package: each packageName ].
	goSource fetch
]

{ #category : #actions }
GitMigration >> commitOrder [
	"All packages to be commited in the order from first to last, across multiple packages"

	| packagePool ordering |
	packagePool := IdentitySet new.
	ordering := OrderedCollection new.
	self versionsByPackage
		keysAndValuesDo: [ :pkgName :realVersions | 
			| allVersions allRealVersions allValidVersions |
			allVersions := self topologicallySort: (self completeAncestryOfPackageNamed: pkgName).
			"add only versions that have real MCZ file"
			allRealVersions := allVersions select: [ :each | realVersions includes: each ].
			"reject versions with empty snapshot; veryDeepCopy because the version is kept in memory, but not the snapshot"
			allValidVersions := allRealVersions
				reject: [ :each | 
					| fullVersion |
					fullVersion := self versions detect: [ :v | v info = each ].
					fullVersion veryDeepCopy snapshot definitions isEmpty ].
			"			self haltIf: [ (allValidVersions = allRealVersions) not ]."
			allValidVersions
				ifEmpty: [ self notify: 'Package ' , pkgName , ' has no MCZs with code' ].
			packagePool add: allValidVersions ].
	packagePool := packagePool reject: #isEmpty.

	"pick the oldest available commit across all packages"
	[ packagePool isNotEmpty ]
		whileTrue: [ | oldestPackage version |
			oldestPackage := packagePool detectMin: [ :pkgVersions | pkgVersions first timeStamp ].
			version := oldestPackage first.
			oldestPackage removeFirst.
			ordering add: version.
			oldestPackage ifEmpty: [ packagePool remove: oldestPackage ] ].
	^ ordering
]

{ #category : #accessing }
GitMigration >> completeAncestryOfPackageNamed: aPackageName [
	^ completeAncestryCache
		at: aPackageName
		ifAbsentPut: [ | versions allVersions getAncestors parents |
			"Not all versions are actually available directly, so do a very deep search"
			versions := self versionsByPackage at: aPackageName.
			allVersions := Set new.
			getAncestors := [ :parent | 
			(allVersions includes: parent)
				ifTrue: [ #() ]
				ifFalse: [ parent ancestors ] ].
			versions
				do: [ :version | 
					parents := Array with: version.
					[ parents isNotEmpty ]
						whileTrue: [ | allAncestors ancestors |
							allAncestors := parents flatCollect: [ :p | getAncestors value: p ].
							"The history can get trimmed, with only ID preserved and nothing else"
							ancestors := allAncestors reject: [ :e | e name = '' ].
							allVersions addAll: parents.
							parents := ancestors ] ].
			allVersions ]
]

{ #category : #import }
GitMigration >> createFastImportAt: anInitialCommitish usingWriter: aWriter [
	| versions |
	aWriter initialCommit: anInitialCommitish.
	self useAuthorsOn: aWriter.
	self do: [ versions := self versionsToMigrate ] displaying: 'Ordering history...'.
	self preChecksOn: versions.
	versions
		do: [ :each | aWriter writeVersion: each veryDeepCopy ]
		displayingProgress: [ :each | 'Exporting version ' , each info name ]
]

{ #category : #ui }
GitMigration >> do: aBlock displaying: aString [
	aString
		displayProgressFrom: 0
		to: 2
		during: [ :bar | 
			bar value: 1.
			World doOneCycle.
			aBlock value.
			bar value: 2 ]
]

{ #category : #actions }
GitMigration >> downloadAllVersions [
	self do: [ self cacheAllVersions ] displaying: 'Downloading all versions...'
]

{ #category : #import }
GitMigration >> fastImportCodeToDirectory: aDirectoryName initialCommit: anInitialCommitish to: aFileReference [
	| writer |
	aFileReference asFileReference
		ensureDelete;
		writeStreamDo: [ :rawStream | 
			writer := GitMigrationTonelWriter new on: rawStream.
			writer exportDirectory: aDirectoryName.
			writer onEmptyMessage: onEmptyMessage.
			self createFastImportAt: anInitialCommitish usingWriter: writer ].
	^ writer commitMarks
]

{ #category : #retrieving }
GitMigration >> findRepositoryNamed: aRepoName [
	"aRepoName = ownerName/projectName, e.g. ObjectProfile/Roassal2"
	^ MCRepositoryGroup default repositories
		detect: [ :each | (each description includesSubstring: aRepoName) or: (each description includesSubstring: (aRepoName copyReplaceAll: '/' with: '\')) ]
]

{ #category : #accessing }
GitMigration >> ignoredFileNames: aCollection [
	ignoredFileNames := aCollection collect: [ :each | each withoutSuffix: '.mcz' ]
]

{ #category : #initialization }
GitMigration >> initialize [
	super initialize.
	completeAncestryCache := Dictionary new.
	selectedPackageNames := #().
	ignoredFileNames := #().
	onEmptyMessage := [ :info | self error: 'Empty message was requested' ]
]

{ #category : #'topology sorting' }
GitMigration >> isRoot: aKey in: pairs [
	^ pairs noneSatisfy: [ :pair | pair value = aKey ]
]

{ #category : #accessing }
GitMigration >> onEmptyMessage: aBlock [
	onEmptyMessage := aBlock
]

{ #category : #accessing }
GitMigration >> packagesWithMultipleRoots [
	| multiRoots |
	multiRoots := Dictionary new.
	self versionsByPackage
		keysAndValuesDo: [ :pkgName :versions | 
			| roots |
			roots := (self completeAncestryOfPackageNamed: pkgName)
				select: [ :each | each ancestors isEmpty ].
			roots size > 1
				ifTrue: [ multiRoots at: pkgName put: roots ] ].
	^ multiRoots
]

{ #category : #actions }
GitMigration >> populateCaches [
	self
		do: [ self versionsWithPackageNames.
			self versions ]
		displaying: 'Preparing data...'
]

{ #category : #import }
GitMigration >> preCheckOn: aVersion [
	"NOTE: do not touch snapshot without performing veryDeepCopy first"

	aVersion info message
		ifEmpty: [ self
				assert: [ onEmptyMessage isNotNil and: [ (onEmptyMessage cull: aVersion info) isNotEmpty ] ]
				description: [ 'You must provide onEmptyMessage.' ] ]
]

{ #category : #import }
GitMigration >> preChecksOn: aVersionList [
	aVersionList do: [ :each | self preCheckOn: each ]
]

{ #category : #accessing }
GitMigration >> projectName: aProjectName [
	repository := self findRepositoryNamed: aProjectName
]

{ #category : #accessing }
GitMigration >> repository [
	^ repository
]

{ #category : #accessing }
GitMigration >> selectedPackageNames: aCollection [
	selectedPackageNames := aCollection
]

{ #category : #'topology sorting' }
GitMigration >> topologicallySort: anAncestry [
	| ancestry |
	anAncestry size = 1
		ifTrue: [ ^ anAncestry asOrderedCollection ].
	ancestry := anAncestry asArray
		flatCollect: [ :each | 
			each ancestors collect: [ :anc | anc -> each ] ].
	^ self topologicallySortPairs: ancestry
]

{ #category : #'topology sorting' }
GitMigration >> topologicallySortPairs: anArray [
	| in out pairs |
	in := Set new.
	out := OrderedCollection new.
	pairs := anArray asOrderedCollection.
	in addAll: (pairs select: [ :pair | self isRoot: pair key in: pairs ] thenCollect: #key).
	[ in isNotEmpty ]
		whileTrue: [ | current next |
			current := in detectMin: #timeStamp.
			in remove: current.
			out add: current.
			next := pairs select: [ :pair | pair key = current ].
			pairs removeAll: next.
			in addAll: (next collect: #value thenSelect: [ :each | self isRoot: each in: pairs ]) ].
	^ out
]

{ #category : #import }
GitMigration >> useAuthorsOn: aWriter [
	(authors isNil or: [ authors isEmpty ])
		ifTrue: [ self error: 'Please provide authors.' ].
	authors
		keysAndValuesDo: [ :key :duet | 
			aWriter authorMapping
				shortName: key
				name: duet first
				email: ((duet second withoutPrefix: '<') withoutSuffix: '>') ]
]

{ #category : #retrieving }
GitMigration >> versionFromFileNamed: aFileName [
	^ MCCacheRepository uniqueInstance versionReaderForFileNamed: aFileName do: #version
]

{ #category : #retrieving }
GitMigration >> versionInfoFromFileNamed: aFileName [
	^ MCCacheRepository uniqueInstance versionInfoFromFileNamed: aFileName
]

{ #category : #accessing }
GitMigration >> versions [
	versionsCache
		ifNil: [ | versions |
			versions := OrderedCollection new.
			self versionsWithPackageNames
				do: [ :quad | 
					| fileName |
					fileName := quad last.
					(ignoredFileNames includes: (fileName allButLast: 4))
						ifFalse: [ versions add: (self versionFromFileNamed: quad last) ] ]
				displayingProgress: [ :quad | 'Loading versions metadata... ' , quad last ].
			versionsCache := versions ].
	^ versionsCache
]

{ #category : #accessing }
GitMigration >> versionsByPackage [
	| versionsByPackage |
	versionsByPackage := Dictionary new.
	self versionsInfo
		do: [ :version | 
			(versionsByPackage
				at: (version name copyUpToLast: $-)
				ifAbsentPut: [ OrderedCollection new ]) add: version ].
	^ versionsByPackage
]

{ #category : #accessing }
GitMigration >> versionsInfo [
	^ self versions collect: #info
]

{ #category : #import }
GitMigration >> versionsToMigrate [
	| totalOrdering versions |
	totalOrdering := self commitOrder.
	versions := totalOrdering
		collect: [ :info | self versions detect: [ :version | version info = info ] ].
	versions removeAllSuchThat: [ :each | ignoredFileNames includes: each info name ].
	^ versions
]

{ #category : #accessing }
GitMigration >> versionsWithPackageNames [
	^ versionsWithPackageNames
		ifNil: [ | all selected |
			all := repository versionsWithPackageNames.
			versionsWithPackageNames := selectedPackageNames
				ifEmpty: [ all ]
				ifNotEmpty: [ all select: [ :each | selectedPackageNames includes: each first ] ] ]
]

{ #category : #visualizations }
GitMigration >> visualization [
	^ GitMigrationVisualization new migration: self
]

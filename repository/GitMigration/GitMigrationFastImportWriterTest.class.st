Class {
	#name : #GitMigrationFastImportWriterTest,
	#superclass : #TestCase,
	#instVars : [
		'stream',
		'writer',
		'authorMapping',
		'committer'
	],
	#category : 'GitMigration-Tests'
}

{ #category : #testing }
GitMigrationFastImportWriterTest class >> isAbstract [
	^ self = GitMigrationFastImportWriterTest
]

{ #category : #running }
GitMigrationFastImportWriterTest >> ensureAllCached [
	(MCCacheRepository uniqueInstance directory children
		noneSatisfy: [ :each | each basename = 'Somewhere-PeterUhnak.2.mcz' ])
		ifTrue: [ (GitMigration on: 'peteruhnak/breaking-mcz') cacheAllVersions ]
]

{ #category : #running }
GitMigrationFastImportWriterTest >> ensureGitFileTreeLoaded [
	(Smalltalk hasClassNamed: #MCFileTreeGitRepository)
		ifFalse: [ (CatalogProvider projectNamed: 'GitFileTree') installVersion: #stable ]
]

{ #category : #running }
GitMigrationFastImportWriterTest >> ensureTestRepoLoaded [
	| repo |
	repo := MCSmalltalkhubRepository new.
	repo owner: 'peteruhnak'.
	repo project: 'breaking-mcz'.
	MCRepositoryGroup default addRepository: repo
]

{ #category : #running }
GitMigrationFastImportWriterTest >> setUp [
	super setUp.
	self timeLimit: 1 minute.
	self ensureTestRepoLoaded.
	"	self ensureGitFileTreeLoaded."
	self ensureAllCached.
	stream := String new writeStream.
	authorMapping := GitMigrationAuthorMapping new
		shortName: 'ImportBot' name: 'Import Bot' email: 'importbot@example.com';
		shortName: 'CommitterBot' name: 'Committer Bot' email: 'committerbot@example.com'.
	committer := authorMapping at: 'CommitterBot'.
	writer := self writerClass new on: stream.
	writer committerName: committer shortName.
	writer authorMapping: authorMapping
]

{ #category : #tests }
GitMigrationFastImportWriterTest >> testWriteDeletePackage [
	| contents v1 |
	MCCacheRepository uniqueInstance
		versionReaderForFileNamed: 'Somewhere-PeterUhnak.1.mcz'
		do: [ :v | v1 := v ].
	writer writeDeletePackageFor: v1.
	contents := stream contents.
	self assert: contents equals: 'D Somewhere.package
'
]

{ #category : #tests }
GitMigrationFastImportWriterTest >> testWriteDeletePackage2 [
	| contents v1 |
	writer exportDirectory: 'repository'.
	MCCacheRepository uniqueInstance
		versionReaderForFileNamed: 'CoSomewhere-PeterUhnak.1.mcz'
		do: [ :v | v1 := v ].
	writer writeDeletePackageFor: v1.
	contents := stream contents.
	self assert: contents equals: 'D repository/CoSomewhere.package
'
]

{ #category : #'tests - writing' }
GitMigrationFastImportWriterTest >> testWriteInitialVersion [
	| v1 contents dtNow |
	writer initialCommit: '1234567890'.
	writer authorMapping
		shortName: 'PeterUhnak'
		name: 'Peter Uhnak'
		email: 'i.uhnak@gmail.com'.
	MCCacheRepository uniqueInstance
		versionReaderForFileNamed: 'Somewhere-PeterUhnak.1.mcz'
		do: [ :v | v1 := v ].
	writer writeVersion: v1.
	contents := stream contents.
	"hack to extract the DateAndTime now inside, which is not straightforward to test"
	dtNow := (contents lines fourth splitOn: '> ') last.
	self
		assert: (contents lines first: 8)
		equals:
			('commit refs/heads/master
mark :1
author Peter Uhnak <i.uhnak@gmail.com> 1493283372 +0000
committer Committer Bot <committerbot@example.com> {1}
data 7
initial
from 1234567890
D Somewhere.package' format: {dtNow}) lines
]

{ #category : #'tests - writing' }
GitMigrationFastImportWriterTest >> testWriteVersion [
	| v1 v2 |
	writer initialCommit: '1234567890'.
	writer authorMapping
		shortName: 'PeterUhnak'
		name: 'Peter Uhnak'
		email: 'i.uhnak@gmail.com'.
	MCCacheRepository uniqueInstance
		versionReaderForFileNamed: 'Somewhere-PeterUhnak.1.mcz'
		do: [ :v | v1 := v ].
	MCCacheRepository uniqueInstance
		versionReaderForFileNamed: 'Somewhere-PeterUhnak.2.mcz'
		do: [ :v | v2 := v ].
	writer availableVersions: (Array with: v1 info with: v2 info).
	writer writeVersion: v1.
	stream reset.
	writer writeVersion: v2.
	self
		assert: ((stream contents lines first: 7) copyWithoutIndex: 4)
		equals:
			#('commit refs/heads/master' 'mark :2' 'author Peter Uhnak <i.uhnak@gmail.com> 1493283388 +0000' 'data 5' 'qwrqw' 'D Somewhere.package')
]

{ #category : #'tests - writing' }
GitMigrationFastImportWriterTest >> testWriteVersionDeletePackage [
	| v1 v2 |
	writer exportDirectory: 'repository'.
	writer initialCommit: '1234567890'.
	writer authorMapping
		shortName: 'PeterUhnak'
		name: 'Peter Uhnak'
		email: 'i.uhnak@gmail.com'.
	MCCacheRepository uniqueInstance
		versionReaderForFileNamed: 'Somewhere-PeterUhnak.1.mcz'
		do: [ :v | v1 := v ].
	MCCacheRepository uniqueInstance
		versionReaderForFileNamed: 'Somewhere-PeterUhnak.2.mcz'
		do: [ :v | v2 := v ].
	writer availableVersions: (Array with: v1 info with: v2 info).
	writer writeVersion: v1.
	stream reset.
	writer writeVersion: v2.
	self assert: (stream contents lines includes: 'D repository/Somewhere.package')
]

{ #category : #'tests - writing' }
GitMigrationFastImportWriterTest >> testWriteVersionDeletePackageTrimmed [
	| v1 v2 |
	writer initialCommit: '1234567890'.
	writer authorMapping
		shortName: 'PeterUhnak'
		name: 'Peter Uhnak'
		email: 'i.uhnak@gmail.com'.
	MCCacheRepository uniqueInstance
		versionReaderForFileNamed: 'Somewhere-PeterUhnak.1.mcz'
		do: [ :v | v1 := v ].
	MCCacheRepository uniqueInstance
		versionReaderForFileNamed: 'Somewhere-PeterUhnak.2.mcz'
		do: [ :v | v2 := v ].
	writer availableVersions: (Array with: v1 info with: v2 info).
	writer writeVersion: v1.
	stream reset.
	writer writeVersion: v2.
	self assert: stream contents lines seventh equals: 'D Somewhere.package'
]

{ #category : #'tests - writing' }
GitMigrationFastImportWriterTest >> testWriteVersionUnicode [
	| v1 lines firstLine |
	writer initialCommit: '1234567890'.
	writer authorMapping
		shortName: 'PeterUhnak'
		name: 'Peter Uhnak'
		email: 'i.uhnak@gmail.com'.
	MCCacheRepository uniqueInstance
		versionReaderForFileNamed: 'CoSomewhere-PeterUhnak.5.mcz'
		do: [ :v | v1 := v ].
	writer availableVersions: (Array with: v1 info).
	writer writeVersion: v1.
	lines := stream contents lines.
	firstLine := lines indexOf: (lines detect: [ :each | each includesSubstring: 'CoSomething.class/README.md' ]).
	self
		assert:
			{lines at: firstLine.
			lines at: firstLine + 1.
			lines at: firstLine + 2}
		equals: #('M 100644 inline CoSomewhere.package/CoSomething.class/README.md' 'data 6' '你好').
	firstLine := lines indexOf: (lines detect: [ :each | each includesSubstring: 'CoSomething.class/instance/unicode.st' ]).
	self
		assert:
			{lines at: firstLine.
			lines at: firstLine + 1.
			lines at: firstLine + 3.
			lines at: firstLine + 4}
		equals:
			#('M 100644 inline CoSomewhere.package/CoSomething.class/instance/unicode.st' 'data 39' 'unicode' '	^ ''彼得''')
]

{ #category : #'instance creation' }
GitMigrationFastImportWriterTest >> versionWithTwoAncestors [
	^ MCVersionInfo
		name: 'FastImported-ImportBot.3'
		id: UUID new
		message: 'merge'
		date: Date today
		time: Time now
		author: 'ImportBot'
		ancestors:
			{self versionWithoutParent.
			self versionWithoutParent}
]

{ #category : #'instance creation' }
GitMigrationFastImportWriterTest >> versionWithoutParent [
	^ MCVersionInfo
		name: 'FastImported-ImportBot.1'
		id: UUID new
		message: 'Initial MC commit'
		date: (Date year: 2000 month: 12 day: 20)
		time: (Time hour: 16 minute: 20 second: 30)
		author: 'ImportBot'
		ancestors: #()
]

{ #category : #accessing }
GitMigrationFastImportWriterTest >> writerClass [
	^ self subclassResponsibility
]

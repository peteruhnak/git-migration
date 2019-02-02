Class {
	#name : #GitMigrationTonelWriterTest,
	#superclass : #GitMigrationFastImportWriterTest,
	#category : 'GitMigration-Tests'
}

{ #category : #'tests - writing' }
GitMigrationTonelWriterTest >> testEnsureContainsOrganization [
	| version store |
	"https://github.com/peteruhnak/git-migration/issues/16"
	store := writer newMemoryStore.
	version := MCVersion
		package: (MCPackage named: 'XYZ')
		info: self versionWithoutParent
		snapshot: (MCSnapshot fromDefinitions: OrderedCollection new).
	writer copyPackageIn: version toStore: store.
	self
		assert: (store / 'XYZ' / 'package.st') contents trimmed
		equals: 'Package { #name : #XYZ }'
]

{ #category : #tests }
GitMigrationTonelWriterTest >> testWriteDeletePackage [
	| contents v1 |
	MCCacheRepository uniqueInstance
		versionReaderForFileNamed: 'Somewhere-PeterUhnak.1.mcz'
		do: [ :v | v1 := v ].
	writer writeDeletePackageFor: v1.
	contents := stream contents.
	self assert: contents equals: 'D Somewhere
' withUnixLineEndings
]

{ #category : #tests }
GitMigrationTonelWriterTest >> testWriteDeletePackage2 [
	| contents v1 |
	writer exportDirectory: 'repository'.
	MCCacheRepository uniqueInstance
		versionReaderForFileNamed: 'CoSomewhere-PeterUhnak.1.mcz'
		do: [ :v | v1 := v ].
	writer writeDeletePackageFor: v1.
	contents := stream contents.
	self assert: contents equals: 'D repository/CoSomewhere
' withUnixLineEndings
]

{ #category : #'tests - writing' }
GitMigrationTonelWriterTest >> testWriteInitialVersion [
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
D Somewhere' format: {dtNow}) lines
]

{ #category : #'tests - writing' }
GitMigrationTonelWriterTest >> testWriteInitialVersionEmptyMessage [
	| v1 contents dtNow |
	writer initialCommit: '1234567890'.
	writer authorMapping
		shortName: 'PeterUhnak'
		name: 'Peter Uhnak'
		email: 'i.uhnak@gmail.com'.
	MCCacheRepository uniqueInstance
		versionReaderForFileNamed: 'EverythingIsBurning-PeterUhnak.1.mcz'
		do: [ :v | v1 := v ].
	writer onEmptyMessage: [ :info | 'replacement message for >' , info name , '<' ].
	writer writeVersion: v1.
	contents := stream contents.
	"hack to extract the DateAndTime now inside, which is not straightforward to test"
	dtNow := (contents lines fourth splitOn: '> ') last.
	self
		assert: (contents lines first: 8)
		equals:
			('commit refs/heads/master
mark :1
author Peter Uhnak <i.uhnak@gmail.com> 1538689956 +0000
committer Committer Bot <committerbot@example.com> {1}
data 58
replacement message for >EverythingIsBurning-PeterUhnak.1<
from 1234567890
D EverythingIsBurning' format: {dtNow}) lines
]

{ #category : #'tests - writing' }
GitMigrationTonelWriterTest >> testWriteInitialVersionEmptyMessageError [
	| v1 |
	writer initialCommit: '1234567890'.
	writer authorMapping shortName: 'PeterUhnak' name: 'Peter Uhnak' email: 'i.uhnak@gmail.com'.
	MCCacheRepository uniqueInstance
		versionReaderForFileNamed: 'EverythingIsBurning-PeterUhnak.1.mcz'
		do: [ :v | v1 := v ].
	self should: [ writer writeVersion: v1 ] raise: Error
]

{ #category : #'tests - writing' }
GitMigrationTonelWriterTest >> testWriteProject [
	| v1 |
	writer exportDirectory: 'repository'.
	writer initialCommit: '1234567890'.
	writer authorMapping
		shortName: 'PeterUhnak'
		name: 'Peter Uhnak'
		email: 'i.uhnak@gmail.com'.
	MCCacheRepository uniqueInstance
		versionReaderForFileNamed: 'Somewhere-PeterUhnak.1.mcz'
		do: [ :v | v1 := v ].
	writer availableVersions: (Array with: v1 info).
	writer writeVersion: v1.
	self deny: (stream contents lines includes: 'M 100644 inline repository/.project').
	self assert: (stream contents lines includes: 'M 100644 inline .project').
	self assert: (stream contents lines includes: '	''srcDirectory'' : ''repository''').
]

{ #category : #'tests - writing' }
GitMigrationTonelWriterTest >> testWriteProperties [
	| v1 |
	writer exportDirectory: 'repository'.
	writer initialCommit: '1234567890'.
	writer authorMapping
		shortName: 'PeterUhnak'
		name: 'Peter Uhnak'
		email: 'i.uhnak@gmail.com'.
	MCCacheRepository uniqueInstance
		versionReaderForFileNamed: 'Somewhere-PeterUhnak.1.mcz'
		do: [ :v | v1 := v ].
	writer availableVersions: (Array with: v1 info).
	writer writeVersion: v1.
	self assert: (stream contents lines includes: 'M 100644 inline repository/.properties')
]

{ #category : #'tests - writing' }
GitMigrationTonelWriterTest >> testWriteVersion [
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
			#('commit refs/heads/master' 'mark :2' 'author Peter Uhnak <i.uhnak@gmail.com> 1493283388 +0000' 'data 5' 'qwrqw' 'D Somewhere')
]

{ #category : #'tests - writing' }
GitMigrationTonelWriterTest >> testWriteVersionDeletePackage [
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
	self assert: (stream contents lines includes: 'D repository/Somewhere')
]

{ #category : #'tests - writing' }
GitMigrationTonelWriterTest >> testWriteVersionDeletePackageTrimmed [
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
	self assert: stream contents lines seventh equals: 'D Somewhere'
]

{ #category : #'tests - writing' }
GitMigrationTonelWriterTest >> testWriteVersionUnicode [
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
	firstLine := lines
		indexOf: (lines detect: [ :each | each includesSubstring: 'CoSomething.class.st' ]).
	self
		assert: ((lines copyFrom: firstLine to: firstLine + 4) copyWithoutIndex: 2)
		equals: #('M 100644 inline CoSomewhere/CoSomething.class.st' '"' '你好' '"').
	firstLine := lines
		indexOf: (lines detect: [ :each | each includesSubstring: 'CoSomething >> unicode [' ]).
	self
		assert: (lines copyFrom: firstLine to: firstLine + 2)
		equals: #('CoSomething >> unicode [' '	^ ''彼得''' ']')
]

{ #category : #accessing }
GitMigrationTonelWriterTest >> writerClass [
	^ GitMigrationTonelWriter
]

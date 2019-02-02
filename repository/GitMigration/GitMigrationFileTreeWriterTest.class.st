Class {
	#name : #GitMigrationFileTreeWriterTest,
	#superclass : #GitMigrationFastImportWriterTest,
	#category : 'GitMigration-Tests'
}

{ #category : #tests }
GitMigrationFileTreeWriterTest >> testWriteDeletePackage [
	| contents v1 |
	MCCacheRepository uniqueInstance
		versionReaderForFileNamed: 'Somewhere-PeterUhnak.1.mcz'
		do: [ :v | v1 := v ].
	writer writeDeletePackageFor: v1.
	contents := stream contents.
	self
		assert: contents
		equals:
			'D Somewhere.package
' withUnixLineEndings
]

{ #category : #tests }
GitMigrationFileTreeWriterTest >> testWriteDeletePackage2 [
	| contents v1 |
	writer exportDirectory: 'repository'.
	MCCacheRepository uniqueInstance
		versionReaderForFileNamed: 'CoSomewhere-PeterUhnak.1.mcz'
		do: [ :v | v1 := v ].
	writer writeDeletePackageFor: v1.
	contents := stream contents.
	self
		assert: contents
		equals:
			'D repository/CoSomewhere.package
' withUnixLineEndings
]

{ #category : #'tests - writing' }
GitMigrationFileTreeWriterTest >> testWriteInitialVersion [
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
GitMigrationFileTreeWriterTest >> testWriteVersion [
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
GitMigrationFileTreeWriterTest >> testWriteVersionDeletePackage [
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
GitMigrationFileTreeWriterTest >> testWriteVersionDeletePackageTrimmed [
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
GitMigrationFileTreeWriterTest >> testWriteVersionUnicode [
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

{ #category : #accessing }
GitMigrationFileTreeWriterTest >> writerClass [
	^ GitMigrationFileTreeWriter
]

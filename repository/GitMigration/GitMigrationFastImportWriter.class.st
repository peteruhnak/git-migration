"
I convert MC commits into git commits with the use of git fast-import.
During my operation I store the result into memory to avoid slow disk operations.
"
Class {
	#name : #GitMigrationFastImportWriter,
	#superclass : #Object,
	#instVars : [
		'authorMapping',
		'committerName',
		'initialCommit',
		'availableVersions',
		'exportDirectory',
		'fastWriter',
		'lastAuthors',
		'onEmptyMessage'
	],
	#category : #'GitMigration-FastImport'
}

{ #category : #accessing }
GitMigrationFastImportWriter >> authorMapping [
	^ authorMapping
]

{ #category : #accessing }
GitMigrationFastImportWriter >> authorMapping: anObject [
	authorMapping := anObject
]

{ #category : #accessing }
GitMigrationFastImportWriter >> authorsInSnapshot: aSnapshot [
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

{ #category : #accessing }
GitMigrationFastImportWriter >> availableVersions: aCollection [
	availableVersions := (aCollection collect: [ :each | each -> true ]) asDictionary
]

{ #category : #converting }
GitMigrationFastImportWriter >> commitInfoFor: aVersion [
	| snapshotAuthors packageName previousAuthors |
	packageName := aVersion package name.
	snapshotAuthors := self authorsInSnapshot: aVersion snapshot.
	previousAuthors := lastAuthors at: packageName ifAbsent: [ {} ].
	lastAuthors at: packageName put: snapshotAuthors.
	^ GitMigrationCommitInfo
		info: aVersion info
		mapping: authorMapping
		committer: (authorMapping at: committerName)
		coauthors: snapshotAuthors \ previousAuthors
		onEmptyMessage: onEmptyMessage
]

{ #category : #accessing }
GitMigrationFastImportWriter >> commitMarkFor: aVersionInfo [
	^ fastWriter commitMarkFor: aVersionInfo
]

{ #category : #accessing }
GitMigrationFastImportWriter >> commitMarks [
	^ fastWriter commitMarks
]

{ #category : #accessing }
GitMigrationFastImportWriter >> committerName: aCommitterName [
	committerName := aCommitterName
]

{ #category : #accessing }
GitMigrationFastImportWriter >> exportDirectory [
	^ exportDirectory
]

{ #category : #accessing }
GitMigrationFastImportWriter >> exportDirectory: anObject [
	exportDirectory := anObject
]

{ #category : #accessing }
GitMigrationFastImportWriter >> initialCommit: aString [
	initialCommit := aString
]

{ #category : #initialization }
GitMigrationFastImportWriter >> initialize [
	super initialize.
	authorMapping := GitMigrationAuthorMapping new.
	committerName := Author fullName.
	availableVersions := Dictionary new.
	exportDirectory := '/'.
	fastWriter := GitFastImportFileWriter new.
	lastAuthors := Dictionary new.
	onEmptyMessage := [ self error: 'No alternative message was provided' ]
]

{ #category : #initialization }
GitMigrationFastImportWriter >> on: aStream [
	fastWriter on: aStream.
]

{ #category : #accessing }
GitMigrationFastImportWriter >> onEmptyMessage: aBlock [
	onEmptyMessage := aBlock
]

{ #category : #writing }
GitMigrationFastImportWriter >> writeDeletePackageFor: aVersion [
	self subclassResponsibility
]

{ #category : #writing }
GitMigrationFastImportWriter >> writeVersion: aVersion [
	^ self subclassResponsibility
]

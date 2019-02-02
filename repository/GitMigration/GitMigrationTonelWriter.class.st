Class {
	#name : #GitMigrationTonelWriter,
	#superclass : #GitMigrationFastImportWriter,
	#category : 'GitMigration-FastImport'
}

{ #category : #'writing - memory' }
GitMigrationTonelWriter >> copyPackageIn: aVersion toStore: memoryStore [
	self ensureContainsOrganization: aVersion.
	TonelWriter fileOut: aVersion on: memoryStore.
	self writePropertiesFileTo: memoryStore
]

{ #category : #writing }
GitMigrationTonelWriter >> ensureContainsOrganization: aVersion [
	aVersion snapshot definitions
		detect: #isOrganizationDefinition
		ifFound: [ :each | each ]
		ifNone: [ aVersion snapshot definitions add: (MCOrganizationDefinition categories: {aVersion package name}) ]
]

{ #category : #writing }
GitMigrationTonelWriter >> newMemoryStore [
	^ FileSystem unicodeMemory root ensureCreateDirectory
]

{ #category : #writing }
GitMigrationTonelWriter >> writeDeletePackageFor: aVersion [
	fastWriter
		writeDeleteReference: FileSystem unicodeMemory root / exportDirectory / aVersion package name
]

{ #category : #writing }
GitMigrationTonelWriter >> writeProjectFileTo: aDirectory [
	(aDirectory parent / '.project')
		ensureDelete;
		writeStreamDo: [ :stream | 
			(STONWriter on: stream)
				prettyPrint: true;
				newLine: OSPlatform current lineEnding;
				nextPut: {'srcDirectory' -> aDirectory basename} asDictionary ]
]

{ #category : #'writing - memory' }
GitMigrationTonelWriter >> writePropertiesFileTo: aDirectory [
	(aDirectory / IceRepositoryProperties propertiesFileName)
		ensureDelete;
		writeStreamDo: [ :stream | 
			(STONWriter on: stream)
				prettyPrint: true;
				newLine: OSPlatform current lineEnding;
				nextPut: {#format -> #tonel} asDictionary ]
]

{ #category : #writing }
GitMigrationTonelWriter >> writeVersion: aVersion [
	| commitInfo memoryStore |
	commitInfo := self commitInfoFor: aVersion.
	fastWriter writeCommitPreambleFor: commitInfo.
	(self commitMarkFor: commitInfo) = 1
		ifTrue: [ fastWriter writeLine: 'from ' , initialCommit ].
	memoryStore := self newMemoryStore / exportDirectory.
	self writeDeletePackageFor: aVersion.
	self copyPackageIn: aVersion toStore: memoryStore.
	self writeProjectFileTo: memoryStore.
	fastWriter writeDirectoryTreeInlineFor: memoryStore parent
]

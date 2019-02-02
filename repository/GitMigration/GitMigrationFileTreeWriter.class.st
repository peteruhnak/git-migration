Class {
	#name : #GitMigrationFileTreeWriter,
	#superclass : #GitMigrationFastImportWriter,
	#category : 'GitMigration-FastImport'
}

{ #category : #writing }
GitMigrationFileTreeWriter >> writeDeletePackageFor: aVersion [
	| path |
	path := FileSystem unicodeMemory root / exportDirectory / aVersion package name , 'package'.
	fastWriter writeDeleteReference: path
]

{ #category : #writing }
GitMigrationFileTreeWriter >> writeVersion: aVersion [
	| repository memoryFileOut commitInfo |
	commitInfo := self commitInfoFor: aVersion.
	fastWriter writeCommitPreambleFor: commitInfo.
	(self commitMarkFor: commitInfo) = 1
		ifTrue: [ fastWriter writeLine: 'from ' , initialCommit ].
	(memoryFileOut := (FileSystem store: GitFastImportMemoryStore new) root / exportDirectory)
		ensureCreateDirectory.
	repository := GitMigrationMemoryTreeGitRepository new.
	repository directory: memoryFileOut.
	repository memoryStoreVersion: aVersion.
	self writeDeletePackageFor: aVersion.
	fastWriter writeDirectoryTreeInlineFor: memoryFileOut
]

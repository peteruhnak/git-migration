"
I modify my parent to store the code into a memory. Additionally I don't perform any actual commits -- that's for FastImport to do.
"
Class {
	#name : #GitMigrationMemoryTreeGitRepository,
	#superclass : #MCFileTreeRepository,
	#category : 'GitMigration-FileSystem'
}

{ #category : #storing }
GitMigrationMemoryTreeGitRepository >> memoryStoreVersion: aVersion [
	"Dump the mcz contents into a memory filetree without performing any commits."

	| packageDirectoryString |
	IceMetadatalessFileTreeWriter fileOut: aVersion on: self.
	packageDirectoryString := (self class parseName: aVersion info name) first
		, self packageExtension.
	aVersion dependencies notEmpty
		ifTrue: [ self
				writeGitFileTreeProperties: (self fileUtils directoryFromPath: packageDirectoryString relativeTo: directory) ]
]

storing
memoryStoreVersion: aVersion
	"Dump the mcz contents into a memory filetree without performing any commits."

	| packageDirectoryString |
	IceMetadatalessFileTreeWriter fileOut: aVersion on: self.
	packageDirectoryString := (self class parseName: aVersion info name) first
		, self packageExtension.
	aVersion dependencies notEmpty
		ifTrue: [ self
				writeGitFileTreeProperties: (self fileUtils directoryFromPath: packageDirectoryString relativeTo: directory) ]
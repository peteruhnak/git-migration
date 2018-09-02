writing
writeVersion: aVersion
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
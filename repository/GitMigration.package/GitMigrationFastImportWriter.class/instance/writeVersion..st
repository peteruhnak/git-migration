writing
writeVersion: aVersion
	| repository memoryFileOut commitInfo |
	commitInfo := self commitInfoFor: aVersion info.
	self writeCommitPreambleFor: commitInfo.
	(self commitMarkFor: commitInfo info) = 1
		ifTrue: [ writeStream << ('from ' , initialCommit, String cr) ].
	(memoryFileOut := (FileSystem store: GitMigrationMemoryStore new) root / exportDirectory)
		ensureCreateDirectory.
	repository := GitMigrationMemoryTreeGitRepository new.
	repository directory: memoryFileOut.
	repository memoryStoreVersion: aVersion.
	self writeDeletePackageFor: aVersion.
	self writeDirectoryTreeInlineFor: memoryFileOut
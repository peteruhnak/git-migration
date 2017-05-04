writing
writeVersion: aVersion
	| repository memoryFileOut |
	self writeCommitPreambleFor: aVersion info.
	self writeAncestorsFor: aVersion info.
	(memoryFileOut := (FileSystem store: GitMigrationMemoryStore new) root / exportDirectory)
		ensureCreateDirectory.
	repository := GitMigrationMemoryTreeGitRepository new.
	repository directory: memoryFileOut.
	repository memoryStoreVersion: aVersion.
	self writeDirectoryTreeInlineFor: memoryFileOut
converting
commitInfoFor: aVersionInfo
	^ GitMigrationCommitInfo
		info: aVersionInfo
		mapping: authorMapping
		committer: (authorMapping at: committerName)
converting
commitInfoFor: aVersion
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
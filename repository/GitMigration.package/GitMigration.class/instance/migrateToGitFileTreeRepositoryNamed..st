actions
migrateToGitFileTreeRepositoryNamed: aRepositoryName
	| targetRepo totalOrdering oldNamesMap |
	self cacheAllVersions.
	targetRepo := self findRepositoryNamed: aRepositoryName.
	totalOrdering := self commitOrder.
	oldNamesMap := MCFileTreeGitRepository namesMap.
	[ self setAuthorMappings.
	self pushAllVersions: totalOrdering to: targetRepo ]
		ensure: [ MCFileTreeGitRepository namesMap: oldNamesMap ]
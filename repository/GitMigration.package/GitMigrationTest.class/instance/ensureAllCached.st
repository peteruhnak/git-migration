running
ensureAllCached
	(MCCacheRepository uniqueInstance versionInfoFromFileNamed: 'Somewhere-PeterUhnak.2.mcz')
		ifNotNil: [ ^ self ].
	migration cacheAllVersions
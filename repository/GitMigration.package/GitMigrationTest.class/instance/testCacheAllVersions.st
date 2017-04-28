tests - actions
testCacheAllVersions
	| version |
	migration cacheAllVersions.
	version := MCCacheRepository uniqueInstance
		versionInfoFromFileNamed: 'Somewhere-PeterUhnak.2.mcz'.
	self assert: version name equals: 'Somewhere-PeterUhnak.2'
running
ensureAllCached
	(MCCacheRepository uniqueInstance directory children
		noneSatisfy: [ :each | each basename = 'Somewhere-PeterUhnak.2.mcz' ])
		ifTrue: [ migration cacheAllVersions ]
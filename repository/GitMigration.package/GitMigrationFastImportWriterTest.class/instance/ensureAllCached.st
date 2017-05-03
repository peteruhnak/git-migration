running
ensureAllCached
	(MCCacheRepository uniqueInstance directory children
		noneSatisfy: [ :each | each basename = 'Somewhere-PeterUhnak.2.mcz' ])
		ifTrue: [ (GitMigration on: 'peteruhnak/breaking-mcz') cacheAllVersions ]
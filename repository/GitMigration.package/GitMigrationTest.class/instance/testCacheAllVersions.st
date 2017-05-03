tests - actions
testCacheAllVersions
	| version |
	self
		skip:
			'skipped because caches are flushed which tries to flush git memory repos, which are not real git repos (normally they would be GCed https://travis-ci.org/peteruhnak/git-migration/jobs/228516344#L493)'.
	migration cacheAllVersions.
	version := MCCacheRepository uniqueInstance
		versionInfoFromFileNamed: 'Somewhere-PeterUhnak.2.mcz'.
	self assert: version name equals: 'Somewhere-PeterUhnak.2'
tests - writing
testWriteVersion
	| v1 v2 |
"	self
		skip:
			'skipped because caches are flushed which tries to flush git memory repos, which are not real git repos (normally they would be GCed https://travis-ci.org/peteruhnak/git-migration/jobs/228516344#L493)'."
	writer initialCommit: '1234567890'.
	writer authorMapping
		shortName: 'PeterUhnak'
		name: 'Peter Uhnak'
		email: 'i.uhnak@gmail.com'.
	MCCacheRepository uniqueInstance
		versionReaderForFileNamed: 'Somewhere-PeterUhnak.1.mcz'
		do: [ :v | v1 := v ].
	MCCacheRepository uniqueInstance
		versionReaderForFileNamed: 'Somewhere-PeterUhnak.2.mcz'
		do: [ :v | v2 := v ].
	writer availableVersions: (Array with: v1 info with: v2 info).
	writer commitMarkFor: v1 info.
	writer writeVersion: v2.
	self
		assert: ((stream contents lines first: 7) copyWithoutIndex: 4)
		equals:
			#('commit refs/heads/master' 'mark :2' 'author Peter Uhnak <i.uhnak@gmail.com> 1493283388 +0000' 'data 5' 'qwrqw' 'merge :1')
tests - writing
testWriteVersionUnicode
	| v1 v2 lines |
"	self
		skip:
			'skipped because caches are flushed which tries to flush git memory repos, which are not real git repos (normally they would be GCed https://travis-ci.org/peteruhnak/git-migration/jobs/228516344#L493)'."
	writer initialCommit: '1234567890'.
	writer authorMapping
		shortName: 'PeterUhnak'
		name: 'Peter Uhnak'
		email: 'i.uhnak@gmail.com'.
	MCCacheRepository uniqueInstance
		versionReaderForFileNamed: 'CoSomewhere-PeterUhnak.5.mcz'
		do: [ :v | v1 := v ].
	writer availableVersions: (Array with: v1 info).
	writer writeVersion: v1.
	lines := stream contents lines.
	self
		assert:
			{lines at: 22.
			lines at: 23.
			lines at: 24}
		equals: #('M 100644 inline CoSomewhere.package/CoSomething.class/README.md' 'data 6' '你好').
	self
		assert:
			{lines at: 42.
			lines at: 43.
			lines at: 45.
			lines at: 46}
		equals:
			#('M 100644 inline CoSomewhere.package/CoSomething.class/instance/unicode.st' 'data 39' 'unicode' '	^ ''彼得''')
tests - writing
testWriteVersionUnicode
	| v1 lines firstLine |
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
	firstLine := lines indexOf: (lines detect: [ :each | each includesSubstring: 'CoSomething.class/README.md' ]).
	self
		assert:
			{lines at: firstLine.
			lines at: firstLine + 1.
			lines at: firstLine + 2}
		equals: #('M 100644 inline CoSomewhere.package/CoSomething.class/README.md' 'data 6' '你好').
	firstLine := lines indexOf: (lines detect: [ :each | each includesSubstring: 'CoSomething.class/instance/unicode.st' ]).
	self
		assert:
			{lines at: firstLine.
			lines at: firstLine + 1.
			lines at: firstLine + 3.
			lines at: firstLine + 4}
		equals:
			#('M 100644 inline CoSomewhere.package/CoSomething.class/instance/unicode.st' 'data 39' 'unicode' '	^ ''彼得''')
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
	firstLine := lines
		indexOf: (lines detect: [ :each | each includesSubstring: 'CoSomething.class.st' ]).
	self
		assert: ((lines copyFrom: firstLine to: firstLine + 4) copyWithoutIndex: 2)
		equals: #('M 100644 inline CoSomewhere/CoSomething.class.st' '"' '你好' '"').
	firstLine := lines
		indexOf: (lines detect: [ :each | each includesSubstring: 'CoSomething >> unicode [' ]).
	self
		assert: (lines copyFrom: firstLine to: firstLine + 2)
		equals: #('CoSomething >> unicode [' '	^ ''彼得''' ']')
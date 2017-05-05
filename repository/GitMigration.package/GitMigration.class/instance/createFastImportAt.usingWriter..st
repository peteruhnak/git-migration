fast import
createFastImportAt: anInitialCommitish usingWriter: aWriter
	| totalOrdering versions |
	aWriter initialCommit: anInitialCommitish.
	authors
		keysAndValuesDo: [ :key :duet | 
			aWriter authorMapping
				shortName: key
				name: duet first
				email: ((duet second withoutPrefix: '<') withoutSuffix: '>') ].
	'Caching all versions...'
		displayProgressFrom: 0
		to: 1
		during: [ :bar | 
			bar value: 0.
			self cacheAllVersions ].
	totalOrdering := self commitOrder.
	versions := totalOrdering
		collect: [ :each | 
			MCCacheRepository uniqueInstance
				versionReaderForFileNamed: each name , '.mcz'
				do: #version ].
	aWriter availableVersions: (versions collect: #info).
	versions
		do: [ :each | aWriter writeVersion: each ]
		displayingProgress: 'Processing commits...'
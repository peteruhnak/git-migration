import
createFastImportAt: anInitialCommitish usingWriter: aWriter
	| totalOrdering versions |
	aWriter initialCommit: anInitialCommitish.
	authors
		keysAndValuesDo: [ :key :duet | 
			aWriter authorMapping
				shortName: key
				name: duet first
				email: ((duet second withoutPrefix: '<') withoutSuffix: '>') ].
	self
		do: [ totalOrdering := self commitOrder.
			versions := totalOrdering
				collect: [ :info | self versions detect: [ :version | version info = info ] ] ]
		displaying: 'Ordering history...'.
	aWriter availableVersions: (versions collect: #info).
	versions
		do: [ :each | aWriter writeVersion: each veryDeepCopy ]
		displayingProgress: [ :each | 'Exporting version ', each info name ]
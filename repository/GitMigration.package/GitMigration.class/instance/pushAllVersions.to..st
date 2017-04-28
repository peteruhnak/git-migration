actions
pushAllVersions: anOrdering to: aRepository
	| versions |
	versions := anOrdering
		collect:
			[ :each | MCCacheRepository uniqueInstance versionReaderForFileNamed: each name , '.mcz' do: #version ].
	versions
		do: [ :each | aRepository fasterBasicStoreVersion: each ]
		displayingProgress: 'Processing commits...'
tests - writing
testWriteVersion
	| v1 v2 |
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
	writer writeVersion: v1.
	stream reset.
	writer writeVersion: v2.
	self
		assert: ((stream contents lines first: 7) copyWithoutIndex: 4)
		equals:
			#('commit refs/heads/master' 'mark :2' 'author Peter Uhnak <i.uhnak@gmail.com> 1493283388 +0000' 'data 5' 'qwrqw' 'D Somewhere.package')
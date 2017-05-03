tests - accessing
testAncestors
	| v9 v6 |
	"9 has parent 7 which doesn't have mcz, but 7 inherits from 6"
	MCCacheRepository uniqueInstance
		versionReaderForFileNamed: 'Somewhere-PeterUhnak.9.mcz'
		do: [ :v | v9 := v info ].
	MCCacheRepository uniqueInstance
		versionReaderForFileNamed: 'Somewhere-PeterUhnak.6.mcz'
		do: [ :v | v6 := v info ].
	writer availableVersions: (Array with: v6 with: v9).
	self assert: (writer ancestorsFor: v9) equals: {v6}
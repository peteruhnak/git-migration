tests
testWriteDeletePackage
	| contents v1 |
	MCCacheRepository uniqueInstance
		versionReaderForFileNamed: 'Somewhere-PeterUhnak.1.mcz'
		do: [ :v | v1 := v ].
	writer writeDeletePackageFor: v1.
	contents := stream contents.
	self assert: contents equals: 'D Somewhere.package
'
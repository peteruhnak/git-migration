tests
testWriteDeletePackage2
	| contents v1 |
	writer exportDirectory: 'repository'.
	MCCacheRepository uniqueInstance
		versionReaderForFileNamed: 'CoSomewhere-PeterUhnak.1.mcz'
		do: [ :v | v1 := v ].
	writer writeDeletePackageFor: v1.
	contents := stream contents.
	self assert: contents equals: 'D repository/CoSomewhere.package
'
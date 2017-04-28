tests - retrieving
testVersionInfo
	| version |
	migration cacheAllVersions.
	version := migration versionInfoFromFileNamed: 'Somewhere-PeterUhnak.2.mcz'.
	self assert: version name equals: 'Somewhere-PeterUhnak.2'
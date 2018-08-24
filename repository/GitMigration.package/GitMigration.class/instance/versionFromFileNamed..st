retrieving
versionFromFileNamed: aFileName
	^ MCCacheRepository uniqueInstance versionReaderForFileNamed: aFileName do: #version
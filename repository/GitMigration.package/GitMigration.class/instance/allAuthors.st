accessing
allAuthors
	^ (self cachedVersions values collect: #author) asSet asArray sorted
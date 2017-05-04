accessing
availableVersions: aCollection
	availableVersions := (aCollection collect: [ :each | each -> true ]) asDictionary
retrieving
loadAllCachedVersions
	| allDirectVersions allFiles |
	allDirectVersions := OrderedCollection new.
	allFiles := repository versionsWithPackageNames collect: #last.
	allFiles
		do: [ :each | allDirectVersions add: (self versionInfoFromFileNamed: each) ]
		displayingProgress: 'Extracting MCZ Metadata'.
	^ (allDirectVersions collect: [ :each | each name -> each ]) asDictionary
retrieving
loadAllCachedVersions
	| allDirectVersions allFiles dictionary |
	allDirectVersions := OrderedCollection new.
	allFiles := repository versionsWithPackageNames collect: #last.
	allFiles
		do: [ :each | allDirectVersions add: (self versionInfoFromFileNamed: each) ]
		displayingProgress: 'Extracting MCZ Metadata'.
	"Don't use #asDictionary in case some commits have duplicate name. Instead, override them."
	dictionary := Dictionary new.
	allDirectVersions do: [ :each | dictionary at: each name put: each ].
	^ dictionary
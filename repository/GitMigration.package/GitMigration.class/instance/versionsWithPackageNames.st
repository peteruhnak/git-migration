accessing
versionsWithPackageNames
	^ versionsWithPackageNames
		ifNil: [ versionsWithPackageNames := repository versionsWithPackageNames ]
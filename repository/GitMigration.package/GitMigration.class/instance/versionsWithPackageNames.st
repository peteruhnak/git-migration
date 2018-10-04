accessing
versionsWithPackageNames
	^ versionsWithPackageNames
		ifNil: [ | all selected |
			all := repository versionsWithPackageNames.
			versionsWithPackageNames := selectedPackageNames
				ifEmpty: [ all ]
				ifNotEmpty: [ all select: [ :each | selectedPackageNames includes: each first ] ] ]
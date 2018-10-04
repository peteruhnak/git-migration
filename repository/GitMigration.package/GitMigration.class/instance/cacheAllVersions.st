actions
cacheAllVersions
	| goSource allPackageNames packageNames|
	goSource := Gofer new repository: repository.
	allPackageNames := (repository allVersionNames collect: [ :each | each copyUpToLast: $- ]) asSet.
	packageNames := selectedPackageNames ifEmpty: [ allPackageNames ].
	(goSource allResolved
		select: [ :resolved | packageNames includes: resolved packageName ])
		do: [ :each | goSource package: each packageName ].
	goSource fetch
actions
cacheAllVersions
	| goSource versionNames |
	goSource := Gofer new repository: repository.
	versionNames := repository allVersionNames.
	(goSource allResolved
		select: [ :resolved | versionNames anySatisfy: [ :each | resolved name = each ] ])
		do: [ :each | goSource package: each packageName ].
	goSource fetch
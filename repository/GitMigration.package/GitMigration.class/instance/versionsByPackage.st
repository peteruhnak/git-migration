accessing
versionsByPackage
	| versionsByPackage |
	versionsByPackage := Dictionary new.
	self versionsInfo
		do: [ :version | 
			(versionsByPackage
				at: (version name copyUpToLast: $-)
				ifAbsentPut: [ OrderedCollection new ]) add: version ].
	^ versionsByPackage
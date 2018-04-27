accessing
versionsByPackage
	| versionsByPackage |
	versionsByPackage := Dictionary new.
	repository versionsWithPackageNames
		do: [ :quad | 
			(versionsByPackage at: quad first ifAbsentPut: [ OrderedCollection new ])
				add: (self cachedVersionNamed: (quad last withoutSuffix: '.mcz')) ].
	^ versionsByPackage
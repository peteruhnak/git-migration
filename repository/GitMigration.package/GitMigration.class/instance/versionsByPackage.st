accessing
versionsByPackage
"	versionsByPackage ifNotNil: [ ^ versionsByPackage ]."
	versionsByPackage := Dictionary new.
	repository versionsWithPackageNames
		do: [ :quad | 
			(versionsByPackage at: quad first ifAbsentPut: [ OrderedCollection new ])
				add: (self cachedVersions at: (quad last withoutSuffix: '.mcz')) ].
	^ versionsByPackage
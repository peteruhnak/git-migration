accessing
cachedVersionNamed: aName
	^ self cachedVersions
		at: aName
		ifAbsent: [ (self cachedVersions associations
				detect: [ :pair | pair key asLowercase = aName asLowercase ]) value ]
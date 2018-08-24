accessing
versions
	versionsCache
		ifNil: [ | versions |
			versions := OrderedCollection new.
			self versionsWithPackageNames
				do: [ :quad | versions add: (self versionFromFileNamed: quad last) ]
				displayingProgress: [ :quad | 'Loading versions metadata... ' , quad last ].
			versionsCache := versions ].
	^ versionsCache
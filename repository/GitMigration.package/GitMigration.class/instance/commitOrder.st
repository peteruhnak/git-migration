actions
commitOrder
	"All packages to be commited in the order from first to last, across multiple packages"

	| packagePool ordering |
	packagePool := IdentitySet new.
	ordering := OrderedCollection new.
	self versionsByPackage
		keysAndValuesDo: [ :pkgName :realVersions | 
			| allVersions |
			allVersions := self topologicallySort: (self completeAncestryOfPackageNamed: pkgName).
			"add only versions that really exist"
			self assert: [ (allVersions select: [ :each | realVersions includes: each ]) isNotEmpty ].
			
			packagePool add: (allVersions select: [ :each | realVersions includes: each ]) ].

	"pick the oldest available commit across all packages"
	[ packagePool isNotEmpty ]
		whileTrue: [ | oldestPackage version |
			oldestPackage := packagePool detectMin: [ :pkgVersions | pkgVersions first timeStamp ].
			version := oldestPackage first.
			oldestPackage removeFirst.
			ordering add: version.
			oldestPackage ifEmpty: [ packagePool remove: oldestPackage ] ].
	^ ordering
accessing
packagesWithMultipleRoots
	| multiRoots |
	multiRoots := Dictionary new.
	self versionsByPackage
		keysAndValuesDo: [ :pkgName :versions | 
			| roots |
			roots := (self completeAncestryOfPackageNamed: pkgName)
				select: [ :each | each ancestors isEmpty ].
			roots size > 1
				ifTrue: [ multiRoots at: pkgName put: roots ] ].
	^ multiRoots
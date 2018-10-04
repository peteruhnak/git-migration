tests - accessing
testVersionsByPackageWithFilter
	migration selectedPackageNames: #(CoSomewhere).
	self assert: migration versionsByPackage keys sorted equals: #(CoSomewhere)
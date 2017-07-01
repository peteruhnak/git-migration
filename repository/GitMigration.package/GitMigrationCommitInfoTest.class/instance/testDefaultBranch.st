tests - commit transform
testDefaultBranch
	self assert: (self commitInfoFor: self versionWithoutParent) branch equals: 'master'
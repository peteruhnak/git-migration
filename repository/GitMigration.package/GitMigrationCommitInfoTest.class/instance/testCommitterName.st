tests - commit transform
testCommitterName
	self assert: (self commitInfoFor: self versionWithoutParent) committerName equals: 'Committer Bot'
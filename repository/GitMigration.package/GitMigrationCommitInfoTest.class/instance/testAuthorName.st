tests - commit transform
testAuthorName
	self
		assert: (self commitInfoFor: self versionWithoutParent) authorName
		equals: 'Import Bot'
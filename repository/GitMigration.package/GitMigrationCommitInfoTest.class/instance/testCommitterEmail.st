tests - commit transform
testCommitterEmail
	self
		assert: (self commitInfoFor: self versionWithoutParent) committerEmail
		equals: 'committerbot@example.com'
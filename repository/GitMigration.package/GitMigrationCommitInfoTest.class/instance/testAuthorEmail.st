tests - commit transform
testAuthorEmail
	self
		assert: (self commitInfoFor: self versionWithoutParent) authorEmail
		equals: 'importbot@example.com'
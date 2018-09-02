tests - commit transform
testCommitMessage
	self
		assert: (self commitInfoFor: self versionWithoutParent) commitMessage
		equals: 'Initial MC commit'
tests - accessing
testCommitterEmail
	self
		assert: (writer committerEmailFor: self versionWithoutParent)
		equals: 'committerbot@example.com'
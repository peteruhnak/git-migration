tests - accessing
testAuthorEmail
	self
		assert: (writer authorEmailFor: self versionWithoutParent)
		equals: 'importbot@example.com'
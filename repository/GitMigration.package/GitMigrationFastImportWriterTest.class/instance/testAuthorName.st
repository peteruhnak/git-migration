tests - accessing
testAuthorName
	self assert: (writer authorNameFor: self versionWithoutParent) equals: 'Import Bot'
tests - writing
testWriteAncestorsWithoutAncestors
	writer initialCommit: '1234567890'.
	writer writeAncestorsFor: self versionWithoutParent.
	self
		assert: stream contents
		equals:
			'from 1234567890
'
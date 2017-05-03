tests - accessing
testNoAncestors
	| v1 v2 contents |
	v1 := self versionWithoutParent.
	v2 := self versionWithoutParent.
	writer initialCommit: '1234567890'.
	writer writeAncestorsFor: v1.
	contents := stream contents.
	self
		assert: contents
		equals:
			'from 1234567890
'.
	stream reset.
	self assert: stream contents equals: ''.
	writer writeAncestorsFor: v2.
	self
		assert: stream contents
		equals:
			'from :1
'
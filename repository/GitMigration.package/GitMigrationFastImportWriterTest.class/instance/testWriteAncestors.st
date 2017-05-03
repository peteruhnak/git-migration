tests
testWriteAncestors
	| version |
	version := self versionWithTwoAncestors.
	version ancestors do: [ :each | writer commitMarkFor: each ].
	writer availableVersions: version ancestors.
	writer writeAncestorsFor: version.
	self
		assert: stream contents
		equals:
			'merge :1
merge :2
'
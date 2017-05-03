tests - accessing
testCommitMark
	| version1 version2 mark1 mark2 |
	version1 := self versionWithoutParent.
	version2 := self versionWithoutParent.
	self deny: version1 = version2.
	mark1 := writer commitMarkFor: version1.
	mark2 := writer commitMarkFor: version2.
	self deny: mark1 = mark2.
	self assert: mark1 equals: (writer commitMarkFor: version1)
tests - accessing
testCommitterName
	self assert: (writer committerNameFor: self versionWithoutParent) equals: 'Committer Bot'
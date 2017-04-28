tests - topology sorting
testIsRoot
	self assert: (migration isRoot: 1 in: {1 -> 2}).
	self deny: (migration isRoot: 1 in: {2 -> 1})
tests - actions
testCompleteAncestry2
	| ancestry |
	ancestry := migration completeAncestryOfPackageNamed: 'Somewhere'.
	self
		assert: (ancestry collect: [ :each | (each name splitOn: '.') last asNumber ]) asArray sorted
		equals: #(1 2 4 3 8 15 5 6 7 9 10) sorted
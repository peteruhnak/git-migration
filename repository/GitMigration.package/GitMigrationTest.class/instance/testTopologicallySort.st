tests - actions
testTopologicallySort
	| ancestry sorted |
	ancestry := migration completeAncestryOfPackageNamed: 'Somewhere'.
	sorted := migration topologicallySort: ancestry.
	self
		assert: (sorted collect: [ :each | (each name splitOn: '.') last asNumber ]) asArray
		equals: #(1 2 4 3 8 15 5 6 7 9 10)
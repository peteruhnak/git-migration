tests - accessing
testCommitOrder
	| commitOrder |
	commitOrder := migration commitOrder.
	self
		assert: (commitOrder collect: [ :each | (each name splitOn: '.') last asNumber ]) asArray
		equals: #(1 2 4 3 1 8 4 15 5 6 9)
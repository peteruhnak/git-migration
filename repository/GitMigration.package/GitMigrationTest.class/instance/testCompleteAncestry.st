tests - accessing
testCompleteAncestry
	| result |
	result := migration completeAncestryOfPackageNamed: 'CoSomewhere'.
	self
		assert: (result collect: #name) asArray sorted
		equals: #('CoSomewhere-PeterUhnak.1' 'CoSomewhere-PeterUhnak.4' 'CoSomewhere-PeterUhnak.5' 'CoSomewhere-PeterUhnak.6')
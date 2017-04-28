topology sorting
isRoot: aKey in: pairs
	^ pairs noneSatisfy: [ :pair | pair value = aKey ]
topology sorting
topologicallySort: anAncestry
	| ancestry |
	anAncestry size = 1
		ifTrue: [ ^ anAncestry asOrderedCollection ].
	ancestry := anAncestry asArray
		flatCollect: [ :each | 
			each ancestors collect: [ :anc | anc -> each ] ].
	^ self topologicallySortPairs: ancestry
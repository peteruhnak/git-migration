topology sorting
topologicallySortPairs: anArray
	| in out pairs |
	in := Set new.
	out := OrderedCollection new.
	pairs := anArray asOrderedCollection.
	in addAll: (pairs select: [ :pair | self isRoot: pair key in: pairs ] thenCollect: #key).
	[ in isNotEmpty ]
		whileTrue: [ | current next |
			current := in detectMin: #timeStamp.
			in remove: current.
			out add: current.
			next := pairs select: [ :pair | pair key = current ].
			pairs removeAll: next.
			in addAll: (next collect: #value thenSelect: [ :each | self isRoot: each in: pairs ]) ].
	^ out
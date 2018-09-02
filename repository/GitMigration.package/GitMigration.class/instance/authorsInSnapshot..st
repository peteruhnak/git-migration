accessing
authorsInSnapshot: aSnapshot
	| timeStamps |
	timeStamps := OrderedCollection new.
	aSnapshot definitions
		do: [ :each | 
			each isMethodDefinition
				ifTrue: [ timeStamps add: each timeStamp ].
			(each isClassDefinition and: [ (each isKindOf: MCClassTraitDefinition) not ])
				ifTrue: [ timeStamps add: each commentStamp ] ].
	^ (timeStamps collect: [ :each | each copyUpTo: Character space ]) \ #('' '<historical>')
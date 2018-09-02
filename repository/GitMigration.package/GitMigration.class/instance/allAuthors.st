accessing
allAuthors
	allAuthors
		ifNil: [ | authorsSet |
			authorsSet := Set new.
			self versions
				do: [ :each | authorsSet addAll: (self authorsInSnapshot: each veryDeepCopy snapshot) ]
				displayingProgress: [ :each | 'Loading authors... ' , each info name ].
			allAuthors := authorsSet asArray sorted ].
	^ allAuthors
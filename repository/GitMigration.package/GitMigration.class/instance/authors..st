accessing
authors: aCollection
	| allAuthors |
	allAuthors := self allAuthors asOrderedCollection.
	aCollection asDictionary associations
		do: [ :pair | 
			(pair key isEmpty or: [ (pair value size = 2) not ])
				ifTrue: [ self error: 'Invalid format' ].
			(allAuthors includes: pair key)
				ifTrue: [ allAuthors remove: pair key ] ].
	allAuthors
		ifNotEmpty: [ NotFound new
				messageText:
					'Not all authors have their email set, this is mandatory: '
						, (allAuthors joinUsing: ', ');
				object: self;
				signal ].
	authors := aCollection asDictionary
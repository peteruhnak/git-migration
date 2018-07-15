accessing
collectPackageUsers: packageName
	" Collect and answer a <Collection> with the package users suitabe for use in #authors: parameter.
	e-mails should be entered manually. "
	
	authors := ((RPackageOrganizer default packageNames 
		select: [ : p | p beginsWith: packageName ]
		thenCollect: [ : n | n asPackage methods collect: #author ])
			gather: #yourself) asSet.
	^ (authors 
		reject: #isEmpty
		thenCollect: [ : n | 
			n -> (Array 
				with: ((n piecesCutWhere: [ : a : b | b isUppercase ]) joinUsing: ' ')
				with: '@.') ]) asSortedCollection.

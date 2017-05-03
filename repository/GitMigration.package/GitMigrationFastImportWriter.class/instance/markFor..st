accessing
markFor: anObject
	^ marks at: anObject ifAbsentPut: [ marks size + 1 ]
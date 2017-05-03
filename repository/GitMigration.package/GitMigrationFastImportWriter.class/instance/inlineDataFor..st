accessing
inlineDataFor: aString
	^ 'data ' , aString size asString , String cr
		, (aString ifEmpty: [ '' ] ifNotEmpty: [ aString , String cr ])
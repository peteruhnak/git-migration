printing
inlineDataFor: aString

	| theString |
	theString := aString.
	"Ensure the message has valid UTF-8 encoding (this will raise an error if it doesn't)"
	[ aString asByteArray utf8Decoded ]
		on: ZnCharacterEncodingError
		do: [ :ex | self halt: 'Illegal string encoding (see method comments)'.
			"git fast-import is strict about character encoding and only accepts UTF-8.
			See https://git-scm.com/docs/git-fast-import.
			The following simplistic approach ensures the string only contains simple ascii text
			(letters, numbers and separators (spaces, line end, etc))"
			theString := aString select: [ :each | (each asciiValue between: 32 and: 127) or: [ 
					each isSeparator ] ] ].
	^ 'data ' , theString size asString , String cr , 
		(theString ifEmpty: [ '' ] ifNotEmpty: [ theString , String cr ])
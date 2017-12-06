converting
pathFromString: aString
	| theString normalized |
	"IceMetadatalessStCypressWriter sometimes passes down a symbol instead of a string.
	Convert symbols to strings so the normalisation can be done."
	theString := aString isSymbol
		ifTrue: [ aString asString ]
		ifFalse: [ aString ].
	"Normalize both / to \ to the current one (so it works both on Unix and Windows)"
	normalized := theString copy
		replaceAll: WindowsStore delimiter with: self delimiter;
		replaceAll: UnixStore delimiter with: self delimiter.
	^ super pathFromString: normalized
writing
writeDeletePackageFor: aVersion
	| path |
	path := FileSystem unicodeMemory root / exportDirectory / aVersion package name , 'package'.
	fastWriter writeDeleteReference: path
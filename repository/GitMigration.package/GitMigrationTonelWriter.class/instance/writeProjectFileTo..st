writing
writeProjectFileTo: aDirectory
	(aDirectory parent / '.project')
		ensureDelete;
		writeStreamDo: [ :stream | 
			(STONWriter on: stream)
				prettyPrint: true;
				newLine: OSPlatform current lineEnding;
				nextPut: {'srcDirectory' -> aDirectory basename} asDictionary ]
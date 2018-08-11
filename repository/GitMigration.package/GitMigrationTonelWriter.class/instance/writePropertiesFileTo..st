writing - memory
writePropertiesFileTo: aDirectory
	(aDirectory / IceRepositoryProperties propertiesFileName)
		ensureDelete;
		writeStreamDo: [ :stream | 
			(STONWriter on: stream)
				prettyPrint: true;
				newLine: OSPlatform current lineEnding;
				nextPut: {#format -> #tonel} asDictionary ]
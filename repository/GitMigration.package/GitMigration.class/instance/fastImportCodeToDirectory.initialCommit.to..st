import
fastImportCodeToDirectory: aDirectoryName initialCommit: anInitialCommitish to: aFileReference
	| writer |
	aFileReference asFileReference
		ensureDelete;
		writeStreamDo: [ :rawStream | 
			| stream |
			"stream := (ZnNewLineWriterStream on: rawStream) forLf."
			writer := GitMigrationTonelWriter new on: rawStream.
			writer exportDirectory: aDirectoryName.
			self createFastImportAt: anInitialCommitish usingWriter: writer ].
	^ writer commitMarks
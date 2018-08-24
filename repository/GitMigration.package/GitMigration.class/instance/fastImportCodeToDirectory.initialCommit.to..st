import
fastImportCodeToDirectory: aDirectoryName initialCommit: anInitialCommitish to: aFileReference
	| writer |
	aFileReference asFileReference
		ensureDelete;
		writeStreamDo: [ :rawStream | 
			writer := GitMigrationTonelWriter new on: rawStream.
			writer exportDirectory: aDirectoryName.
			self createFastImportAt: anInitialCommitish usingWriter: writer ].
	^ writer commitMarks
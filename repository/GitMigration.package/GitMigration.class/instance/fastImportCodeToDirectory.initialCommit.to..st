import
fastImportCodeToDirectory: aDirectoryName initialCommit: anInitialCommitish to: aFileReference
	| writer |
	aFileReference asFileReference
		ensureDelete;
		writeStreamDo: [ :stream | 
			stream lineEndConvention: #lf.
			writer := GitMigrationFastImportWriter new on: stream.
			writer exportDirectory: aDirectoryName.
			self createFastImportAt: anInitialCommitish usingWriter: writer ].
	^ writer commitMarks
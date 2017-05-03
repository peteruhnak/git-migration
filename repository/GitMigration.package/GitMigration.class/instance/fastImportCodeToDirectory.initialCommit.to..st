fast import
fastImportCodeToDirectory: aDirectoryName initialCommit: anInitialCommitish to: aFileReference
	| stream writer |
	stream := WriteStream on: ''.
	writer := GitMigrationFastImportWriter new on: stream.
	writer exportDirectory: aDirectoryName.
	self createFastImportAt: anInitialCommitish usingWriter: writer.
	aFileReference asFileReference
		ensureDelete;
		writeStreamDo: [ :s | s << (stream contents copyReplaceAll: String cr with: String lf) ].
	^ writer commitMarks
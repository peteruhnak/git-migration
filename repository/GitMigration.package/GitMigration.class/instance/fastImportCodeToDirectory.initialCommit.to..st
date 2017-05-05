fast import
fastImportCodeToDirectory: aDirectoryName initialCommit: anInitialCommitish to: aFileReference
	| stream writer |
	stream := WriteStream on: ''.
	writer := GitMigrationFastImportWriter new on: stream.
	writer exportDirectory: aDirectoryName.
	self createFastImportAt: anInitialCommitish usingWriter: writer.
	'Writing everything to file (this might take a while)...'
		displayProgressFrom: 0
		to: 1
		during: [ :bar | 
			bar value: 0.
			aFileReference asFileReference
				ensureDelete;
				writeStreamDo: [ :s | s << (stream contents copyReplaceAll: String cr with: String lf) ] ].
	^ writer commitMarks
tests - writing
testWriteFileModifyInline
	| fs file |
	fs := FileSystem store: GitMigrationMemoryStore new.
	file := fs / 'folder' / 'subfolder' / 'file.txt'.
	file parent ensureCreateDirectory.
	file
		writeStreamDo: [ :aStream | 
			aStream
				<<
					'some
content' ].
	writer writeFileModifyInlineFor: file.
	self
		assert: stream contents
		equals:
			'M 100644 inline folder/subfolder/file.txt
data 12
some
content
'
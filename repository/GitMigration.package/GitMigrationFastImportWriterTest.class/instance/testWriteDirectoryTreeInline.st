tests
testWriteDirectoryTreeInline
	| fs file1 file2 file3|
	fs := FileSystem store: GitFastImportMemoryStore new.
	file1 := fs / 'folder' / 'top.txt'.
	file2 := fs / 'folder' / 'empty.txt'.
	file3 := fs / 'folder' / 'subfolder' / 'bottom.txt'.
	file3 parent ensureCreateDirectory.
	file1 writeStreamDo: [ :s | s << 'top content' ].
	file2 writeStreamDo: [ :s | s << '' ].
	file3 writeStreamDo: [ :s | s << 'bottom content' ].
	writer writeDirectoryTreeInlineFor: fs / 'folder'.
	self
		assert: stream contents
		equals:
			'M 100644 inline folder/empty.txt
data 0

M 100644 inline folder/top.txt
data 11
top content
M 100644 inline folder/subfolder/bottom.txt
data 14
bottom content
'
tests - writing
testWriteDeleteAll
	writer writeDeleteAll.
	self
		assert: stream contents
		equals:
			'filedeleteall
'
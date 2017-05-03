tests - accessing
testInlineDataEmpty
	self
		assert: (writer inlineDataFor: '')
		equals:
			'data 0
'
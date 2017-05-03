tests - accessing
testInlineData
	self
		assert: (writer inlineDataFor: 'hello')
		equals:
			'data 5
hello
'
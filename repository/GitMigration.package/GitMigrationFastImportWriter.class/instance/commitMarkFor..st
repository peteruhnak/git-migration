accessing
commitMarkFor: aVersionInfo
	^ commitMarks at: aVersionInfo ifAbsentPut: [ commitMarks size + 1 ]
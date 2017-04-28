tests - retrieving
testOn
	self assert: migration repository isNotNil.
	self assert: migration repository owner equals: 'peteruhnak'.
	self assert: migration repository project equals: 'breaking-mcz'
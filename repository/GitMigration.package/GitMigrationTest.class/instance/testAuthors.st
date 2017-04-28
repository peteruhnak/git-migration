tests - accessing
testAuthors
	self should: [ migration authors: {} ] raise: NotFound
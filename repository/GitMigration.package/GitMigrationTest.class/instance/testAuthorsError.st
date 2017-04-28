tests - accessing
testAuthorsError
	self
		should: [ migration authors: {'PeterUhnak' -> #('<wherever@wherever.com>')} ]
		raise: Error
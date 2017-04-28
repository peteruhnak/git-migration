tests - accessing
testAuthorsOk
	self
		shouldnt: [ migration authors: {'PeterUhnak' -> #('Peter Uhnak' '<wherever@wherever.com>')} ]
		raise: NotFound
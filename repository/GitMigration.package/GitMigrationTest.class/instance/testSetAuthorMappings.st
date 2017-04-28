tests - actions
testSetAuthorMappings
	| oldNamesMap |
	oldNamesMap := MCFileTreeGitRepository namesMap.
	[ migration authors: {'PeterUhnak' -> #('Peter Uhnak' '<wherever@wherever.com>')}.
	MCFileTreeGitRepository namesMap: Dictionary new.
	self assert: (MCFileTreeGitRepository namesAt: 'PeterUhnak') equals: nil.
	migration setAuthorMappings.
	self
		assert: (MCFileTreeGitRepository namesAt: 'PeterUhnak')
		equals:
			{#name -> 'Peter Uhnak'.
			#email -> '<wherever@wherever.com>'} asDictionary ]
		ensure: [ MCFileTreeGitRepository namesMap: oldNamesMap ]
actions
setAuthorMappings
	MCFileTreeGitRepository namesMap: Dictionary new.
	authors
		keysAndValuesDo:
			[ :key :duet | MCFileTreeGitRepository namesAt: key put: duet first email: duet second ]
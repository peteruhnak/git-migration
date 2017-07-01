accessing
commitMessage
	^ info message	" , ' (' , info versionNumber asString , ') ['
		, ((info ancestors collect: #versionNumber) joinUsing: ', ') , ']'"
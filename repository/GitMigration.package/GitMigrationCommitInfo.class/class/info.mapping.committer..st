instance creation
info: aVersionInfo mapping: aMapping committer: aCommitter
	^ self new
		info: aVersionInfo;
		author: (aMapping at: aVersionInfo author);
		committer: aCommitter
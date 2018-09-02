instance creation
info: aVersionInfo mapping: aMapping committer: aCommitter coauthors: aCoauthorsList
	^ self new
		info: aVersionInfo;
		author: (aMapping at: aVersionInfo author);
		coauthors:
			(aCoauthorsList \ {aVersionInfo author}
				collect: [ :each | aMapping at: each ]);
		committer: aCommitter
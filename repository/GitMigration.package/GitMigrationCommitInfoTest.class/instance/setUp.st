running
setUp
	super setUp.
	self ensureTestRepoLoaded.
"	self ensureGitFileTreeLoaded."
	self ensureAllCached.
	authorMapping := GitMigrationAuthorMapping new
		shortName: 'ImportBot' name: 'Import Bot' email: 'importbot@example.com';
		shortName: 'CommitterBot' name: 'Committer Bot' email: 'committerbot@example.com'.
	committer := authorMapping at: 'CommitterBot'
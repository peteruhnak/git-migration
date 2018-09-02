running
setUp
	super setUp.
	self timeLimit: 1 minute.
	self ensureTestRepoLoaded.
	"	self ensureGitFileTreeLoaded."
	self ensureAllCached.
	writer := GitMigrationFastImportWriter new.
	authorMapping := GitMigrationAuthorMapping new
		shortName: 'ImportBot' name: 'Import Bot' email: 'importbot@example.com';
		shortName: 'CommitterBot' name: 'Committer Bot' email: 'committerbot@example.com';
		shortName: 'JoDoe' name: 'Jo Doe' email: '';
		shortName: 'SamDoe' name: 'Sam Doe' email: 'samdoe@example.com'.
	committer := authorMapping at: 'CommitterBot'.
	writer committerName: 'CommitterBot'.
	writer authorMapping: authorMapping
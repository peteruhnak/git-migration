running
setUp
	super setUp.
	self timeLimit: 1 minute.
	self ensureTestRepoLoaded.
	"	self ensureGitFileTreeLoaded."
	self ensureAllCached.
	stream := String new writeStream.
	authorMapping := GitMigrationAuthorMapping new
		shortName: 'ImportBot' name: 'Import Bot' email: 'importbot@example.com';
		shortName: 'CommitterBot' name: 'Committer Bot' email: 'committerbot@example.com'.
	committer := authorMapping at: 'CommitterBot'.
	writer := self writerClass new on: stream.
	writer committerName: committer shortName.
	writer authorMapping: authorMapping
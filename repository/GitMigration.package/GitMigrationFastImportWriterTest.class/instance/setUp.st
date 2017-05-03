running
setUp
	super setUp.
	self ensureTestRepoLoaded.
	self ensureAllCached.
	stream := String new writeStream.
	writer := GitMigrationFastImportWriter new on: stream.
	writer committerName: 'CommitterBot'.
	writer
		authorMapping:
			(GitMigrationAuthorMapping new
				shortName: 'ImportBot' name: 'Import Bot' email: 'importbot@example.com';
				shortName: 'CommitterBot' name: 'Committer Bot' email: 'committerbot@example.com')
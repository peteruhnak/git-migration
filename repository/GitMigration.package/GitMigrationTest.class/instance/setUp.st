running
setUp
	super setUp.
	self ensureTestRepoLoaded.
"	self ensureGitFileTreeLoaded."
	migration := GitMigration on: 'peteruhnak/breaking-mcz'.
	self ensureAllCached.
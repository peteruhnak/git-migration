running
setUp
	super setUp.
	self ensureTestRepoLoaded.
	migration := GitMigration on: 'peteruhnak/breaking-mcz'.
	self ensureAllCached.
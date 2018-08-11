running
setUp
	super setUp.
	self timeLimit: 1 minute.
	self ensureTestRepoLoaded.
	"	self ensureGitFileTreeLoaded."
	migration := GitMigration on: 'peteruhnak/breaking-mcz'.
	self ensureAllCached
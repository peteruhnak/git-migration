tests - commit transform
testCommitMessageNull
	"https://github.com/peteruhnak/git-migration/issues/15"

	self
		assert: (self commitInfoFor: self versionWithNull) commitMessage
		equals: 'Null here >< and there ><' withUnixLineEndings
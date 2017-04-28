running
ensureTestRepoLoaded
	| repo |
	repo := MCSmalltalkhubRepository new.
	repo owner: 'peteruhnak'.
	repo project: 'breaking-mcz'.
	MCRepositoryGroup default addRepository: repo
initialization
initialize
	super initialize.
	marks := Dictionary new.
	authorMapping := GitMigrationAuthorMapping new.
	commitMarks := OrderedDictionary new.
	committerName := Author fullName.
	availableVersions := Dictionary new.
	exportDirectory := '/'
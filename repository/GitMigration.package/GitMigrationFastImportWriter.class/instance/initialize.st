initialization
initialize
	super initialize.
	authorMapping := GitMigrationAuthorMapping new.
	committerName := Author fullName.
	availableVersions := Dictionary new.
	exportDirectory := '/'.
	fastWriter := GitFastImportFileWriter new
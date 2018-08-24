accessing
allAuthors
	^ (self versionsWithPackageNames collect: #second) asSet asArray sorted
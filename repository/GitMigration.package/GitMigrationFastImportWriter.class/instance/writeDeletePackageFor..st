writing
writeDeletePackageFor: aVersion
	| path |
	path := exportDirectory , GitMigrationMemoryStore delimiter asString
		, aVersion package name , '.package'.
	writeStream
		<< 'D ';
		<< (path trimLeft: [ :c | c = GitMigrationMemoryStore delimiter ]);
		cr
writing
writeDeletePackageFor: aVersion
	| path |
	path := exportDirectory , GitFastImportMemoryStore delimiter asString
		, aVersion package name , '.package'.
	writeStream
		<< 'D ';
		<< (path trimLeft: [ :c | c = GitFastImportMemoryStore delimiter ]);
		cr
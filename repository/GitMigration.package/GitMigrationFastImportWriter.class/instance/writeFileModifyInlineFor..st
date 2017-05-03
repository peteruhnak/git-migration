writing
writeFileModifyInlineFor: aFileReference
	| contents reader rawContents |
	rawContents := aFileReference contents.
	reader := MultiByteBinaryOrTextStream with: rawContents encoding: #UTF8.
	contents := reader reset contents.
	writeStream
		<< 'M 100644 inline ';
		<< (aFileReference fullName trimLeft: [ :c | c = GitMigrationMemoryStore delimiter ]);
		cr;
		<< 'data ';
		<< contents size;
		cr;
		<< contents;
		cr
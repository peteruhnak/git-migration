writing
writeFileModifyInlineFor: aFileReference
	| contents |
	contents := aFileReference contents.
	writeStream
		<< 'M 100644 inline ';
		<< (aFileReference fullName withoutPrefix: GitMigrationMemoryStore delimiter asString);
		cr;
		<< 'data ';
		<< contents size;
		cr;
		<< contents;
		cr
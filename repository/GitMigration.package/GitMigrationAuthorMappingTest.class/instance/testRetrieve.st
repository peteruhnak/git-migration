tests
testRetrieve
	| mapping author |
	mapping := GitMigrationAuthorMapping new.
	mapping shortName: 'ImportBot' name: 'Import Bot' email: 'importbot@example.com'.
	author := mapping at: 'ImportBot'.
	self assert: author shortName equals: 'ImportBot'.
	self assert: author name equals: 'Import Bot'.
	self assert: author email equals: 'importbot@example.com'
printing
printOn: aStream
	aStream
		<< self info versionNumber;
		<< ' ['.
	self parents
		do: [ :each | aStream << each info versionNumber ]
		separatedBy: [ aStream << ', ' ].
	aStream << ']'.
	aStream
		<< ' @';
		<< self branch name
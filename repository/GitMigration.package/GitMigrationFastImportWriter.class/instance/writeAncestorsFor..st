writing
writeAncestorsFor: aVersionInfo
	aVersionInfo ancestors
		ifEmpty: [ writeStream << 'from '.
			(commitMarks isEmpty
				or: [ commitMarks size = 1 and: [ commitMarks keys first = aVersionInfo ] ])
				ifTrue: [ writeStream << initialCommit ]
				ifFalse: [ writeStream
						<< ':';
						<< (commitMarks values atLast: (commitMarks size min: 2)) ].
			writeStream cr.
			self commitMarkFor: aVersionInfo.
			^ self ].
	(self ancestorsFor: aVersionInfo)
		do: [ :each | 
			writeStream
				<< 'merge :';
				<< (self commitMarkFor: each) asString;
				cr ]
writing
writeCommitPreambleFor: aVersionInfo
	writeStream
		nextPutAll:
			('commit refs/heads/master
mark :{commitMark}
author {authorName} <{authorEmail}> {authoredDate}
committer {committerName} <{committerEmail}> {committedDate}
{commitMessageData}'
				format:
					{#commitMark -> (self commitMarkFor: aVersionInfo).
					#authorName -> (self authorNameFor: aVersionInfo).
					#authorEmail -> (self authorEmailFor: aVersionInfo).
					#authoredDate -> (self authoredDateFor: aVersionInfo).
					#committerName -> (self committerNameFor: aVersionInfo).
					#committerEmail -> (self committerEmailFor: aVersionInfo).
					#committedDate -> (self committedDateFor: aVersionInfo).
					#commitMessageData -> (self inlineDataFor: aVersionInfo message)} asDictionary)
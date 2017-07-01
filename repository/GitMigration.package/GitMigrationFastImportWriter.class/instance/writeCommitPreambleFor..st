writing
writeCommitPreambleFor: aCommitInfo
	writeStream
		nextPutAll:
			('commit refs/heads/master
mark :{commitMark}
author {authorName} <{authorEmail}> {authoredDate}
committer {committerName} <{committerEmail}> {committedDate}
{commitMessageData}'
				format:
					{#commitMark -> (self commitMarkFor: aCommitInfo info).
					#authorName -> aCommitInfo authorName.
					#authorEmail -> aCommitInfo authorEmail.
					#authoredDate -> aCommitInfo authoredDate.
					#committerName -> aCommitInfo committerName.
					#committerEmail -> aCommitInfo committerEmail.
					#committedDate -> aCommitInfo committedDate.
					#commitMessageData -> aCommitInfo commitMessageData} asDictionary)
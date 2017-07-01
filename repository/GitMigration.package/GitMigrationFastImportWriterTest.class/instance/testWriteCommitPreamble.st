tests - writing
testWriteCommitPreamble
	| contents dtNow |
	writer writeCommitPreambleFor: (writer commitInfoFor: self versionWithoutParent).
	contents := stream contents.
	"hack to extract the DateAndTime now inside, which is not straightforward to test"
	dtNow := (contents lines fourth splitOn: '> ') last.
	self
		assert: contents
		equals:
			('commit refs/heads/master
mark :1
author Import Bot <importbot@example.com> 977329230 +0000
committer Committer Bot <committerbot@example.com> {1}
data 17
Initial MC commit
' format: {dtNow})
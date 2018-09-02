tests - commit transform
testCommitMessageWithCoauthors
	self
		assert: (self commitInfoFor: self versionWithCoauthors) commitMessage
		equals:
			'Version with coauthors

Co-authored-by: Jo Doe <>
Co-authored-by: Sam Doe <samdoe@example.com>' withUnixLineEndings
tests - commit transform
testAuthoredDate
	self
		assert: (self commitInfoFor: self versionWithoutParent) authoredDate
		equals: '977329230 +0000'	"'2000-12-20T16:20:30+00:00'"
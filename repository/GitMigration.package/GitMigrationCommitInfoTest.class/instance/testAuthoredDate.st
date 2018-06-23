tests - commit transform
testAuthoredDate
	self
		assert: (self commitInfoFor: self versionWithoutParent) authoredDate
		equals: (DateAndTime fromUnixTime: 977329230)	"'2000-12-20T16:20:30+00:00'"
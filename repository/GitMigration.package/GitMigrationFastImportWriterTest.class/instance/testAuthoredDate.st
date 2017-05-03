tests - accessing
testAuthoredDate
	self assert: (writer authoredDateFor: self versionWithoutParent) equals: '977329230 +0000'	"'2000-12-20T16:20:30+00:00'"
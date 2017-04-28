tests - retrieving
testFindRepository
	| repo |
	"fuel should be in the image by default afaik"
	repo := migration findRepositoryNamed: 'peteruhnak/breaking-mcz'.
	self assert: repo isNotNil.
	self assert: repo owner equals: 'peteruhnak'.
	self assert: repo project equals: 'breaking-mcz'
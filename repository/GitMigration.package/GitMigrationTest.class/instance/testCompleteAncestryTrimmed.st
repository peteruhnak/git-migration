tests - accessing
testCompleteAncestryTrimmed
	"https://github.com/peteruhnak/git-migration/issues/13"

	| result brokenVersion brokenAncestor |
	migration populateCaches.
	brokenVersion := migration versions
		detect: [ :each | each info name = 'CoSomewhere-PeterUhnak.5' ].
	brokenAncestor := MCVersionInfo
		name: ''
		id: UUID new
		message: 'I am broken'
		date: ''
		time: ''
		author: ''
		ancestors: #().
	brokenVersion info setAncestors: brokenVersion info ancestors , {brokenAncestor}.
	result := migration completeAncestryOfPackageNamed: 'CoSomewhere'.
	self
		assert: (result collect: #name) asArray sorted
		equals:
			#('CoSomewhere-PeterUhnak.1' 'CoSomewhere-PeterUhnak.4' 'CoSomewhere-PeterUhnak.5' 'CoSomewhere-PeterUhnak.6')
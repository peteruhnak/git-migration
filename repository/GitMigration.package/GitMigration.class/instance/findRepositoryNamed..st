retrieving
findRepositoryNamed: aRepoName
	"aRepoName = ownerName/projectName, e.g. ObjectProfile/Roassal2"
	^ MCRepositoryGroup default repositories
		detect: [ :each | (each description includesSubstring: aRepoName) or: (each description includesSubstring: (aRepoName copyReplaceAll: '/' with: '\')) ]
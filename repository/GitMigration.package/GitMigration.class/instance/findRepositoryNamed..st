retrieving
findRepositoryNamed: aRepoName
	"aRepoName = ownerName/projectName, e.g. ObjectProfile/Roassal2"
	^ MCRepositoryGroup default repositories
		detect: [ :each | (each location includesSubstring: aRepoName) or: (each location includesSubstring: (aRepoName copyReplaceAll: '/' with: '\')) ]
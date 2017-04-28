actions
pushAllVersions: anOrdering to: aRepository
	| gitDestination destinationFiles |
	gitDestination := Gofer new repository: aRepository.
	destinationFiles := aRepository allVersionNames.
	"selects only the mcz that are not yet at destination"
	(anOrdering collect: #name)
		reject: [ :file | destinationFiles includes: file ]
		thenDo: [ :file | gitDestination version: file ].
	"sends everything to new repository"
	gitDestination push
running
ensureGitFileTreeLoaded
	(Smalltalk hasClassNamed: #MCFileTreeGitRepository)
		ifFalse: [ (CatalogProvider projectNamed: 'GitFileTree') installVersion: #stable ]
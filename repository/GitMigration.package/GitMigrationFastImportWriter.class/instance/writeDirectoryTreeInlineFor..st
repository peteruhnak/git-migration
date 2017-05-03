writing
writeDirectoryTreeInlineFor: aDirectory
	aDirectory files do: [ :each | self writeFileModifyInlineFor: each ].
	aDirectory directories do: [ :each | self writeDirectoryTreeInlineFor: each ]
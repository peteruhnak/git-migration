baselines
baseline: spec
	<baseline>
	spec
		for: #common
		do: [ spec
				baseline: 'GitFastWriter'
				with: [ spec repository: 'github://peteruhnak/git-fast-writer/repository' ].
			spec package: 'GitMigration' with: [ spec requires: 'GitFastWriter' ].
			spec group: 'default' with: #('GitMigration') ]
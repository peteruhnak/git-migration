baselines
baseline: spec
	<baseline>
	spec
		for: #common
		do: [ spec package: 'GitMigration' with: [  ].
			spec group: 'default' with: #('GitMigration') ]
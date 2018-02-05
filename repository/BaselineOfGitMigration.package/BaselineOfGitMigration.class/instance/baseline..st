baselines
baseline: spec
	<baseline>
	spec
		for: #common
		do: [ spec package: 'GitMigration'.
			spec group: 'default' with: #('GitMigration') ]
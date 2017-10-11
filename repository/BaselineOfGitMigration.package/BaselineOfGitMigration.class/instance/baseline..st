baselines
baseline: spec
	<baseline>
	spec
		for: #'pharo6.x'
		do: [ spec package: 'GitMigration'.
			spec group: 'default' with: #('GitMigration') ]
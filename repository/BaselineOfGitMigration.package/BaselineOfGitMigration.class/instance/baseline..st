baselines
baseline: spec
	<baseline>
	spec
		for: #common
		do: [ spec blessing: #baseline.
			spec package: 'GitMigration'.
			spec group: 'default' with: #('GitMigration') ]
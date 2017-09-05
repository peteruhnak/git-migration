baselines
baseline: spec
	<baseline>
	spec
		for: #'pharo5.x'
		do: [ spec
				configuration: 'GitFileTree'
				with: [ spec
						versionString: #stable;
						repository: 'http://smalltalkhub.com/mc/Pharo/MetaRepoForPharo50/main' ].
			spec package: 'GitMigration' with: [ spec requires: #('GitFileTree') ].
			spec group: 'default' with: #('GitMigration') ].
	spec
		for: #'pharo6.x'
		do: [ spec
				configuration: 'GitFileTree'
				with: [ spec
						versionString: #stable;
						repository: 'http://smalltalkhub.com/mc/Pharo/MetaRepoForPharo60/main' ].
			spec package: 'GitMigration' with: [ spec requires: #('GitFileTree') ].
			spec group: 'default' with: #('GitMigration') ]
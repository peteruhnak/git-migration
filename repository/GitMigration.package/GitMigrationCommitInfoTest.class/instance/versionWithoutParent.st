instance creation
versionWithoutParent
	^ MCVersion
		package: (MCPackage named: 'XYZ')
		info:
			(MCVersionInfo
				name: 'FastImported-ImportBot.1'
				id: UUID new
				message: 'Initial MC commit'
				date: (Date year: 2000 month: 12 day: 20)
				time: (Time hour: 16 minute: 20 second: 30)
				author: 'ImportBot'
				ancestors: #())
		snapshot: MCSnapshot empty
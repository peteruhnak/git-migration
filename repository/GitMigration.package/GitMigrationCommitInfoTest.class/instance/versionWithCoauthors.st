instance creation
versionWithCoauthors
	^ MCVersion
		package: (MCPackage named: 'XYZ')
		info:
			(MCVersionInfo
				name: 'FastImported-ImportBot.5'
				id: UUID new
				message: 'Version with coauthors'
				date: (Date year: 2000 month: 12 day: 20)
				time: (Time hour: 16 minute: 20 second: 30)
				author: 'ImportBot'
				ancestors: #())
		snapshot:
			(MCSnapshot
				fromDefinitions:
					{MCMethodDefinition
						className: 'Something'
						selector: #selector
						category: #''
						timeStamp: 'SamDoe 1/31/2001 01:23'
						source: ''.
					MCMethodDefinition
						className: 'Something'
						selector: #otherSelector
						category: #''
						timeStamp: 'JoDoe 2/31/2001 01:23'
						source: ''})
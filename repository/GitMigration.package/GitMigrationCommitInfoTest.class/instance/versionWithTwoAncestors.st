instance creation
versionWithTwoAncestors
	^ MCVersion new
		package: (MCPackage named: 'XYZ')
		info:
			(MCVersionInfo
				name: 'FastImported-ImportBot.3'
				id: UUID new
				message: 'merge'
				date: Date today
				time: Time now
				author: 'ImportBot'
				ancestors:
					{self versionWithoutParent.
					self versionWithoutParent})
		snapshot: MCSnapshot empty
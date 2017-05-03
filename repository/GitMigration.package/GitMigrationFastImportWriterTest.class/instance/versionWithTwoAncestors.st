instance creation
versionWithTwoAncestors
	^ MCVersionInfo
		name: 'FastImported-ImportBot.3'
		id: UUID new
		message: 'merge'
		date: Date today
		time: Time now
		author: 'ImportBot'
		ancestors:
			{self versionWithoutParent.
			self versionWithoutParent}
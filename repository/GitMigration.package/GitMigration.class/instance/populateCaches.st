actions
populateCaches
	self
		do: [ self versionsWithPackageNames.
			self versions ]
		displaying: 'Preparing data...'
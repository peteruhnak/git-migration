writing - memory
copyPackageIn: aVersion toStore: memoryStore
	TonelWriter fileOut: aVersion on: memoryStore.
	self writePropertiesFileTo: memoryStore
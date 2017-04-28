tests - retrieving
testLoadAllCachedVersions
	| result |
	result := migration loadAllCachedVersions.
	self assert: (result keys includes: 'Somewhere-PeterUhnak.1').
	self assert: (result keys includes: 'Somewhere-PeterUhnak.8').
	self assert: (result keys includes: 'CoSomewhere-PeterUhnak.4')
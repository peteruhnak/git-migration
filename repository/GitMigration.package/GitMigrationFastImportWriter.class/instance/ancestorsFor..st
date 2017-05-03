accessing
ancestorsFor: aVersionInfo
	^ aVersionInfo ancestors
		flatCollect: [ :each | 
			(availableVersions includes: each)
				ifTrue: [ {each} ]
				ifFalse: [ self ancestorsFor: each ] ]
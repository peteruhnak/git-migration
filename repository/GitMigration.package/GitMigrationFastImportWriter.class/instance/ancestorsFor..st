accessing
ancestorsFor: aVersionInfo
	| ancestors unresolved processed |
	ancestors := OrderedCollection new.
	unresolved := OrderedCollection new.
	"don't check a parent multiple times"
	processed := Dictionary new.
	unresolved addAll: aVersionInfo ancestors.
	[ unresolved isNotEmpty ]
		whileTrue: [ | next |
			next := unresolved removeFirst.
			processed at: next put: true.
			(availableVersions includesKey: next)
				ifTrue: [ ancestors add: next ]
				ifFalse: [ unresolved addAll: (next ancestors reject: [ :each | processed includesKey: each ]) ] ].
	^ ancestors asArray


	"	^ aVersionInfo ancestors
		flatCollect: [ :each | 
			(availableVersions includesKey: each)
				ifTrue: [ {each} ]
				ifFalse: [ self ancestorsFor: each ] ]"
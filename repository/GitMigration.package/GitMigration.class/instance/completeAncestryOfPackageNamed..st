accessing
completeAncestryOfPackageNamed: aPackageName
	^ completeAncestryCache
		at: aPackageName
		ifAbsentPut: [ | versions allVersions getAncestors parents |
			"Not all versions are actually available directly, so do a very deep search"
			versions := self versionsByPackage at: aPackageName.
			allVersions := Set new.
			getAncestors := [ :parent | 
			(allVersions includes: parent)
				ifTrue: [ #() ]
				ifFalse: [ parent ancestors ] ].
			versions
				do: [ :version | 
					parents := Array with: version.
					[ parents isNotEmpty ]
						whileTrue: [ | allAncestors ancestors |
							allAncestors := parents flatCollect: [ :p | getAncestors value: p ].
							"The history can get trimmed, with only ID preserved and nothing else"
							ancestors := allAncestors reject: [ :e | e name = '' ].
							allVersions addAll: parents.
							parents := ancestors ] ].
			allVersions ]
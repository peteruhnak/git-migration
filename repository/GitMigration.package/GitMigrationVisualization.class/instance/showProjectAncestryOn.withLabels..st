visualizations
showProjectAncestryOn: aCollectionOfPackages withLabels: hasLabels
	| b allVersions sorted |
	b := RTMondrian new.
	b shape box
		fillColor: Color transparent;
		borderColor: Color black.
	b
		nodes:
			(migration versionsByPackage associations
				select: [ :pair | aCollectionOfPackages includes: pair key ])
		forEach: [ :pair | 
			| pkgName versions realRoots realTails |
			pkgName := pair key.
			versions := pair value.
			allVersions := migration completeAncestryOfPackageNamed: pkgName.
			sorted := migration topologicallySort: allVersions.
			realRoots := sorted
				select: [ :version | sorted noneSatisfy: [ :each | each ancestors includes: version ] ].
			realTails := sorted select: [ :each | each ancestors isEmpty ].
			hasLabels
				ifTrue: [ b shape text
						text: [ :each | 
							each name , String cr , each timeStamp truncated printString , String cr , (each message truncateTo: 20)
								, ' (' , each versionNumber asString , ')' , String cr
								, (sorted indexOf: each) printString ] ]
				ifFalse: [ b shape box
						color: Color veryLightGray;
						size: 20 ].
			b shape
				fillColor: Color black;
				if: [ :each | (versions includes: each) not ] fillColor: self missingColor;
				if: [ :each | realRoots includes: each ] fillColor: self tailColor;
				if: [ :each | realTails includes: each ] fillColor: self rootColor.
			b nodes: sorted.
			b edges shape arrowedLine withShorterDistanceAttachPointWithJump.
			"	head: RTEmptyNarrowArrow asHead;"
			b edges connectFromAll: #ancestors.
			b layout dominanceTree horizontalGap: 30
			"b layout sugiyama horizontalGap: 30 "].
	b view @ RTZoomableView.
	^ b
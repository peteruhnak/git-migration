visualizations
showProjectAncestryOn: aCollectionOfPackages withLabels: aBoolean
	| b allVersions sorted |
	b := RTMondrian new.
	b shape box
		fillColor: Color transparent;
		borderColor: Color black.
	b
		nodes:
			(self versionsByPackage associations
				select: [ :pair | aCollectionOfPackages includes: pair key ])
		forEach: [ :pair | 
			| pkgName versions realRoots realTails |
			pkgName := pair key.
			versions := pair value.
			allVersions := self completeAncestryOfPackageNamed: pkgName.
			sorted := self topologicallySort: allVersions.
			realRoots := sorted
				select: [ :version | sorted noneSatisfy: [ :each | each ancestors includes: version ] ].
			realTails := sorted select: [ :each | each ancestors isEmpty ].
			aBoolean
				ifTrue: [ b shape text
						text: [ :each | 
							each name , String cr , each timeStamp printString , String cr
								, (sorted indexOf: each) printString ] ]
				ifFalse: [ b shape box
						color: Color veryLightGray;
						size: 20 ].
			b shape
				fillColor: Color white;
				if: [ :each | (versions includes: each) not ] fillColor: Color magenta;
				if: [ :each | realRoots includes: each ] fillColor: Color cyan;
				if: [ :each | realTails includes: each ] fillColor: Color yellow.
			b nodes: sorted.
			b edges shape arrowedLine withShorterDistanceAttachPointWithJump.
			"	head: RTEmptyNarrowArrow asHead;"
			b edges connectFromAll: #ancestors.
			b layout sugiyama horizontalGap: 30 ].
	b view @ RTZoomableView.
	^ b
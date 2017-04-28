visualizations
showProjectAncestry
	| b allVersions sorted |
	b := RTMondrian new.
	b shape box
		fillColor: Color transparent;
		borderColor: Color black.
	b
		nodes: self versionsByPackage associations
		forEach: [ :pair | 
			| pkgName versions realRoots realTails |
			pkgName := pair key.
			versions := pair value.
			allVersions := self completeAncestryOfPackageNamed: pkgName.
			sorted := self topologicallySort: allVersions.
			realRoots := sorted
				select: [ :version | sorted noneSatisfy: [ :each | each ancestors includes: version ] ].
			realTails := sorted select: [ :each | each ancestors isEmpty ].
			b shape text
				text: [ :each | 
					each name , String cr , each timeStamp printString , String cr
						, (sorted indexOf: each) printString ];
				if: [ :each | (versions includes: each) not ] fillColor: Color purple;
				if: [ :each | realRoots includes: each ] fillColor: Color blue;
				if: [ :each | realTails includes: each ] fillColor: Color red.
			b nodes: sorted.
			b edges shape arrowedLine
			"	head: RTEmptyNarrowArrow asHead;"
				withShorterDistanceAttachPointWithJump.
			b edges connectFromAll: #ancestors.
			b layout sugiyama horizontalGap: 30 ].
	b view @ RTZoomableView.
	^ b
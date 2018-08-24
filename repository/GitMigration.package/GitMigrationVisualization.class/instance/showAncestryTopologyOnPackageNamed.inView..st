visualizations
showAncestryTopologyOnPackageNamed: aPackageName inView: aView
	| versions sorted realRoots realTails b |
	versions := migration versionsByPackage at: aPackageName.
	sorted := migration topologicallySort: (migration completeAncestryOfPackageNamed: aPackageName).
	realRoots := sorted
		select: [ :version | sorted noneSatisfy: [ :each | each ancestors includes: version ] ].
	realTails := sorted select: [ :each | each ancestors isEmpty ].
	b := RTMondrian new.
	b view: aView.
	b shape text
		text: [ :each | 
			each name , String cr , each timeStamp printString , String cr
				, (sorted indexOf: each) printString ];
		fillColor: Color black;
		if: [ :each | (versions includes: each) not ] fillColor: self missingColor;
		if: [ :each | realRoots includes: each ] fillColor: self tailColor;
		if: [ :each | realTails includes: each ] fillColor: self rootColor.
	b nodes: sorted.
	b edges shape arrowedLine head: RTEmptyNarrowArrow asHead.
	b edges connectFromAll: #ancestors.
	b layout dominanceTree horizontalGap: 30.
	b build.
	^ b view
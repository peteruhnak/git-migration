visualizations
showAncestryTopologyOnPackageNamed: aPackageName inView: aView
	| versions sorted realRoots realTails b |
	versions := self versionsByPackage at: aPackageName.
	sorted := self topologicallySort: (self completeAncestryOfPackageNamed: aPackageName).
	realRoots := sorted
		select: [ :version | sorted noneSatisfy: [ :each | each ancestors includes: version ] ].
	realTails := sorted select: [ :each | each ancestors isEmpty ].
	b := RTMondrian new.
	b view: aView.
	b shape text
		text: [ :each | 
			each name , String cr , each timeStamp printString , String cr
				, (sorted indexOf: each) printString ];
		if: [ :each | (versions includes: each) not ] fillColor: Color purple;
		if: [ :each | realRoots includes: each ] fillColor: Color blue;
		if: [ :each | realTails includes: each ] fillColor: Color red.
	b nodes: sorted.
	b edges shape arrowedLine head: RTEmptyNarrowArrow asHead.
	b edges connectFromAll: #ancestors.
	b layout dominanceTree horizontalGap: 30.
	b build.
	^ b view
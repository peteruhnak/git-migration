"
I visualize an mcz history.
"
Class {
	#name : #GitMigrationVisualization,
	#superclass : #Object,
	#instVars : [
		'migration'
	],
	#category : 'GitMigration'
}

{ #category : #'instance creation' }
GitMigrationVisualization class >> on: aProjectName [
	^ self new
		projectName: aProjectName;
		yourself
]

{ #category : #accessing }
GitMigrationVisualization >> migration [
	^ migration
]

{ #category : #accessing }
GitMigrationVisualization >> migration: anObject [
	migration := anObject
]

{ #category : #colors }
GitMigrationVisualization >> missingColor [
	^ Color magenta
]

{ #category : #colors }
GitMigrationVisualization >> rootColor [
	^ Color yellow
]

{ #category : #'visualizations - wrappers' }
GitMigrationVisualization >> showAncestryTopologyOnPackageNamed: aPackageName [
	| view |
	view := RTView new.
	view @ RTZoomableView @ RTDraggableView.
	^ self showAncestryTopologyOnPackageNamed: aPackageName inView: view
]

{ #category : #visualizations }
GitMigrationVisualization >> showAncestryTopologyOnPackageNamed: aPackageName inView: aView [
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
]

{ #category : #'visualizations - wrappers' }
GitMigrationVisualization >> showProjectAncestry [
	^ self showProjectAncestryWithLabels: false
]

{ #category : #'visualizations - wrappers' }
GitMigrationVisualization >> showProjectAncestryOn: aCollectionOfPackages [
	^ self showProjectAncestryOn: aCollectionOfPackages withLabels: false
]

{ #category : #visualizations }
GitMigrationVisualization >> showProjectAncestryOn: aCollectionOfPackages withLabels: hasLabels [
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
]

{ #category : #'visualizations - wrappers' }
GitMigrationVisualization >> showProjectAncestryWithLabels [
	^ self showProjectAncestryWithLabels: true
]

{ #category : #'visualizations - wrappers' }
GitMigrationVisualization >> showProjectAncestryWithLabels: aBoolean [
	^ self showProjectAncestryOn: migration versionsByPackage keys withLabels: aBoolean
]

{ #category : #colors }
GitMigrationVisualization >> tailColor [
	^ Color cyan
]

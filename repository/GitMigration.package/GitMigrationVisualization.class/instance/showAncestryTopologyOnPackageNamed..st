visualizations - wrappers
showAncestryTopologyOnPackageNamed: aPackageName
	| view |
	view := RTView new.
	view @ RTZoomableView @ RTDraggableView.
	^ self showAncestryTopologyOnPackageNamed: aPackageName inView: view
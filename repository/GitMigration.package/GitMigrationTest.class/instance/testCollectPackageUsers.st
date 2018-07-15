tests - accessing
testCollectPackageUsers

	| pkgUsers gm |
	gm := GitMigration new.
	pkgUsers := gm collectPackageUsers: 'Kernel'.
	self assert: (pkgUsers isKindOf: Collection).
	self deny: pkgUsers isEmpty.
	self assert: (pkgUsers first isKindOf: Association).
	self deny: pkgUsers first key isEmpty.
	self assert: (pkgUsers first value isKindOf: Collection).
	self deny: pkgUsers first value isEmpty.
	self assert: pkgUsers first value second equals: '@.'

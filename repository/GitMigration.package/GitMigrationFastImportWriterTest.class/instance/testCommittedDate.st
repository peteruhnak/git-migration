tests - accessing
testCommittedDate
	"the DT should be +- equal (lets say less then 2 seconds)"

	self
		assert:
			((writer committedDateFor: self versionWithoutParent) allButLast: 6) asNumber
				- DateAndTime now rounded asUnixTime < 2
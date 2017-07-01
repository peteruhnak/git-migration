tests - commit transform
testCommittedDate
	"the DT should be +- equal (lets say less then 2 seconds)"

	self
		assert:
			((self commitInfoFor: self versionWithoutParent) committedDate allButLast: 6)
				asNumber - DateAndTime now rounded asUnixTime < 2
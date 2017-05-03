accessing
committedDateFor: aVersionInfo
	^ DateAndTime now rounded asUnixTime asString , ' +0000'
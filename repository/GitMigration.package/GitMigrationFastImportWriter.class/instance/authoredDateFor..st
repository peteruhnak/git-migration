accessing
authoredDateFor: aVersionInfo
	"MCVersionInfo has no information of the timezone, so Pharo automatically adds the local TZ of the user; as this depends where the user is, we translate it to UTC, so two people in different timezones see the same time"

	^ aVersionInfo timeStamp translateToUTC rounded asUnixTime asString , ' +0000'
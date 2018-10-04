"
I represent a single commit in the history.
"
Class {
	#name : #GitMigrationCommitInfo,
	#superclass : #Object,
	#instVars : [
		'info',
		'author',
		'committer',
		'parents',
		'branch',
		'coauthors'
	],
	#category : 'GitMigration-FastImport'
}

{ #category : #'instance creation' }
GitMigrationCommitInfo class >> info: aVersionInfo mapping: aMapping committer: aCommitter coauthors: aCoauthorsList [
	^ self new
		info: aVersionInfo;
		author: (aMapping at: aVersionInfo author);
		coauthors:
			(aCoauthorsList \ {aVersionInfo author}
				collect: [ :each | aMapping at: each ]);
		committer: aCommitter
]

{ #category : #accessing }
GitMigrationCommitInfo >> author [
	^ author
]

{ #category : #accessing }
GitMigrationCommitInfo >> author: anAuthor [
	author := anAuthor
]

{ #category : #accessing }
GitMigrationCommitInfo >> authorEmail [
	^ author email
]

{ #category : #accessing }
GitMigrationCommitInfo >> authorName [
	^ author name
]

{ #category : #accessing }
GitMigrationCommitInfo >> authoredDate [
	"MCVersionInfo has no information of the timezone, so Pharo automatically adds the local TZ of the user; as this depends where the user is, we translate it to UTC, so two people in different timezones see the same time"

	^ info timeStamp translateToUTC rounded
]

{ #category : #accessing }
GitMigrationCommitInfo >> branch [
	^ branch
]

{ #category : #accessing }
GitMigrationCommitInfo >> branch: anObject [
	branch := anObject
]

{ #category : #accessing }
GitMigrationCommitInfo >> coauthors [
	^ coauthors \ {author}
]

{ #category : #accessing }
GitMigrationCommitInfo >> coauthors: aCollection [
	coauthors := aCollection
]

{ #category : #accessing }
GitMigrationCommitInfo >> commitMessage [
	^ String
		<< [ :stream | 
			stream << (info message copyWithout: Character null) withUnixLineEndings.
			(self coauthors sorted: #name ascending)
				ifNotEmpty: [ :co | 
					stream lf.
					stream lf.
					co
						do: [ :each | stream << 'Co-authored-by: ' << each name << ' <' << each email << '>' ]
						separatedBy: [ stream lf ] ] ]
]

{ #category : #accessing }
GitMigrationCommitInfo >> committedDate [
	^ DateAndTime now
]

{ #category : #accessing }
GitMigrationCommitInfo >> committer [
	^ committer
]

{ #category : #accessing }
GitMigrationCommitInfo >> committer: anAuthor [
	committer := anAuthor
]

{ #category : #accessing }
GitMigrationCommitInfo >> committerEmail [
	^ committer email
]

{ #category : #accessing }
GitMigrationCommitInfo >> committerName [
	^ committer name
]

{ #category : #accessing }
GitMigrationCommitInfo >> info [
	^ info
]

{ #category : #accessing }
GitMigrationCommitInfo >> info: anObject [
	info := anObject
]

{ #category : #accessing }
GitMigrationCommitInfo >> initialize [
	super initialize.
	branch := 'master'
]

{ #category : #accessing }
GitMigrationCommitInfo >> parents [
	^ parents
]

{ #category : #accessing }
GitMigrationCommitInfo >> parents: anObject [
	parents := anObject
]

{ #category : #printing }
GitMigrationCommitInfo >> printOn: aStream [
	aStream
		<< self info versionNumber;
		<< ' ['.
	self parents
		do: [ :each | aStream << each info versionNumber ]
		separatedBy: [ aStream << ', ' ].
	aStream << ']'.
	aStream
		<< ' @';
		<< self branch name
]

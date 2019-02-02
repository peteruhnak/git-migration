Class {
	#name : #GitMigrationCommitInfoTest,
	#superclass : #TestCase,
	#instVars : [
		'authorMapping',
		'committer',
		'writer'
	],
	#category : 'GitMigration-Tests'
}

{ #category : #'instance creation' }
GitMigrationCommitInfoTest >> commitInfoFor: aVersionInfo [
	^ writer commitInfoFor: aVersionInfo
]

{ #category : #running }
GitMigrationCommitInfoTest >> ensureAllCached [
	(MCCacheRepository uniqueInstance directory children
		noneSatisfy: [ :each | each basename = 'Somewhere-PeterUhnak.2.mcz' ])
		ifTrue: [ (GitMigration on: 'peteruhnak/breaking-mcz') cacheAllVersions ]
]

{ #category : #running }
GitMigrationCommitInfoTest >> ensureGitFileTreeLoaded [
	(Smalltalk hasClassNamed: #MCFileTreeGitRepository)
		ifFalse: [ (CatalogProvider projectNamed: 'GitFileTree') installVersion: #stable ]
]

{ #category : #running }
GitMigrationCommitInfoTest >> ensureTestRepoLoaded [
	| repo |
	repo := MCSmalltalkhubRepository new.
	repo owner: 'peteruhnak'.
	repo project: 'breaking-mcz'.
	MCRepositoryGroup default addRepository: repo
]

{ #category : #running }
GitMigrationCommitInfoTest >> setUp [
	super setUp.
	self timeLimit: 1 minute.
	self ensureTestRepoLoaded.
	"	self ensureGitFileTreeLoaded."
	self ensureAllCached.
	writer := GitMigrationFastImportWriter new.
	authorMapping := GitMigrationAuthorMapping new
		shortName: 'ImportBot' name: 'Import Bot' email: 'importbot@example.com';
		shortName: 'CommitterBot' name: 'Committer Bot' email: 'committerbot@example.com';
		shortName: 'JoDoe' name: 'Jo Doe' email: '';
		shortName: 'SamDoe' name: 'Sam Doe' email: 'samdoe@example.com'.
	committer := authorMapping at: 'CommitterBot'.
	writer committerName: 'CommitterBot'.
	writer authorMapping: authorMapping
]

{ #category : #'tests - commit transform' }
GitMigrationCommitInfoTest >> testAuthorEmail [
	self
		assert: (self commitInfoFor: self versionWithoutParent) authorEmail
		equals: 'importbot@example.com'
]

{ #category : #'tests - commit transform' }
GitMigrationCommitInfoTest >> testAuthorName [
	self
		assert: (self commitInfoFor: self versionWithoutParent) authorName
		equals: 'Import Bot'
]

{ #category : #'tests - commit transform' }
GitMigrationCommitInfoTest >> testAuthoredDate [
	self
		assert: (self commitInfoFor: self versionWithoutParent) authoredDate
		equals: (DateAndTime fromUnixTime: 977329230)	"'2000-12-20T16:20:30+00:00'"
]

{ #category : #'tests - commit transform' }
GitMigrationCommitInfoTest >> testCommitMessage [
	self
		assert: (self commitInfoFor: self versionWithoutParent) commitMessage
		equals: 'Initial MC commit'
]

{ #category : #'tests - commit transform' }
GitMigrationCommitInfoTest >> testCommitMessageNull [
	"https://github.com/peteruhnak/git-migration/issues/15"

	self
		assert: (self commitInfoFor: self versionWithNull) commitMessage
		equals: 'Null here >< and there ><' withUnixLineEndings
]

{ #category : #'tests - commit transform' }
GitMigrationCommitInfoTest >> testCommitMessageWithCoauthors [
	self
		assert: (self commitInfoFor: self versionWithCoauthors) commitMessage
		equals:
			'Version with coauthors

Co-authored-by: Jo Doe <>
Co-authored-by: Sam Doe <samdoe@example.com>' withUnixLineEndings
]

{ #category : #'tests - commit transform' }
GitMigrationCommitInfoTest >> testCommittedDate [
	"the DT should be +- equal (lets say less then 2 seconds)"

	self
		assert:
			(self commitInfoFor: self versionWithoutParent) committedDate asUnixTime
				- DateAndTime now rounded asUnixTime < 2
]

{ #category : #'tests - commit transform' }
GitMigrationCommitInfoTest >> testCommitterEmail [
	self
		assert: (self commitInfoFor: self versionWithoutParent) committerEmail
		equals: 'committerbot@example.com'
]

{ #category : #'tests - commit transform' }
GitMigrationCommitInfoTest >> testCommitterName [
	self assert: (self commitInfoFor: self versionWithoutParent) committerName equals: 'Committer Bot'
]

{ #category : #'tests - commit transform' }
GitMigrationCommitInfoTest >> testDefaultBranch [
	self assert: (self commitInfoFor: self versionWithoutParent) branch equals: 'master'
]

{ #category : #'instance creation' }
GitMigrationCommitInfoTest >> versionWithCoauthors [
	^ MCVersion
		package: (MCPackage named: 'XYZ')
		info:
			(MCVersionInfo
				name: 'FastImported-ImportBot.5'
				id: UUID new
				message: 'Version with coauthors'
				date: (Date year: 2000 month: 12 day: 20)
				time: (Time hour: 16 minute: 20 second: 30)
				author: 'ImportBot'
				ancestors: #())
		snapshot:
			(MCSnapshot
				fromDefinitions:
					{MCMethodDefinition
						className: 'Something'
						selector: #selector
						category: #''
						timeStamp: 'SamDoe 1/31/2001 01:23'
						source: ''.
					MCMethodDefinition
						className: 'Something'
						selector: #otherSelector
						category: #''
						timeStamp: 'JoDoe 2/31/2001 01:23'
						source: ''})
]

{ #category : #'instance creation' }
GitMigrationCommitInfoTest >> versionWithNull [
	^ MCVersion
		package: (MCPackage named: 'XYZ')
		info:
			(MCVersionInfo
				name: 'FastImported-ImportBot.1'
				id: UUID new
				message: 'Null here >' , Character null asString , '< and there >' , Character null asString , '<'
				date: (Date year: 2000 month: 12 day: 20)
				time: (Time hour: 16 minute: 20 second: 30)
				author: 'ImportBot'
				ancestors: #())
		snapshot: MCSnapshot empty
]

{ #category : #'instance creation' }
GitMigrationCommitInfoTest >> versionWithTwoAncestors [
	^ MCVersion new
		package: (MCPackage named: 'XYZ')
		info:
			(MCVersionInfo
				name: 'FastImported-ImportBot.3'
				id: UUID new
				message: 'merge'
				date: Date today
				time: Time now
				author: 'ImportBot'
				ancestors:
					{self versionWithoutParent.
					self versionWithoutParent})
		snapshot: MCSnapshot empty
]

{ #category : #'instance creation' }
GitMigrationCommitInfoTest >> versionWithoutParent [
	^ MCVersion
		package: (MCPackage named: 'XYZ')
		info:
			(MCVersionInfo
				name: 'FastImported-ImportBot.1'
				id: UUID new
				message: 'Initial MC commit'
				date: (Date year: 2000 month: 12 day: 20)
				time: (Time hour: 16 minute: 20 second: 30)
				author: 'ImportBot'
				ancestors: #())
		snapshot: MCSnapshot empty
]

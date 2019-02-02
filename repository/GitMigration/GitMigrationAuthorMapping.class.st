"
I am a collection of author identifiers.
"
Class {
	#name : #GitMigrationAuthorMapping,
	#superclass : #Object,
	#instVars : [
		'mapping'
	],
	#category : 'GitMigration-FastImport'
}

{ #category : #'instance creation' }
GitMigrationAuthorMapping >> at: aShortName [
	^ mapping at: aShortName
]

{ #category : #'instance creation' }
GitMigrationAuthorMapping >> initialize [
	super initialize.
	mapping := Dictionary new
]

{ #category : #'instance creation' }
GitMigrationAuthorMapping >> shortName: aShortName name: aFullName email: anEmail [
	mapping
		at: aShortName
		put: (GitMigrationAuthor shortName: aShortName name: aFullName email: anEmail)
]

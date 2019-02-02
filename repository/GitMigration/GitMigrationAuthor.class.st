"
I represent a git commit author (email + name).

shortName is an identifier to match the author against a MC commit author.
"
Class {
	#name : #GitMigrationAuthor,
	#superclass : #Object,
	#instVars : [
		'shortName',
		'name',
		'email'
	],
	#category : #'GitMigration-FastImport'
}

{ #category : #'instance creation' }
GitMigrationAuthor class >> shortName: aShortName name: aName email: anEmail [
	^ self new
		shortName: aShortName;
		name: aName;
		email: anEmail;
		yourself
]

{ #category : #accessing }
GitMigrationAuthor >> email [
	^ email
]

{ #category : #accessing }
GitMigrationAuthor >> email: aString [
	email := aString
]

{ #category : #accessing }
GitMigrationAuthor >> name [
	^ name
]

{ #category : #accessing }
GitMigrationAuthor >> name: anObject [
	name := anObject
]

{ #category : #accessing }
GitMigrationAuthor >> shortName [
	^ shortName
]

{ #category : #accessing }
GitMigrationAuthor >> shortName: aString [
	shortName := aString
]

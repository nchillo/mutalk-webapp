Class {
	#name : #MutalkWebRunnerSession,
	#superclass : #WillowSession,
	#instVars : [
		'applicationContext'
	],
	#category : #'MuTalk-Web-Application'
}

{ #category : #accessing }
MutalkWebRunnerSession >> applicationContext [

	^ applicationContext
]

{ #category : #Controlling }
MutalkWebRunnerSession >> startUpApplicationContextFor: aTestRunner [

	super startUpApplicationContextFor: aTestRunner.
	applicationContext := MutalkWebRunnerApplicationContext new
]

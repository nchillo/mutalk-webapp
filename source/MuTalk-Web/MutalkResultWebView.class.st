Class {
	#name : #MutalkResultWebView,
	#superclass : #WAPainter,
	#category : #'MuTalk-Web-Webviews'
}

{ #category : #rendering }
MutalkResultWebView >> renderContentOn: html [

	| notificationBuilder testResult score|

	testResult := self session applicationContext currentMutationResult.
	score := (MutationScoreBehavior buildFor: testResult) .
	notificationBuilder := self componentSupplier notificationBuilder.
	notificationBuilder
		success;
		wrapping: [ :canvas | 
			canvas
				render: testResult;
				space;
				break;
				render: (BootstrapIconWebView representing: Glyphicons time);
				strong: ' Elapsed time: ';
				render: testResult elapsedTime printString].

	score isAlmostAcceptableScore
		ifTrue: [ notificationBuilder warning ].
	score isNonAcceptableScore
		ifTrue: [ notificationBuilder danger ].

	html render: notificationBuilder build
]

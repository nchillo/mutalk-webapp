Class {
	#name : #MutalkResultWebView,
	#superclass : #WAPainter,
	#category : #'MuTalk-Web-Webviews'
}

{ #category : #rendering }
MutalkResultWebView >> detailsLinkShowing: testResult [

	| showDetailsAnchor |

	showDetailsAnchor := self componentSupplier
		asynchronicLinkActingAsButtonLabeled: 'See the details here.'
		applying: [ :anchor | anchor addClass bootstrap alertLink ].
	showDetailsAnchor onTrigger open: (WPTestRunnerTestResultDetailsDialog for: testResult).
	^ showDetailsAnchor
]

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
				render: testResult].

	score isAlmostAcceptableScore
		ifTrue: [ notificationBuilder warning ].
	score isNonAcceptableScore
		ifTrue: [ notificationBuilder danger ].

	html render: notificationBuilder build
]

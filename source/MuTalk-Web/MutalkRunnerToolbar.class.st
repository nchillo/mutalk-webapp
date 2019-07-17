Class {
	#name : #MutalkRunnerToolbar,
	#superclass : #WAPainter,
	#instVars : [
		'runSelectedTestsButton',
		'runProfiledButton',
		'exportResultButton'
	],
	#category : #'MuTalk-Web-Webviews'
}

{ #category : #initialization }
MutalkRunnerToolbar >> initialize [

	super initialize.
	self
		initializeRunSelectedTestsButton;
		initializeRunProfiledButton;
		initializeExportResultButton
]

{ #category : #initialization }
MutalkRunnerToolbar >> initializeExportResultButton [

	exportResultButton := FileDownloadAnchorWebView
		labeled: (self label: 'Download' prependedBy: Glyphicons cloudDownload)
		applying: [ :button | button addClass bootstrap button + button addClass bootstrap buttonDefault + button addClass bootstrap pullRight ]
		obtainingFileUsing: [ WAMimeDocument on: (String streamContents: [ :stream | self session applicationContext currentTestResult fileOutOn: stream ]) mimeType: WAMimeType textPlain fileName: 'test-results.txt' ]
]

{ #category : #initialization }
MutalkRunnerToolbar >> initializeRunProfiledButton [

	runProfiledButton := self componentSupplier asynchronicButtonLabeled: (self label: 'Run Profiled' prependedBy: Glyphicons stats) applying: [ :button | button addClass bootstrap buttonDefault ]
]

{ #category : #initialization }
MutalkRunnerToolbar >> initializeRunSelectedTestsButton [

	runSelectedTestsButton := self componentSupplier asynchronicButtonLabeled: (self label: 'Run Selected' prependedBy: Glyphicons play) applying: [ :button | button addClass bootstrap buttonDefault ]
]

{ #category : #private }
MutalkRunnerToolbar >> label: aText prependedBy: anIconClass [

	^ [ :canvas | 
	canvas
		render: (BootstrapIconWebView representing: anIconClass);
		space;
		render: aText ]
]

{ #category : #Interaction }
MutalkRunnerToolbar >> onRunProfiledTrigger [

	^ runProfiledButton onTrigger
]

{ #category : #Interaction }
MutalkRunnerToolbar >> onRunSelectedTestsTrigger [

	^ runSelectedTestsButton onTrigger
]

{ #category : #rendering }
MutalkRunnerToolbar >> renderContentOn: html [

	html div
		with: [ 
			html div
				with: [ html
						render: runSelectedTestsButton;
						render: runProfiledButton ]
				applying: [ :div | div addClass bootstrap buttonGroup ].
			html render: exportResultButton ]
		applying: [ :div | div addClass bootstrap buttonToolbar ].
	html div: [ html space ]
]

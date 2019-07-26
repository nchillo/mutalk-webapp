Class {
	#name : #MutalkRunnerToolbar,
	#superclass : #WAPainter,
	#instVars : [
		'runSelectedTestsButton',
		'exportResultButton'
	],
	#category : #'MuTalk-Web-Webviews'
}

{ #category : #initialization }
MutalkRunnerToolbar >> initialize [

	super initialize.
	self
		initializeRunMutationButton;
		initializeExportResultButton
]

{ #category : #initialization }
MutalkRunnerToolbar >> initializeExportResultButton [

	exportResultButton := FileDownloadAnchorWebView
		labeled: ( self label: 'Download' prependedBy: Glyphicons cloudDownload )
		applying: [ :button | 
			button addClass bootstrap button + button addClass bootstrap buttonDefault
				+ button addClass bootstrap pullRight
			]
		obtainingFileUsing: [ WAMimeDocument
				on:
					( String
						streamContents: [ :stream | stream nextPutAll: (MutationTestingGeneralResultReporter for: self session applicationContext currentMutationResult) value] )
				mimeType: WAMimeType textPlain
				fileName: 'test-results.txt'
			]
]

{ #category : #initialization }
MutalkRunnerToolbar >> initializeRunMutationButton [

	runSelectedTestsButton := self componentSupplier
		asynchronicButtonLabeled: ( self label: 'Run Mutation Analysis' prependedBy: Glyphicons play )
		applying: [ :button | button addClass bootstrap buttonDefault ]
]

{ #category : #private }
MutalkRunnerToolbar >> label: aText prependedBy: anIconClass [

	^ [ :canvas | 
	canvas
		render: ( BootstrapIconWebView representing: anIconClass );
		space;
		render: aText
	]
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
						render: runSelectedTestsButton]
				applying: [ :div | div addClass bootstrap buttonGroup ].
			html render: exportResultButton ]
		applying: [ :div | div addClass bootstrap buttonToolbar ].
	html div: [ html space ]
]

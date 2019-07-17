Class {
	#name : #MutalkRunnerSuiteSelectionWebView,
	#superclass : #WAPainter,
	#instVars : [
		'testCaseClassesListBox',
		'identifiedTestCaseClassesSelection',
		'testPackagesListBox',
		'modelPackagesListBox',
		'identifiedModelClassesSelection',
		'modelClassesListBox'
	],
	#category : #'MuTalk-Web-Webviews'
}

{ #category : #initialization }
MutalkRunnerSuiteSelectionWebView >> initialize [

	super initialize.
	self
		initializeTestCaseClassesSelection;
		initializeIdentifiedTestCaseClassesSelection;
		initializePackageSelection;
		initializeModelClassesSelection;
		initializeIdentifiedModelClassesSelection;
		initializeModelPackageSelection
]

{ #category : #initialization }
MutalkRunnerSuiteSelectionWebView >> initializeIdentifiedModelClassesSelection [

	identifiedModelClassesSelection := IdentifiedWebView
		forDivNamed: 'model-selection'
		containing: [ :canvas | 
			canvas
				render:
					( self componentSupplier
						delayedViewShowing: SpinKitCircle new
						whileEvaluating: [ modelClassesListBox
								allowAnyOf: self session applicationContext availableModelClasses
							]
						thenRendering: ( self labeledViewDisplaying: 'Classes' boundTo: modelClassesListBox ) )
			]
]

{ #category : #initialization }
MutalkRunnerSuiteSelectionWebView >> initializeIdentifiedTestCaseClassesSelection [

	identifiedTestCaseClassesSelection := IdentifiedWebView
		forDivNamed: 'test-case-selection'
		containing: [ :canvas | 
			canvas
				render:
					(self componentSupplier
						delayedViewShowing: SpinKitCircle new
						whileEvaluating: [ testCaseClassesListBox allowAnyOf: self session applicationContext availableTestCaseClasses ]
						thenRendering: (self labeledViewDisplaying: 'Test Cases' boundTo: testCaseClassesListBox)) ]
]

{ #category : #initialization }
MutalkRunnerSuiteSelectionWebView >> initializeModelClassesSelection [

	modelClassesListBox := self componentSupplier
		multipleSelectionListBoxDisplayingAtOnce: 10
		applying: [  ].
	modelClassesListBox onTrigger
		evaluate: [ self session applicationContext
				setSelectedModelClassesTo: modelClassesListBox currentSelection
			]
]

{ #category : #initialization }
MutalkRunnerSuiteSelectionWebView >> initializeModelPackageSelection [

	modelPackagesListBox := self componentSupplier
		multipleSelectionListBoxDisplayingAtOnce: 10
		applying: [  ].
	modelPackagesListBox onTrigger
		evaluate: [ self session applicationContext
				setSelectedModelPackageCategoriesTo: modelPackagesListBox currentSelection
			];
		render: identifiedModelClassesSelection
]

{ #category : #initialization }
MutalkRunnerSuiteSelectionWebView >> initializePackageSelection [

	testPackagesListBox := self componentSupplier
		multipleSelectionListBoxDisplayingAtOnce: 10
		applying: [  ].
	testPackagesListBox onTrigger
		evaluate: [ self session applicationContext setSelectedPackageCategoriesTo: testPackagesListBox currentSelection ];
		render: identifiedTestCaseClassesSelection
]

{ #category : #initialization }
MutalkRunnerSuiteSelectionWebView >> initializeTestCaseClassesSelection [

	testCaseClassesListBox := self componentSupplier
		multipleSelectionListBoxDisplayingAtOnce: 10
		applying: [  ].
	testCaseClassesListBox onTrigger
		evaluate: [ self session applicationContext
				setSelectedTestCaseClassesTo: testCaseClassesListBox currentSelection
			]
]

{ #category : #private }
MutalkRunnerSuiteSelectionWebView >> labeledViewDisplaying: aLabel boundTo: aField [

	^ BootstrapLabeledWebView
		displaying: aLabel
		applying: [  ]
		boundTo: aField
		applying: [  ]
]

{ #category : #rendering }
MutalkRunnerSuiteSelectionWebView >> renderContentOn: html [

	html
		render: self testCaseSelection;
		render: self renderModelSelection
]

{ #category : #rendering }
MutalkRunnerSuiteSelectionWebView >> renderModelSelection [

	^ self componentSupplier
		fieldSetContaining:
			( self componentSupplier gridBuilder
				addContent:
					( self componentSupplier
						delayedViewShowing: SpinKitCircle new
						whileEvaluating: [ modelPackagesListBox
								allowAnyOf: self session applicationContext availablePackageCategoriesForModel
							]
						thenRendering:
							( self
								labeledViewDisplaying: 'Package Categories'
								boundTo: modelPackagesListBox ) );
				addContent: identifiedModelClassesSelection;
				build )
		applying: [  ]
		withLegend: 'Classes to Mutate'
		applying: [  ]
]

{ #category : #rendering }
MutalkRunnerSuiteSelectionWebView >> testCaseSelection [

	^ self componentSupplier
		fieldSetContaining:
			( self componentSupplier gridBuilder
				addContent:
					( self componentSupplier
						delayedViewShowing: SpinKitCircle new
						whileEvaluating: [ testPackagesListBox
								allowAnyOf: self session applicationContext availablePackageCategoriesForTests
							]
						thenRendering:
							( self
								labeledViewDisplaying: 'Package Categories'
								boundTo: testPackagesListBox ) );
				addContent: identifiedTestCaseClassesSelection;
				build )
		applying: [  ]
		withLegend: 'Test Case Selection'
		applying: [  ]
]

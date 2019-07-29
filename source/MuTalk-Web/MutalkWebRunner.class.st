Class {
	#name : #MutalkWebRunner,
	#superclass : #WillowApplication,
	#instVars : [
		'contentView'
	],
	#category : #'MuTalk-Web-Application'
}

{ #category : #accessing }
MutalkWebRunner class >> applicationTitle [

	^ 'MuTalk Runner'
]

{ #category : #accessing }
MutalkWebRunner class >> handlerName [

	^ 'mutalk-runner'
]

{ #category : #accessing }
MutalkWebRunner class >> sessionClass [

	^ MutalkWebRunnerSession 
]

{ #category : #Accessing }
MutalkWebRunner >> componentSupplierForApplication [

	^ BootstrapComponentSupplier
		withBootstrapLibrary: (self deploymentMode libraryFor: Bootstrap3MetadataLibrary) withoutOptionalTheme
		selectLibrary: ((self deploymentMode libraryFor: BootstrapSelectLibrary) using: self language)
		datepickerLibrary: ((self deploymentMode libraryFor: BootstrapDatepickerLibrary) using: self language)
		typeaheadLibrary: (self deploymentMode libraryFor: BootstrapTypeaheadLibrary) default
]

{ #category : #accessing }
MutalkWebRunner >> contentView [

	^ contentView
]

{ #category : #hooks }
MutalkWebRunner >> initialRequest: request [

	super initialRequest: request.
	self initializeContainerView
]

{ #category : #initialization }
MutalkWebRunner >> initialize [

	super initialize.
	contentView := [ :canvas |  ]
]

{ #category : #private }
MutalkWebRunner >> initializeContainerView [

	| testResult |

	testResult := IdentifiedWebView forDivNamed: 'test-result' containing: MutalkResultWebView new.
	contentView := GenericContainerWebView
		wrapping:
			(self componentSupplier gridBuilder
				columnsPerRow: 1;
				addContent: (HeadingWebView displaying: 'Mutalk Runner' withLevel: 1);
				addContent: testResult;
				addContent: (self toolbarRenderingOnAction: testResult);
				addContent: MutalkRunnerSuiteSelectionWebView new;
				build)
		applying: [ :div | div addClass bootstrap container ]
]

{ #category : #accessing }
MutalkWebRunner >> jQueryLibrary [

	^ (self deploymentMode libraryFor: JQuery3MetadataLibrary) default
]

{ #category : #updating }
MutalkWebRunner >> requiredLibraries [

	^ {SpinKitMetadataLibrary default}
]

{ #category : #private }
MutalkWebRunner >> toolbarRenderingOnAction: testResult [

	| toolbar |

	toolbar := MutalkRunnerToolbar new.

	toolbar onRunSelectedTestsTrigger
		transform: testResult into: SpinKitTripleBounce new;
		evaluate: [ self session applicationContext runMutationAnalysis ];
		render: testResult.

	^ toolbar
]

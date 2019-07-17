Class {
	#name : #MutalkWebRunnerApplicationContext,
	#superclass : #GRObject,
	#instVars : [
		'currentTestResult',
		'selectedTestCaseClasses',
		'selectedPackageCategories',
		'messageTallyOptional',
		'selectedModelPackageCategories',
		'selectedModelClasses'
	],
	#category : #'MuTalk-Web-Application'
}

{ #category : #Querying }
MutalkWebRunnerApplicationContext >> availableModelClasses [

	| items |

	items := selectedModelPackageCategories
		flatCollect: [ :category | 
			( ( Smalltalk organization listAtCategoryNamed: category )
				collect: [ :each | Smalltalk globals at: each ] )
				select: [ :each | true ]
			].
	^ items asSet sorted: [ :a :b | a name <= b name ]
]

{ #category : #Querying }
MutalkWebRunnerApplicationContext >> availablePackageCategoriesForModel [

	| visible |

	visible := Set new.
	Object
		withAllSubclassesDo:
			[ :each | each category ifNotNil: [ :category | visible add: category ] ].
	^ visible asOrderedCollection sort: [ :a :b | a  < b  ]
]

{ #category : #Querying }
MutalkWebRunnerApplicationContext >> availablePackageCategoriesForTests [

	| categories |

	categories := Set new.
	TestCase
		withAllSubclassesDo:
			[ :class | class category ifNotNil: [ :category | categories add: category ] ].
	^ categories sorted
]

{ #category : #Querying }
MutalkWebRunnerApplicationContext >> availableTestCaseClasses [

	| testCaseClasses |

	testCaseClasses := Set new.
	TestCase
		withAllSubclassesDo: [ :class | 
			(selectedPackageCategories includes: class category)
				ifTrue: [ testCaseClasses add: class ] ].
	^ testCaseClasses sorted: [ :a :b | a name <= b name ]
]

{ #category : #Accessing }
MutalkWebRunnerApplicationContext >> currentTestResult [

	^ currentTestResult
]

{ #category : #initialization }
MutalkWebRunnerApplicationContext >> initialize [

	super initialize.
	self resetTestResult.
	selectedTestCaseClasses := #().
	selectedPackageCategories := #().
	selectedModelClasses := #().
	selectedModelPackageCategories := #().
	messageTallyOptional := Optional unused
]

{ #category : #initialization }
MutalkWebRunnerApplicationContext >> resetTestResult [

	currentTestResult := TestAsserter classForTestResult new
]

{ #category : #private }
MutalkWebRunnerApplicationContext >> runTestSuites: testSuites [

	CurrentExecutionEnvironment runTestsBy: [ testSuites do: [ :suite | suite run: currentTestResult ] ]
]

{ #category : #Actions }
MutalkWebRunnerApplicationContext >> runTests [

	self
		resetTestResult;
		runTestSuites: (selectedTestCaseClasses select: [ :class | class isAbstract not ] thenCollect: [ :class | class suite ])
]

{ #category : #Actions }
MutalkWebRunnerApplicationContext >> runTestsProfiled [

	| messageTally |

	messageTally := MessageTally
		spyOn: [ self runTests ]
		reportOtherProcesses: false
		cutoff: 1
		openResultWindow: false
		closeAfter: false.

	messageTallyOptional := (messageTally tally strictlyPositive and: [ messageTally time strictlyPositive ])
		ifTrue: [ Optional containing: messageTally ]
		ifFalse: [ Optional unused ]
]

{ #category : #'State Tracking' }
MutalkWebRunnerApplicationContext >> setSelectedModelClassesTo: modelClasses [

	selectedModelClasses := modelClasses
]

{ #category : #'as yet unclassified' }
MutalkWebRunnerApplicationContext >> setSelectedModelPackageCategoriesTo: categories [

	selectedModelPackageCategories := categories
]

{ #category : #'State Tracking' }
MutalkWebRunnerApplicationContext >> setSelectedPackageCategoriesTo: categories [

	selectedPackageCategories := categories
]

{ #category : #'State Tracking' }
MutalkWebRunnerApplicationContext >> setSelectedTestCaseClassesTo: testCaseClasses [

	selectedTestCaseClasses := testCaseClasses
]

{ #category : #Accessing }
MutalkWebRunnerApplicationContext >> withMessageTallyDo: aFoundBlock ifNone: aNoneBlock [

	messageTallyOptional withContentDo: aFoundBlock ifUnused: aNoneBlock
]

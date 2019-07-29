Class {
	#name : #MutalkWebRunnerApplicationContext,
	#superclass : #GRObject,
	#instVars : [
		'selectedTestCaseClasses',
		'selectedPackageCategories',
		'selectedModelPackageCategories',
		'selectedModelClasses',
		'currentMutationResult'
	],
	#category : #'MuTalk-Web-Application'
}

{ #category : #Querying }
MutalkWebRunnerApplicationContext >> availableModelClasses [

	| items |

	items := selectedModelPackageCategories
		flatCollect: [ :category | 
			( ( Smalltalk organization listAtCategoryNamed: category )
				collect: [ :each | Smalltalk globals at: each ] ) reject: [ :each | each inheritsFrom: TestCase ]
			].
	^ items asSet sorted: [ :a :b | a name <= b name ]
]

{ #category : #Querying }
MutalkWebRunnerApplicationContext >> availablePackageCategoriesForModel [

	| visible |

	visible := Set new.
	Object
		withAllSubclassesDo: [ :each | 
			( ( each inheritsFrom: TestCase ) not and: [ each category isNotNil ] )
				ifTrue: [ visible add: each category ]
			].
	^ visible asOrderedCollection sort: [ :a :b | a < b ]
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
MutalkWebRunnerApplicationContext >> currentMutationResult [

	^ currentMutationResult
]

{ #category : #initialization }
MutalkWebRunnerApplicationContext >> initialize [

	super initialize.
	self resetMutationResult.
	selectedTestCaseClasses := #().
	selectedPackageCategories := #().
	selectedModelClasses := #().
	selectedModelPackageCategories := #()
]

{ #category : #initialization }
MutalkWebRunnerApplicationContext >> resetMutationResult [

	currentMutationResult := MutationTestingGeneralResult empty
]

{ #category : #Actions }
MutalkWebRunnerApplicationContext >> runMutationAnalysis [

	| analysis |

	analysis := MutationTestingAnalysis
		testCasesFrom: selectedTestCaseClasses
		mutating: selectedModelClasses
		using: MutationTestingConfiguration default.
	currentMutationResult := analysis run
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

Class {
	#name : #BaselineOfMutalkWebApp,
	#superclass : #BaselineOf,
	#category : #BaselineOfMuTalkWebApp
}

{ #category : #baselines }
BaselineOfMutalkWebApp >> baseline: spec [

	<baseline>
	spec
		for: #pharo
		do: [ self
				setUpDependencies: spec;
				baselineMutalkWebApp: spec.
			spec group: 'Development' with: 'Deployment'
			]
]

{ #category : #baselines }
BaselineOfMutalkWebApp >> baselineMutalkWebApp: spec [

	spec
		package: 'Mutalk-WebApp'
			with: [ spec requires: #('Willow-Bootstrap-Deployment' 'Willow-SpinKit-Deployment') ];
		group: 'Deployment' with: 'Mutalk-WebApp'
]

{ #category : #baselines }
BaselineOfMutalkWebApp >> setUpDependencies: spec [

	spec
		baseline: 'WillowBootstrap'
			with: [ spec repository: 'github://ba-st/Willow-Bootstrap:v11/source' ];
		project: 'Willow-Bootstrap-Deployment'
			copyFrom: 'WillowBootstrap'
			with: [ spec loads: 'Deployment' ].

	spec
		baseline: 'WillowSpinKit' with: [ spec repository: 'github://ba-st/Willow-SpinKit:v7/source' ];
		project: 'Willow-SpinKit-Deployment' copyFrom: 'WillowSpinKit' with: [ spec loads: 'Deployment' ]
]

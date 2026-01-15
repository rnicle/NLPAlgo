Class {
	#name : 'Subword',
	#superclass : 'Object',
	#instVars : [
		'subword',
		'occurence',
		'position'
	],
	#category : 'BPE4',
	#package : 'BPE4'
}

{ #category : 'as yet unclassified' }
Subword class >> subword: aString occurence: anInteger [
	|aSubword|
	aSubword := Subword new.
	aSubword subword: aString.
	aSubword occurence: anInteger.
	^aSubword. 
]

{ #category : 'as yet unclassified' }
Subword class >> subword: aString occurence: anInteger position: aLink [
	|aSubword|
	aSubword := self new.
	aSubword subword: aString.
	aSubword occurence: anInteger.
	aSubword position: aLink .
	^ aSubword
]

{ #category : 'comparing' }
Subword >> = aSubword [
	self class = aSubword class ifFalse: [ ^ false ].
	^ self subword = aSubword subword .
]

{ #category : 'operations' }
Subword >> addPairAffectedByMergeWith: aSubword in: aBPE [ 

"Ajout des paires affectes par la fusion dans la variable d'instance affectedPairSet de WordPiece."

	aBPE addToAffectedPairSet: { self subword . aSubword subword }
	 
]

{ #category : 'operations' }
Subword >> addPairWith: aSubword in: aBPE [

"ajout de nouveaux paires dans les variables d'instance pairs et pairPositions de BPE."

	aBPE addNewPairFrom: self and: aSubword

]

{ #category : 'operations' }
Subword >> addPairsScoreWith: aSubword in: aBPE [

"ajout de nouveaux paires dans la variable d'instance pairsScores de WordPiece."

	aBPE addNewPairsScoresFrom: self and: aSubword

]

{ #category : 'comparing' }
Subword >> hash [
    ^ self subword hash
]

{ #category : 'initialize' }
Subword >> initialize [ 
	super initialize .
	subword := String new.
	occurence := SmallInteger 
]

{ #category : 'accessing' }
Subword >> occurence [
	^occurence 
]

{ #category : 'accessing' }
Subword >> occurence: anInteger [
	occurence := anInteger 
]

{ #category : 'accessing' }
Subword >> position [
	^ position 
]

{ #category : 'accessing' }
Subword >> position: aLink [
	position := aLink 
]

{ #category : 'accessing' }
Subword >> subword [
	^subword 
]

{ #category : 'accessing' }
Subword >> subword: aString [
	subword := aString 
]

{ #category : 'operations' }
Subword >> tryAddPairAffectedByMergeWith: anObject in: aBPE [
"Essaie d'ajouter une paire dans affectedPairSet de WordPiece en déléguant l’opération
à anObject, si celui-ci n'est pas nil."
		
	anObject ifNil: [ ^self ].
	anObject addPairAffectedByMergeWith: self in: aBPE 
]

{ #category : 'operations' }
Subword >> tryAddPairWith: anObject in: aBPE [
"Essaie d’ajouter une paire dans pairs et pairPositions de BPE en déléguant l’opération
à anObject. Ne fait rien si anObject est nil."

	anObject ifNil: [ ^self ].
	anObject addPairWith: self in: aBPE 
	
	

]

{ #category : 'operations' }
Subword >> tryAddPairsScoreWith: anObject in: aBPE [
"Essaie d'ajouter une paire dans pairsScores de WordPiece en déléguant l’opération
à anObject, si celui-ci n'est pas nil."

	anObject ifNil: [ ^self ].
	anObject addPairsScoreWith: self in: aBPE 
	
	

]

{ #category : 'operations' }
Subword >> tryUpdatePairWith: aSubword in: aBPE [
"Essaie de mettre à jour une paire dans pairs et pairPositions de BPE en déléguant l’opération
à anObject, si celui-ci n'est pas nil."

	aSubword ifNil: [ ^self ].
	aSubword updatePairWith: self in: aBPE
	
]

{ #category : 'operations' }
Subword >> updatePairWith: aSubWord in: aBPE [
"Mises à jour d'une paire dans pairs et pairPositions de BPE en déléguant l’opération
à anObject, si celui-ci n'est pas nil."

	aBPE updatePairFrom: self and: aSubWord 
	
]

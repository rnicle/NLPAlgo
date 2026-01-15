Class {
	#name : 'EndOfWord',
	#superclass : 'Object',
	#classVars : [
		'UniqueInstance'
	],
	#category : 'BPE4',
	#package : 'BPE4'
}

{ #category : 'instance creation' }
EndOfWord class >> uniqueInstance [
	^UniqueInstance ifNil: [ UniqueInstance := self new ].
]

{ #category : 'operations' }
EndOfWord >> addPairAffectedByMergeWith: aSubword in: aBPE [ 
	
	^ self
]

{ #category : 'operations' }
EndOfWord >> addPairWith: anObject in: aBPE [
	^ self 
	
]

{ #category : 'operations' }
EndOfWord >> addPairsScoreWith: aSubword in: aBPE [
	^ self
]

{ #category : 'operations' }
EndOfWord >> tryAddPairAffectedByMergeWith: anObject in: aBPE [
	
	^ self
]

{ #category : 'operations' }
EndOfWord >> tryAddPairWith: anObject in: aBPE [
	^ self 
]

{ #category : 'operations' }
EndOfWord >> tryAddPairsScoreWith: anObject in: aBPE [
	^ self 
]

{ #category : 'operations' }
EndOfWord >> tryUpdatePairWith: anObject in: aBPE [
	^ self 
]

{ #category : 'operations' }
EndOfWord >> updatePairWith: aSubword in: aBPE [

	^ self 
]

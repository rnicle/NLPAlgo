Class {
	#name : 'TestBPEEncoderNaive',
	#superclass : 'TestCase',
	#category : 'BPE4',
	#package : 'BPE4'
}

{ #category : 'tests' }
TestBPEEncoderNaive >> testAddEndTokentoEachWordsInText [

	|enc|
	enc := BPEEncoderNaive new .
	self assert: (enc addEndTokentoEachWordsInText: self text)  equals: 'old</t> old</t> old</t> old</t> old</t> old</t> old</t> 
older</t> older</t> older</t>
finest</t> finest</t> finest</t> finest</t> finest</t> finest</t> finest</t> finest</t> finest</t> 
lowest</t> lowest</t> lowest</t> lowest</t> 
'
	
]

{ #category : 'tests' }
TestBPEEncoderNaive >> testAddNewPairsFrom [ 

	|enc subword1 subword2| 
	enc := BPEEncoderNaive new .
	subword1 := Subword new subword: 'a' .
	subword2 := Subword new subword: 'b' .
	
	self assert: enc pairPositions size equals: 0 .
	
	enc addNewPairFrom: subword1 and: subword2 .
	
	self assert: enc pairPositions size equals: 1 .
	
	self assert: ( enc pairPositions includesKey: { 'a' . 'b' } ) equals: true .
	
]

{ #category : 'tests' }
TestBPEEncoderNaive >> testApplyRules [ 
	
	|enc tokens|
	enc := BPEEncoderNaive new .
	tokens := OrderedCollection new .
	
	'old old old old old old old 
older older older
finest finest finest finest finest finest finest finest finest 
lowest lowest lowest lowest 
'.

	
	self assert: ( enc applyRulesTo: self text from: 'C:\Users\Nicole\Documents\Pharo\merges1.json' ) equals: { 'o' . 'l' . 'd' . '</t>' . Character space asString . 'o' . 'l' . 'd' . '</t>' . Character space asString . 'o' . 'l' . 'd' . '</t>' . Character space asString . 'o' . 'l' . 'd' . '</t>' . Character space asString . 'o' . 'l' . 'd' . '</t>' . Character space asString . 'o' . 'l' . 'd' . '</t>' . Character space asString . 'o' . 'l' . 'd' . '</t>' . Character space asString . Character cr asString . 'o' . 'l' . 'd' . 'e' . 'r' . '</t>' . Character space asString . 'o' . 'l' . 'd' . 'e' . 'r' . '</t>' . Character space asString . 'o' . 'l' . 'd' . 'e' . 'r' . '</t>' . Character cr asString . 'f' . 'i' . 'n' . 'est</t>' . Character space asString . 'f' . 'i' . 'n' . 'est</t>' . Character space asString . 'f' . 'i' . 'n' . 'est</t>' . Character space asString . 'f' . 'i' . 'n' . 'est</t>' . Character space asString . 'f' . 'i' . 'n' . 'est</t>' . Character space asString . 'f' . 'i' . 'n' . 'est</t>' . Character space asString . 'f' . 'i' . 'n' . 'est</t>' . Character space asString . 'f' . 'i' . 'n' . 'est</t>' . Character space asString . 'f' . 'i' . 'n' . 'est</t>' . Character space asString . Character cr asString . 'low' . 'est</t>' . Character space asString . 'low' . 'est</t>' . Character space asString . 'low' . 'est</t>' . Character space asString . 'low' . 'est</t>' . Character space asString . Character cr asString } asOrderedCollection .
]

{ #category : 'tests' }
TestBPEEncoderNaive >> testComputePairs [ 
	|encoder |
	encoder := BPEEncoderNaive new.
	encoder words: self text .
	encoder computePairs .
	
	self assert: encoder pairPositions keys asSet equals: { {'o' . 'l'} . {'l' . 'd'} . {'d' . '</t>'} . { Character space asString . 'o'} . { Character space asString . Character cr asString } . { Character cr asString  . 'o' } . { 'd'  . 'e' } . { 'e'  . 'r' } . { 'r'  . '</t>' } . { Character cr asString  . 'f' } . { 'f'  . 'i' } . { 'i'  . 'n' } . { 'n'  . 'e' } . { 'e'  . 's' } . { 's'  . 't' } . { 't'  . '</t>' } . { Character space asString . 'f' } . { Character cr asString  . 'l' } . { 'l'  . 'o' } . { 'o'  . 'w' } . { 'w'  . 'e' } . { Character space asString . 'l' } } asSet 
]

{ #category : 'tests' }
TestBPEEncoderNaive >> testUpdatePairFrom [ 

	|enc subword1 subword2| 
	enc := BPEEncoderNaive new .
	subword1 := Subword new subword: 'a' .
	subword2 := Subword new subword: 'b' .
	
	enc addNewPairFrom: subword1 and: subword2 .
	
	self assert: enc pairPositions size equals: 1 .
	
	self assert: ( enc pairPositions includesKey: { 'a' . 'b' } ) equals: true .
	
	enc updatePairFrom: subword1 and: subword2 .
	
	self assert: enc pairPositions size equals: 0 .
	
	self assert: ( enc pairPositions includesKey: { 'a' . 'b' } ) equals: false .
	
]

{ #category : 'tests' }
TestBPEEncoderNaive >> testWords [

	|enc list i|
	enc := BPEEncoderNaive new .
	list := {'o' . 'l' . 'd' . '</t>' . Character space asString . 'o' . 'l' . 'd' . '</t>' . Character space asString . 'o' . 'l' . 'd' . '</t>' . Character space asString . 'o' . 'l' . 'd' . '</t>' . Character space asString . 'o' . 'l' . 'd' . '</t>' . Character space asString . 'o' . 'l' . 'd' . '</t>' . Character space asString . 'o' . 'l' . 'd' . '</t>' . Character space asString . Character cr asString . 'o' . 'l' . 'd' . 'e' . 'r' . '</t>' . Character space asString . 'o' . 'l' . 'd' . 'e' . 'r' . '</t>' . Character space asString . 'o' . 'l' . 'd' . 'e' . 'r' . '</t>' . Character cr asString . 'f' . 'i' . 'n' . 'e' . 's' . 't' . '</t>' . Character space asString . 'f' . 'i' . 'n' . 'e' . 's' . 't' . '</t>' . Character space asString . 'f' . 'i' . 'n' . 'e' . 's' . 't' . '</t>' . Character space asString . 'f' . 'i' . 'n' . 'e' . 's' . 't' . '</t>' . Character space asString . 'f' . 'i' . 'n' . 'e' . 's' . 't' . '</t>' . Character space asString . 'f' . 'i' . 'n' . 'e' . 's' . 't' . '</t>' . Character space asString . 'f' . 'i' . 'n' . 'e' . 's' . 't' . '</t>' . Character space asString . 'f' . 'i' . 'n' . 'e' . 's' . 't' . '</t>' . Character space asString . 'f' . 'i' . 'n' . 'e' . 's' . 't' . '</t>' . Character space asString . Character cr asString . 'l' . 'o' . 'w' . 'e' . 's' . 't' . '</t>' . Character space asString . 'l' . 'o' . 'w' . 'e' . 's' . 't' . '</t>' . Character space asString . 'l' . 'o' . 'w' . 'e' . 's' . 't' . '</t>' . Character space asString . 'l' . 'o' . 'w' . 'e' . 's' . 't' . '</t>' . Character space asString . Character cr asString } .
	enc words: self text .
	i := 1 .
	enc words linksDo: [ :link |
		( link isNotNil and: [ link value class ~= EndOfWord ] ) 
			ifTrue: [ self assert: link value subword equals: ( list at: i ) . 
						i := i + 1 ]  
					]
	
]

{ #category : 'tests' }
TestBPEEncoderNaive >> testloadMergesSSTON [ 

	|enc rules|
	enc := BPEEncoderNaive new .
	enc loadMergesSTON: 'C:\Users\Nicole\Documents\Pharo\merges1.json' .
	rules := OrderedCollection new .
	rules add: ( Association key: #('t' '</t>') value: 't</t>' ) .
	rules add: ( Association key: #('e' 's') value: 'es' ) .
	rules add: ( Association key: #('es' 't</t>') value: 'est</t>' ) .
	rules add: ( Association key: #('l' 'o') value: 'lo' ) .
	rules add: ( Association key: #('lo' 'w') value: 'low' ) .
	rules add: ( Association key: #('e' 'w') value: 'ew' ) .
	rules add: ( Association key: #('ew' 'est</t>') value: 'ewest</t>' ) .
	rules add: ( Association key: #('n' 'ewest</t>') value: 'newest</t>' ) .
	rules add: ( Association key: #('low' '</t>') value: 'low</t>' ) .
	rules add: ( Association key: #('i' 'd') value: 'id' ) .
	rules add: ( Association key: #('id' 'est</t>') value: 'idest</t>' ) .
	rules add: ( Association key: #('w' 'idest</t>') value: 'widest</t>' ) .
	rules add: ( Association key: #('low' 'e') value: 'lowe' ) .
	rules add: ( Association key: #('lowe' 'r') value: 'lower' ) .
	rules add: ( Association key: #('lower' '</t>') value: 'lower</t>' ) .
	
	self assert: enc rules equals: rules .
	
]

{ #category : 'accessing structure variables' }
TestBPEEncoderNaive >> text [
	^ 'old old old old old old old 
older older older
finest finest finest finest finest finest finest finest finest 
lowest lowest lowest lowest 
'

]

{ #category : 'accessing structure variables' }
TestBPEEncoderNaive >> text2 [
	^ '
low low low low low
lower lower
newest newest newest newest newest newest 
widest widest widest'
]

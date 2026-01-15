Class {
	#name : 'TestBPELearner',
	#superclass : 'TestCase',
	#category : 'BPE4',
	#package : 'BPE4'
}

{ #category : 'ressources' }
TestBPELearner >> rawCorpus [ 
	^ {'old' . 'old' . 'old' . 'old' . 'old' . 'old' . 'old' . 'older' . 'older' . 'older' . 'finest' . 'finest' . 'finest' . 'finest' . 'finest' . 'finest' . 'finest' . 'finest' . 'finest' . 'lowest' . 'lowest' . 'lowest' . 'lowest'}
]

{ #category : 'tests' }
TestBPELearner >> testAddNewPairFrom [ 
	|bpe subword subword1 subword2 subword3|
	bpe:= BPELearner new.
	
	subword := Subword new subword: 'a'; occurence: 5; position: 1.
	subword1 := Subword new subword: 'b'; occurence: 5; position: 2.
	bpe addNewPairFrom: subword and: subword1 .
	
	self assert: bpe pairs size  equals: 5.
	self assert: (bpe pairs occurrencesOf: #(#a #b))  equals: 5. 
	self assert: (bpe pairPositions at:#(#a #b) ) size equals: 1.
	
	subword2 := Subword new subword: 'c'; occurence: 1; position: 0.
	subword3 := Subword new subword: 'd'; occurence: 2; position: 3.
	bpe addNewPairFrom: subword2 and: subword3 .
	
	self assert: bpe pairs size  equals: 6.
	self assert: (bpe pairs occurrencesOf: #(#c #d))  equals: 1.
	self assert: (bpe pairPositions at:#(#c #d) ) size equals: 1.
	
	subword := Subword new subword: 'a'; occurence: 5; position: 1.
	subword1 := Subword new subword: 'b'; occurence: 5; position: 2.
	bpe addNewPairFrom: subword and: subword1 .
	
	self assert: bpe pairs size  equals: 11.
	self assert: (bpe pairs occurrencesOf: #(#a #b))  equals: 10.
	self assert: (bpe pairPositions at:#(#a #b) ) size equals: 1.
	
	subword := Subword new subword: 'a'; occurence: 3; position: 4.
	subword1 := Subword new subword: 'b'; occurence: 3; position: 5.
	bpe addNewPairFrom: subword and: subword1 .
	
	self assert: bpe pairs size  equals: 14.
	self assert: (bpe pairs occurrencesOf: #(#a #b))  equals: 13.
	self assert: (bpe pairPositions at:#(#a #b) ) size equals: 2.
	
	
	
	
]

{ #category : 'tests' }
TestBPELearner >> testBuildVocabularyProducesCorrectVocabulary [

	| enc |
	enc := BPELearner new. 
	enc fromText: self text.
	self 
		assertCollection: enc vocabulary asSet
		hasSameElements: { '</t>' . 'd' . 'e' . 'i' . 'l' . 'f' . 'n' . 'o' . 'r' . 's' . 't' . 'w'} asSet
]

{ #category : 'tests' }
TestBPELearner >> testBuildVocabularyProducesCorrectVocabularyFromArray [

	| enc |
	enc := BPELearner new. 
	enc fromText: self rawCorpus .
	self 
		assertCollection: enc vocabulary asSet
		hasSameElements: { '</t>' . 'd' . 'e' . 'i' . 'l' . 'f' . 'n' . 'o' . 'r' . 's' . 't' . 'w'} asSet
]

{ #category : 'tests' }
TestBPELearner >> testBuildVocabularyProducesCorrectVocabularyText2 [

	| enc |
	enc := BPELearner new. 
	enc fromText: self text2.
	enc computeVocabulary.
	self assertCollection: enc vocabulary asSet hasSameElements: { '</t>' . 'd' . 'e' . 'i' . 'l' . 'n' . 'o' . 'r' . 's' . 't' . 'w'} asSet
]

{ #category : 'tests' }
TestBPELearner >> testComputePairs [

	| enc |
	enc := BPELearner new. 
	enc fromText: self text.
	
	self assert: (enc pairs occurrencesOf: {'o' . 'l'}) equals: 10. 
	self assert: (enc pairs occurrencesOf: {'l' . 'd'}) equals: 10. 
	self assert: (enc pairs occurrencesOf: {'l' .'d'}) equals: 10. 
	self assert: (enc pairs occurrencesOf: {'s' .'t'}) equals: 13. 
	self assert: (enc pairs occurrencesOf: {'e' . 's'}) equals: 13. 
	self assert: (enc pairs occurrencesOf: {'l' .'o'}) equals: 4. 
	self assert: (enc pairs occurrencesOf: {'t' . '</t>'}) equals: 13. 
	
	self assert: enc pairs size equals: 114.
	self assert: enc pairs keys size equals: 15
]

{ #category : 'tests' }
TestBPELearner >> testComputePairsArray [

	| enc |
	enc := BPELearner new. 
	enc fromText: self rawCorpus .
	
	self assert: (enc pairs occurrencesOf: {'o' . 'l'}) equals: 10. 
	self assert: (enc pairs occurrencesOf: {'l' . 'd'}) equals: 10. 
	self assert: (enc pairs occurrencesOf: {'l' .'d'}) equals: 10. 
	self assert: (enc pairs occurrencesOf: {'s' .'t'}) equals: 13. 
	self assert: (enc pairs occurrencesOf: {'e' . 's'}) equals: 13. 
	self assert: (enc pairs occurrencesOf: {'l' .'o'}) equals: 4. 
	self assert: (enc pairs occurrencesOf: {'t' . '</t>'}) equals: 13. 
	
	self assert: enc pairs keys size equals: 15
]

{ #category : 'tests' }
TestBPELearner >> testComputePairsText2 [

	| enc |
	enc := BPELearner new. 
	enc fromText: self text2.
	
	self assert: (enc pairs occurrencesOf: {'e' .'s'}) equals: 9. 
	self assert: (enc pairs occurrencesOf: {'i'. 'd'}) equals: 3. 
	self assert: (enc pairs occurrencesOf: {'o' .'w'}) equals: 7. 
	self assert: (enc pairs occurrencesOf: {'s'. 't'}) equals: 9. 
	self assert: (enc pairs occurrencesOf: {'w'. 'e'}) equals: 8. 
	self assert: (enc pairs occurrencesOf: {'w'. 'i'}) equals: 3. 
	self assert: (enc pairs occurrencesOf: {'t'.'</t>'}) equals: 9. 

	 "#('lo' 't_' 'er' 'r_' 'st' 'wi' 'es' 'ne' 'ow' 'we' 'w_' 'id' 'de' 'ew')"
	self assert: enc pairs keys size equals: 14
]

{ #category : 'tests' }
TestBPELearner >> testFusion [ 
	|position pair bpe|
	bpe := BPELearner new.
	bpe fromText: self text.
	
	pair:= #('e' 's').
	position := (bpe pairPositions at: pair) asArray .
	
	self assert: position size equals: 2.
	
	self assert: (position at: 1) first value subword equals: 'e'.
	self assert: (position at: 1) second value subword equals: 's'.
	self assert: (position at: 2) first value subword equals: 'e'.
	self assert: (position at: 2) second value subword equals: 's'.
	
	position do: [ :each | bpe fusion: each ].
	
	self assert: (position at: 1) first value subword equals: 'es'.
	self assert: (position at: 2) first value subword equals: 'es'.
	
]

{ #category : 'tests' }
TestBPELearner >> testMergeOneStepAddMergeToMergeList [

	| enc |
	enc := BPELearner new. 
	enc fromText: self text.
	enc computeVocabulary.
	
	self assert: enc merges isEmpty.
	enc mergesOneStep .
	self assert: enc merges first equals: #('t' '</t>')->'t</t>'
]

{ #category : 'tests' }
TestBPELearner >> testMergeOneStepIncreaseVocabularyAndMerges [

	| enc mergeOldSize |
	enc := BPELearner new. 
	enc fromText: self text.
	
	self assert: enc vocabulary size equals: 12.
	mergeOldSize := enc merges size.
	enc mergesOneStep .
	self assert: (enc vocabulary includes: 't</t>').
	self assert: enc merges size equals: mergeOldSize + 1.
	self assert: enc vocabulary size equals: 13
]

{ #category : 'tests' }
TestBPELearner >> testMergeOneStepRecomputePairs [

	| enc|
	enc := BPELearner new. 
	enc fromText: self text.
	
	enc mergesOneStep .
	
	self assert: (enc pairs occurrencesOf: {'o' . 'l'}) equals: 10. 
	self assert: (enc pairs occurrencesOf: {'l' . 'd'}) equals: 10. 
	self assert: (enc pairs occurrencesOf: {'l' .'d'}) equals: 10. 
	self assert: (enc pairs occurrencesOf: {'s' . 't</t>'}) equals: 13. 
	self assert: (enc pairs occurrencesOf: {'l' .'o'}) equals: 4. 
	self assert: (enc pairs occurrencesOf: {'e' . 's'}) equals: 13. 
	self assert: (enc pairs occurrencesOf: {'w' . 'e'}) equals: 4. 
	self assert: (enc pairs occurrencesOf: {'n' . 'e'}) equals: 9. 
]

{ #category : 'test - tokenisation' }
TestBPELearner >> testPrepareFrom [

	| bpeLearner b |
	bpeLearner := BPELearner new.
	b := bpeLearner pretokenize: self rawCorpus.
	self assert: b class equals: Bag.
	self flag: #betterTest
]

{ #category : 'test - tokenisation' }
TestBPELearner >> testPrepareFromText [

	| bpeLearner b |
	bpeLearner := BPELearner new.
	b := bpeLearner pretokenizeText: self text.
	self assert: b class equals: Bag.
	self flag: #betterTest
]

{ #category : 'tests' }
TestBPELearner >> testSplitWord [
	|word bpe	|
	word := 'older'.
	bpe := BPELearner new.
	self assert: (bpe splitWord: word)  equals: { 'o' . 'l' . 'd' . 'e' . 'r' . '</t>'} asOrderedCollection .
]

{ #category : 'tests' }
TestBPELearner >> testThreeMergeOneStepIncreaseVocabularyAndMerges [

	| enc mergeOldSize |
	enc := BPELearner new. 
	enc fromText: self text.
	
	self assert: enc vocabulary size equals: 12.
	mergeOldSize := enc merges size.
	enc mergesOneStep .
	enc mergesOneStep .
	enc mergesOneStep.
	self assert: (enc vocabulary includes: 't</t>').
	self assert: (enc vocabulary includes: 'es').
	self assert: (enc vocabulary includes: 'est</t>').
	self assert: enc merges size equals: mergeOldSize + 3.
	self assert: enc vocabulary size equals: 15.
]

{ #category : 'tests' }
TestBPELearner >> testThreeMergeOneStepRecomputePairs [

	| enc|
	enc := BPELearner new. 
	enc fromText: self text.
	
	enc mergesOneStep .
	enc mergesOneStep .
	enc mergesOneStep .
	
	self assert: (enc pairs occurrencesOf: {'o' . 'l'}) equals: 10. 
	self assert: (enc pairs occurrencesOf: {'l' . 'd'}) equals: 10. 
	self assert: (enc pairs occurrencesOf: {'l' .'d'}) equals: 10. 
	self assert: (enc pairs occurrencesOf: {'es' . 't</t>'}) equals: 0. 
	self assert: (enc pairs occurrencesOf: {'l' .'o'}) equals: 4. 
	self assert: (enc pairs occurrencesOf: {'w' . 'est</t>'}) equals: 4. 
	self assert: (enc pairs occurrencesOf: {'f' . 'i'}) equals: 9.
	self assert: (enc pairs occurrencesOf: {'i' . 'n'}) equals: 9.
	self assert: (enc pairs occurrencesOf: {'n' . 'est</t>'}) equals: 9.
]

{ #category : 'tests' }
TestBPELearner >> testTwoMergeOneStepIncreaseVocabularyAndMerges [

	| enc mergeOldSize |
	enc := BPELearner new. 
	enc fromText: self text.
	
	self assert: enc vocabulary size equals: 12.
	mergeOldSize := enc merges size.
	enc mergesOneStep .
	enc mergesOneStep .
	self assert: (enc vocabulary includes: 't</t>').
	self assert: (enc vocabulary includes: 'es').
	self assert: enc merges size equals: mergeOldSize + 2.
	self assert: enc vocabulary size equals: 14.
]

{ #category : 'tests' }
TestBPELearner >> testTwoMergeOneStepRecomputePairs [

	| enc|
	enc := BPELearner new. 
	enc fromText: self text.
	
	enc mergesOneStep .
	enc mergesOneStep .
	
	self assert: (enc pairs occurrencesOf: {'o' . 'l'}) equals: 10. 
	self assert: (enc pairs occurrencesOf: {'l' . 'd'}) equals: 10. 
	self assert: (enc pairs occurrencesOf: {'l' .'d'}) equals: 10. 
	self assert: (enc pairs occurrencesOf: {'es' . 't</t>'}) equals: 13. 
	self assert: (enc pairs occurrencesOf: {'l' .'o'}) equals: 4. 
	self assert: (enc pairs occurrencesOf: {'w' . 'es'}) equals: 4. 
	self assert: (enc pairs occurrencesOf: {'n' . 'es'}) equals: 9. 
]

{ #category : 'tests' }
TestBPELearner >> testTwoMerges [

	| enc |
	enc := BPELearner new. 
	enc fromText: self text.
	enc computeVocabulary.
	enc mergesOneStep .
	enc mergesOneStep .
	
	self assert: enc merges first equals: #('t' '</t>')->'t</t>'. 
	self assert: enc merges second equals: #('e' 's')->'es'. 
]

{ #category : 'tests' }
TestBPELearner >> testUpdate [ 
	|position pair bpe|
	bpe := BPELearner new.
	bpe fromText: self text.
	
	pair:= #('l' 'd').
	position := (bpe pairPositions at: pair) .
	
	self assert: position size equals: 2.
	self assert: (bpe pairs occurrencesOf: pair) equals: 10.
	self assert: (bpe pairs occurrencesOf: #('o' 'l')) equals: 10. 
	self assert: (bpe pairs occurrencesOf: #('d' '</t>')) equals: 7.
	self assert: (bpe pairs occurrencesOf: #('d' 'e')) equals: 3. 
	self assert: (bpe pairPositions includesKey: pair) equals: true.
	self assert: (bpe pairPositions includesKey: #('o' 'l')) equals: true. 
	self assert: (bpe pairPositions includesKey: #('d' '</t>')) equals: true.
	self assert: (bpe pairPositions includesKey: #('d' 'e')) equals: true. 
	
	bpe update: pair .
	
	self assert: (bpe pairs occurrencesOf: pair) equals: 0.
	self assert: (bpe pairs occurrencesOf: #('o' 'l')) equals: 0. 
	self assert: (bpe pairs occurrencesOf: #('d' '</t>')) equals: 0.
	self assert: (bpe pairs occurrencesOf: #('d' 'e')) equals: 0. 
	self assert: (bpe pairPositions includesKey: pair) equals: false.
	self assert: (bpe pairPositions includesKey: #('o' 'l')) equals: false. 
	self assert: (bpe pairPositions includesKey: #('d' '</t>')) equals: false.
	self assert: (bpe pairPositions includesKey: #('d' 'e')) equals: false. 
	
	self assert: (bpe pairs occurrencesOf: #('o' 'ld')) equals: 10. 
	self assert: (bpe pairs occurrencesOf: #('ld' '</t>')) equals: 7.
	self assert: (bpe pairs occurrencesOf: #('ld' 'e')) equals: 3.
	self assert: (bpe pairPositions includesKey: #('o' 'ld')) equals: true. 
	self assert: (bpe pairPositions includesKey: #('ld' '</t>')) equals: true.
	self assert: (bpe pairPositions includesKey: #('ld' 'e')) equals: true.
	 

]

{ #category : 'tests' }
TestBPELearner >> testUpdatePairFrom [ 
	|bpe subword subword1|
	bpe:= BPELearner new.
	
	subword := Subword new subword: 'a'; occurence: 5; position: 1.
	subword1 := Subword new subword: 'b'; occurence: 5; position: 2.
	bpe addNewPairFrom: subword and: subword1 .
	
	subword := Subword new subword: 'a'; occurence: 3; position: 3.
	subword1 := Subword new subword: 'b'; occurence: 3; position: 4.
	bpe addNewPairFrom: subword and: subword1 .
	
	self assert: bpe pairs size  equals: 8.
	self assert: (bpe pairs occurrencesOf: #(#a #b))  equals: 8. 
	self assert: (bpe pairPositions at:#(#a #b) ) equals: #(#(1 2) #(3 4))asSet .
	
	subword := Subword new subword: 'a'; occurence: 5; position: 1.
	subword1 := Subword new subword: 'b'; occurence: 5; position: 2.
	bpe updatePairFrom: subword and: subword1 .
	
	self assert: bpe pairs size  equals: 3.
	self assert: (bpe pairs occurrencesOf: #(#a #b))  equals: 3. 
	self assert: (bpe pairPositions at:#(#a #b) ) equals: #(#(3 4))asSet .
	
	
	
	
	
	
]

{ #category : 'ressources' }
TestBPELearner >> text [
	^ 'old old old old old old old 
older older older
finest finest finest finest finest finest finest finest finest 
lowest lowest lowest lowest 
'
]

{ #category : 'ressources' }
TestBPELearner >> text2 [
	^ '
low low low low low
lower lower
newest newest newest newest newest newest 
widest widest widest'
]

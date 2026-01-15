Class {
	#name : 'TestWordPieceLearner',
	#superclass : 'TestCase',
	#category : 'BPE4',
	#package : 'BPE4'
}

{ #category : 'tests' }
TestWordPieceLearner >> testAddNewPairsScoresFrom [ 
	|wordpiece subword subword1 |
	wordpiece := WordPieceLearner new.
	
	self assert: wordpiece pairs size equals: 0.
	self assert: wordpiece pairPositions size equals: 0.
	self assert: wordpiece pairsScores size equals: 0.
	
	subword := Subword new subword: 'l'; occurence: 2; position: 1.
	subword1 := Subword new subword: 'd'; occurence: 3; position: 4.
	wordpiece addNewPairFrom: subword and: subword1 .
	wordpiece addToLettersAndLettersPositions: subword .
	wordpiece addToLettersAndLettersPositions: subword1 .
	
	self assert: (wordpiece pairs occurrencesOf: #('l' 'd')) equals: 2.
	self assert: (wordpiece pairPositions at: #('l' 'd')) equals: #(#(1 4))asSet .
	self assert: (wordpiece pairsScores size) equals: 0.
	self assert: (wordpiece letters occurrencesOf: 'l') equals: 2.
	self assert: (wordpiece letters occurrencesOf: 'd') equals: 3.
	self assert: (wordpiece lettersPositions at: 'l') equals: #(1)asSet.
	self assert: (wordpiece lettersPositions at: 'd') equals: #(4)asSet.
	
	wordpiece addNewPairsScoresFrom: subword and: subword1 .
	
	self assert: (wordpiece pairsScores at: #('l' 'd')) equals: 2/(2*3)asFloat.
	

]

{ #category : 'tests' }
TestWordPieceLearner >> testAddToLettersAndLettersPosition [ 
	|wordpiece subword|
	wordpiece := WordPieceLearner new.
	
	self assert: wordpiece letters size equals: 0.
	self assert: wordpiece lettersPositions size equals: 0.
	
	subword := Subword new subword: 'l'; occurence: 1; position: 0.
	wordpiece addToLettersAndLettersPositions: subword .
	
	self assert: (wordpiece letters occurrencesOf: 'l') equals: 1.
	self assert: (wordpiece lettersPositions at: 'l') equals: #(0) asSet.
	
	subword := Subword new subword: 'l'; occurence: 2; position: 3.
	wordpiece addToLettersAndLettersPositions: subword .
	
	self assert: (wordpiece letters occurrencesOf: 'l') equals: 3.
	self assert: (wordpiece lettersPositions at: 'l') equals: #(0 3) asSet.
]

{ #category : 'tests' }
TestWordPieceLearner >> testComputePairs [ 
	|wordpiece|
	wordpiece := WordPieceLearner new.
	wordpiece words: self text2 .
	wordpiece computeVocabulary .
	wordpiece computePairs .
	
	self assert: (wordpiece pairPositions keys size = wordpiece pairs keys size) equals: true.
	self assert: (wordpiece pairsScores keys size = wordpiece pairs keys size) equals: true.
	self assert: (wordpiece pairPositions keys asSet = wordpiece pairs keys asSet ) equals: true.
	self assert: (wordpiece pairsScores keys asSet = wordpiece pairs keys asSet ) equals: true.
	
	self assert: wordpiece pairPositions keys asSet equals: #(#('l' '#o') #('#o' '#w') #('#w' '#e') #('#e' '#r') #('n' '#e') #('#e' '#w') #('#e' '#s') #('#s' '#t') 
	#('w' '#i') #('#i' '#d') #('#d' '#e') ) asSet.
	
	self assert: (wordpiece pairs occurrencesOf: #('l' '#o')) equals: 7.
	self assert: (wordpiece pairs occurrencesOf: #('#o' '#w')) equals: 7.
	self assert: (wordpiece pairs occurrencesOf: #('#w' '#e')) equals: 8.
	self assert: (wordpiece pairs occurrencesOf: #('#e' '#r')) equals: 2.
	self assert: (wordpiece pairs occurrencesOf: #('n' '#e')) equals: 6.
	self assert: (wordpiece pairs occurrencesOf: #('#e' '#w')) equals: 6.
	self assert: (wordpiece pairs occurrencesOf: #('#e' '#s')) equals: 9.
	self assert: (wordpiece pairs occurrencesOf: #('#s' '#t')) equals: 9.
	self assert: (wordpiece pairs occurrencesOf: #('w' '#i')) equals: 3.
	self assert: (wordpiece pairs occurrencesOf: #('#i' '#d')) equals: 3.
	self assert: (wordpiece pairs occurrencesOf: #('#d' '#e')) equals: 3.
	
	self assert: (wordpiece pairsScores at: #('l' '#o')) equals: 7/(7*7)asFloat .
	self assert: (wordpiece pairsScores at: #('#o' '#w')) equals: 7/(7*13)asFloat .
	self assert: (wordpiece pairsScores at: #('#w' '#e')) equals: 8/(13*17)asFloat .
	self assert: (wordpiece pairsScores at: #('#e' '#r')) equals: 2/(17*2)asFloat .
	self assert: (wordpiece pairsScores at: #('n' '#e')) equals: 6/(6*17)asFloat .
	self assert: (wordpiece pairsScores at: #('#e' '#w')) equals: 6/(17*13)asFloat .
	self assert: (wordpiece pairsScores at: #('#e' '#s')) equals: 9/(17*9)asFloat .
	self assert: (wordpiece pairsScores at: #('#s' '#t')) equals: 9/(9*9)asFloat .
	self assert: (wordpiece pairsScores at: #('w' '#i')) equals: 3/(3*3)asFloat .
	self assert: (wordpiece pairsScores at: #('#i' '#d')) equals: 3/(3*3)asFloat .
	self assert: (wordpiece pairsScores at: #('#d' '#e')) equals: 3/(3*17)asFloat .
]

{ #category : 'tests' }
TestWordPieceLearner >> testComputeVocabulary [ 
	|wordpiece|
	wordpiece := WordPieceLearner new.
	wordpiece words: self text2 .
	wordpiece computeVocabulary .
	
	self assert: (wordpiece vocabulary size = wordpiece letters keys size) equals: true.
	self assert: (wordpiece vocabulary size = wordpiece lettersPositions keys size) equals: true.
	self assert: (wordpiece vocabulary = wordpiece letters keys asSet) equals: true.
	self assert: (wordpiece vocabulary = wordpiece lettersPositions keys asSet) equals: true.
	
	self assert: wordpiece vocabulary equals: #('l' '#o' '#w' '#e' '#r' 'n' '#s' '#t' 'w' '#i' '#d') asSet.
	
	self assert: (wordpiece letters occurrencesOf: 'l') equals: 7.
	self assert: (wordpiece letters occurrencesOf: '#o') equals: 7.
	self assert: (wordpiece letters occurrencesOf: '#w') equals: 13.
	self assert: (wordpiece letters occurrencesOf: 'w') equals: 3.
	self assert: (wordpiece letters occurrencesOf: '#e') equals: 17.
	self assert: (wordpiece letters occurrencesOf: '#r') equals: 2.
	self assert: (wordpiece letters occurrencesOf: 'n') equals: 6.
	self assert: (wordpiece letters occurrencesOf: '#s') equals: 9.
	self assert: (wordpiece letters occurrencesOf: '#t') equals: 9.
	self assert: (wordpiece letters occurrencesOf: 'w') equals: 3.
	self assert: (wordpiece letters occurrencesOf: '#i') equals: 3.
	self assert: (wordpiece letters occurrencesOf: '#d') equals: 3.
]

{ #category : 'tests' }
TestWordPieceLearner >> testCreateNewVocabulary [
	|wordpiece|
	wordpiece := WordPieceLearner new.
	wordpiece words: self text2 .
	wordpiece computeVocabulary .
	wordpiece computePairs .
	
	self assert: (wordpiece findPairToMerge ) equals: { '#i' . '#d' }.
	self assert: (wordpiece createNewVocabulary: wordpiece findPairToMerge ) equals: '#id'
]

{ #category : 'tests' }
TestWordPieceLearner >> testFindPairToMerge [
	|wordpiece|
	wordpiece := WordPieceLearner new.
	wordpiece words: self text2 .
	wordpiece computeVocabulary .
	wordpiece computePairs .
	
	self assert: (wordpiece findPairToMerge ) equals: { '#i' . '#d' }
	
]

{ #category : 'tests' }
TestWordPieceLearner >> testFusion [ 
	|position pair bpe|
	bpe := WordPieceLearner new.
	bpe fromText: self text2 .
	
	pair:= #('#w' '#e').
	position := (bpe pairPositions at: pair) asArray .
	
	self assert: position size equals: 2.
	
	self assert: (position at: 1) first value subword equals: '#w'.
	self assert: (position at: 1) second value subword equals: '#e'.
	self assert: (position at: 2) first value subword equals: '#w'.
	self assert: (position at: 2) second value subword equals: '#e'.
	
	position do: [ :each | bpe fusion: each ].
	
	self assert: (position at: 1) first value subword equals: '#we'.
	self assert: (position at: 2) first value subword equals: '#we'.
]

{ #category : 'tests' }
TestWordPieceLearner >> testMergeOneStepIncreaseVocabulary [

	| wordpiece |
	wordpiece := WordPieceLearner new. 
	wordpiece fromText: self text2.
	
	self assert: wordpiece vocabulary size equals: 11.

	wordpiece mergesOneStep .
	
	self assert: (wordpiece vocabulary includes: '#id') equals: true.
	self assert: wordpiece vocabulary size equals: 12.
	
	self assert: (wordpiece vocabulary size ~= wordpiece letters keys size) equals: true.
	self assert: (wordpiece letters keys asSet size = wordpiece lettersPositions keys size) equals: true.
	self assert: (wordpiece vocabulary ~= wordpiece letters keys asSet) equals: true.
	self assert: (wordpiece letters keys asSet = wordpiece lettersPositions keys asSet) equals: true.
	
	self assert: wordpiece vocabulary equals: #('l' '#o' '#w' '#e' '#r' 'n' '#s' '#t' 'w' '#i' '#d' '#id') asSet.
	
	self assert: (wordpiece letters includes: '#i') equals: false .
	self assert: (wordpiece letters includes: '#d') equals: false .
	
	self assert: (wordpiece letters occurrencesOf: 'l') equals: 7.
	self assert: (wordpiece letters occurrencesOf: '#o') equals: 7.
	self assert: (wordpiece letters occurrencesOf: '#w') equals: 13.
	self assert: (wordpiece letters occurrencesOf: '#e') equals: 17.
	self assert: (wordpiece letters occurrencesOf: '#r') equals: 2.
	self assert: (wordpiece letters occurrencesOf: 'n') equals: 6.
	self assert: (wordpiece letters occurrencesOf: '#s') equals: 9.
	self assert: (wordpiece letters occurrencesOf: '#t') equals: 9.
	self assert: (wordpiece letters occurrencesOf: 'w') equals: 3.
	self assert: (wordpiece letters occurrencesOf: '#id') equals: 3.
]

{ #category : 'tests' }
TestWordPieceLearner >> testMergeOneStepRecomputePairs [

	|wordpiece|
	wordpiece := WordPieceLearner new.
	wordpiece words: self text2 .
	wordpiece computeVocabulary .
	wordpiece computePairs .
	wordpiece mergesOneStep .
	
	self assert: (wordpiece pairPositions keys size = wordpiece pairs keys size) equals: true.
	self assert: (wordpiece pairsScores keys size = wordpiece pairs keys size) equals: true.
	self assert: (wordpiece pairPositions keys asSet = wordpiece pairs keys asSet ) equals: true.
	self assert: (wordpiece pairsScores keys asSet = wordpiece pairs keys asSet ) equals: true.
	
	self assert: (wordpiece pairs includes: #('#i' '#d')) equals: false.
	self assert: (wordpiece pairs includes: #('#w' '#i')) equals: false.
	self assert: (wordpiece pairs includes: #('#d' '#e')) equals: false.
	
	self assert: wordpiece pairPositions keys asSet equals: #(#('l' '#o') #('#o' '#w') #('#w' '#e') #('#e' '#r') #('n' '#e') #('#e' '#w') #('#e' '#s') #('#s' '#t') 
	#('w' '#id') #('#id' '#e') ) asSet.
	
	self assert: (wordpiece pairs occurrencesOf: #('l' '#o')) equals: 7.
	self assert: (wordpiece pairs occurrencesOf: #('#o' '#w')) equals: 7.
	self assert: (wordpiece pairs occurrencesOf: #('#w' '#e')) equals: 8.
	self assert: (wordpiece pairs occurrencesOf: #('#e' '#r')) equals: 2.
	self assert: (wordpiece pairs occurrencesOf: #('n' '#e')) equals: 6.
	self assert: (wordpiece pairs occurrencesOf: #('#e' '#w')) equals: 6.
	self assert: (wordpiece pairs occurrencesOf: #('#e' '#s')) equals: 9.
	self assert: (wordpiece pairs occurrencesOf: #('#s' '#t')) equals: 9.
	self assert: (wordpiece pairs occurrencesOf: #('w' '#id')) equals: 3.
	self assert: (wordpiece pairs occurrencesOf: #('#id' '#e')) equals: 3.
	
	self assert: (wordpiece pairsScores at: #('l' '#o')) equals: 7/(7*7)asFloat .
	self assert: (wordpiece pairsScores at: #('#o' '#w')) equals: 7/(7*13)asFloat .
	self assert: (wordpiece pairsScores at: #('#w' '#e')) equals: 8/(13*17)asFloat .
	self assert: (wordpiece pairsScores at: #('#e' '#r')) equals: 2/(17*2)asFloat .
	self assert: (wordpiece pairsScores at: #('n' '#e')) equals: 6/(6*17)asFloat .
	self assert: (wordpiece pairsScores at: #('#e' '#w')) equals: 6/(17*13)asFloat .
	self assert: (wordpiece pairsScores at: #('#e' '#s')) equals: 9/(17*9)asFloat .
	self assert: (wordpiece pairsScores at: #('#s' '#t')) equals: 9/(9*9)asFloat .
	self assert: (wordpiece pairsScores at: #('w' '#id')) equals: 3/(3*3)asFloat .
	self assert: (wordpiece pairsScores at: #('#id' '#e')) equals: 3/(3*17)asFloat .
]

{ #category : 'tests' }
TestWordPieceLearner >> testPairsAffectedByMerge [ 
	|wordpiece pair|
	
	wordpiece := WordPieceLearner new.
	wordpiece fromText: self text2 .
	pair:= #('#o' '#w').
	
	wordpiece pairsAffectedByMerging: pair .
	
	self assert: wordpiece affectedPairSet equals: #(#('l' '#o') #('#w' '#e') #('#e' '#w') #('#w' '#e'))asSet .
	
	
	
]

{ #category : 'tests' }
TestWordPieceLearner >> testPretokenizeText [
	|bag wordpiece|
	bag := Bag new.
	wordpiece := WordPieceLearner new.
	bag add: {'l' . '#o' . '#w'  } asOrderedCollection withOccurrences: 5 .
	bag add: {'l' . '#o' . '#w' . '#e' . '#r'  } asOrderedCollection withOccurrences: 2 .
	bag add: {'n' . '#e' . '#w' . '#e' . '#s' . '#t'  } asOrderedCollection withOccurrences: 6 .
	bag add: {'w' . '#i' . '#d' . '#e' . '#s' . '#t'} asOrderedCollection withOccurrences: 3 .
	self assert: (wordpiece pretokenizeText: self text2) equals: bag .
]

{ #category : 'tests' }
TestWordPieceLearner >> testSplitWord [
	|word wordpiece|
	word := 'older'.
	wordpiece := WordPieceLearner new.
	self assert: (wordpiece splitWord: word)  equals: { 'o' . '#l' . '#d' . '#e' . '#r' } asOrderedCollection .
	
]

{ #category : 'tests' }
TestWordPieceLearner >> testThreeMergeOneStepIncreaseVocabulary [

	| wordpiece |
	wordpiece := WordPieceLearner new. 
	wordpiece fromText: self text2.
	
	self assert: wordpiece vocabulary size equals: 11.

	wordpiece mergesOneStep .
	wordpiece mergesOneStep .
	wordpiece mergesOneStep .
	
	self assert: (wordpiece vocabulary includes: 'lo') equals: true.
	self assert: wordpiece vocabulary size equals: 14.
	
	self assert: (wordpiece vocabulary size ~= wordpiece letters keys size) equals: true.
	self assert: (wordpiece letters keys asSet size = wordpiece lettersPositions keys size) equals: true.
	self assert: (wordpiece vocabulary ~= wordpiece letters keys asSet) equals: true.
	self assert: (wordpiece letters keys asSet = wordpiece lettersPositions keys asSet) equals: true.
	
	self assert: wordpiece vocabulary equals: #('l' '#o' '#w' '#e' '#r' 'n' '#s' '#t' 'w' '#i' '#d' '#id' 'wid' 'lo') asSet.
	
	self assert: (wordpiece letters includes: 'l') equals: false .
	self assert: (wordpiece letters includes: '#o') equals: false .
	
	self assert: (wordpiece letters occurrencesOf: 'lo') equals: 7.
	self assert: (wordpiece letters occurrencesOf: '#w') equals: 13.
	self assert: (wordpiece letters occurrencesOf: '#e') equals: 17.
	self assert: (wordpiece letters occurrencesOf: '#r') equals: 2.
	self assert: (wordpiece letters occurrencesOf: 'n') equals: 6.
	self assert: (wordpiece letters occurrencesOf: '#s') equals: 9.
	self assert: (wordpiece letters occurrencesOf: '#t') equals: 9.
	self assert: (wordpiece letters occurrencesOf: 'wid') equals: 3.
]

{ #category : 'tests' }
TestWordPieceLearner >> testThreeMergeOneStepRecomputePairs [

	|wordpiece|
	wordpiece := WordPieceLearner new.
	wordpiece words: self text2 .
	wordpiece computeVocabulary .
	wordpiece computePairs .
	wordpiece mergesOneStep .
	wordpiece mergesOneStep .
	wordpiece mergesOneStep .
	
	self assert: (wordpiece pairPositions keys size = wordpiece pairs keys size) equals: true.
	self assert: (wordpiece pairsScores keys size = wordpiece pairs keys size) equals: true.
	self assert: (wordpiece pairPositions keys asSet = wordpiece pairs keys asSet ) equals: true.
	self assert: (wordpiece pairsScores keys asSet = wordpiece pairs keys asSet ) equals: true.
	
	self assert: (wordpiece pairs includes: #('l' '#o')) equals: false.
	self assert: (wordpiece pairs includes: #('#o' '#w')) equals: false.
	
	self assert: wordpiece pairPositions keys asSet equals: #(#('lo' '#w') #('#w' '#e') #('#e' '#r') #('n' '#e') #('#e' '#w') #('#e' '#s') #('#s' '#t') 
	#('wid' '#e')) asSet.
	
	self assert: (wordpiece pairs occurrencesOf: #('lo' '#w')) equals: 7.
	self assert: (wordpiece pairs occurrencesOf: #('#w' '#e')) equals: 8.
	self assert: (wordpiece pairs occurrencesOf: #('#e' '#r')) equals: 2.
	self assert: (wordpiece pairs occurrencesOf: #('n' '#e')) equals: 6.
	self assert: (wordpiece pairs occurrencesOf: #('#e' '#w')) equals: 6.
	self assert: (wordpiece pairs occurrencesOf: #('#e' '#s')) equals: 9.
	self assert: (wordpiece pairs occurrencesOf: #('#s' '#t')) equals: 9.
	self assert: (wordpiece pairs occurrencesOf: #('wid' '#e')) equals: 3.
	
	self assert: (wordpiece pairsScores at: #('lo' '#w')) equals: 7/(7*13)asFloat .
	self assert: (wordpiece pairsScores at: #('#w' '#e')) equals: 8/(13*17)asFloat .
	self assert: (wordpiece pairsScores at: #('#e' '#r')) equals: 2/(17*2)asFloat .
	self assert: (wordpiece pairsScores at: #('n' '#e')) equals: 6/(6*17)asFloat .
	self assert: (wordpiece pairsScores at: #('#e' '#w')) equals: 6/(17*13)asFloat .
	self assert: (wordpiece pairsScores at: #('#e' '#s')) equals: 9/(17*9)asFloat .
	self assert: (wordpiece pairsScores at: #('#s' '#t')) equals: 9/(9*9)asFloat .
	self assert: (wordpiece pairsScores at: #('wid' '#e')) equals: 3/(3*17)asFloat .
]

{ #category : 'tests' }
TestWordPieceLearner >> testTwoMergeOneStepIncreaseVocabulary [

	| wordpiece |
	wordpiece := WordPieceLearner new. 
	wordpiece fromText: self text2.
	
	self assert: wordpiece vocabulary size equals: 11.

	wordpiece mergesOneStep .
	wordpiece mergesOneStep .
	
	self assert: (wordpiece vocabulary includes: 'wid') equals: true.
	self assert: wordpiece vocabulary size equals: 13.
	
	self assert: (wordpiece vocabulary size ~= wordpiece letters keys size) equals: true.
	self assert: (wordpiece letters keys asSet size = wordpiece lettersPositions keys size) equals: true.
	self assert: (wordpiece vocabulary ~= wordpiece letters keys asSet) equals: true.
	self assert: (wordpiece letters keys asSet = wordpiece lettersPositions keys asSet) equals: true.
	
	self assert: wordpiece vocabulary equals: #('l' '#o' '#w' '#e' '#r' 'n' '#s' '#t' 'w' '#i' '#d' '#id' 'wid') asSet.
	
	self assert: (wordpiece letters includes: 'w') equals: false .
	self assert: (wordpiece letters includes: '#id') equals: false .
	
	self assert: (wordpiece letters occurrencesOf: 'l') equals: 7.
	self assert: (wordpiece letters occurrencesOf: '#o') equals: 7.
	self assert: (wordpiece letters occurrencesOf: '#w') equals: 13.
	self assert: (wordpiece letters occurrencesOf: '#e') equals: 17.
	self assert: (wordpiece letters occurrencesOf: '#r') equals: 2.
	self assert: (wordpiece letters occurrencesOf: 'n') equals: 6.
	self assert: (wordpiece letters occurrencesOf: '#s') equals: 9.
	self assert: (wordpiece letters occurrencesOf: '#t') equals: 9.
	self assert: (wordpiece letters occurrencesOf: 'wid') equals: 3.
]

{ #category : 'tests' }
TestWordPieceLearner >> testTwoMergeOneStepRecomputePairs [

	|wordpiece|
	wordpiece := WordPieceLearner new.
	wordpiece words: self text2 .
	wordpiece computeVocabulary .
	wordpiece computePairs .
	wordpiece mergesOneStep .
	wordpiece mergesOneStep .
	
	self assert: (wordpiece pairPositions keys size = wordpiece pairs keys size) equals: true.
	self assert: (wordpiece pairsScores keys size = wordpiece pairs keys size) equals: true.
	self assert: (wordpiece pairPositions keys asSet = wordpiece pairs keys asSet ) equals: true.
	self assert: (wordpiece pairsScores keys asSet = wordpiece pairs keys asSet ) equals: true.
	
	self assert: (wordpiece pairs includes: #('w' '#id')) equals: false.
	self assert: (wordpiece pairs includes: #('#id' '#e')) equals: false.
	
	self assert: wordpiece pairPositions keys asSet equals: #(#('l' '#o') #('#o' '#w') #('#w' '#e') #('#e' '#r') #('n' '#e') #('#e' '#w') #('#e' '#s') #('#s' '#t') 
	#('wid' '#e')) asSet.
	
	self assert: (wordpiece pairs occurrencesOf: #('l' '#o')) equals: 7.
	self assert: (wordpiece pairs occurrencesOf: #('#o' '#w')) equals: 7.
	self assert: (wordpiece pairs occurrencesOf: #('#w' '#e')) equals: 8.
	self assert: (wordpiece pairs occurrencesOf: #('#e' '#r')) equals: 2.
	self assert: (wordpiece pairs occurrencesOf: #('n' '#e')) equals: 6.
	self assert: (wordpiece pairs occurrencesOf: #('#e' '#w')) equals: 6.
	self assert: (wordpiece pairs occurrencesOf: #('#e' '#s')) equals: 9.
	self assert: (wordpiece pairs occurrencesOf: #('#s' '#t')) equals: 9.
	self assert: (wordpiece pairs occurrencesOf: #('wid' '#e')) equals: 3.
	
	self assert: (wordpiece pairsScores at: #('l' '#o')) equals: 7/(7*7)asFloat .
	self assert: (wordpiece pairsScores at: #('#o' '#w')) equals: 7/(7*13)asFloat .
	self assert: (wordpiece pairsScores at: #('#w' '#e')) equals: 8/(13*17)asFloat .
	self assert: (wordpiece pairsScores at: #('#e' '#r')) equals: 2/(17*2)asFloat .
	self assert: (wordpiece pairsScores at: #('n' '#e')) equals: 6/(6*17)asFloat .
	self assert: (wordpiece pairsScores at: #('#e' '#w')) equals: 6/(17*13)asFloat .
	self assert: (wordpiece pairsScores at: #('#e' '#s')) equals: 9/(17*9)asFloat .
	self assert: (wordpiece pairsScores at: #('#s' '#t')) equals: 9/(9*9)asFloat .
	self assert: (wordpiece pairsScores at: #('wid' '#e')) equals: 3/(3*17)asFloat .
]

{ #category : 'tests' }
TestWordPieceLearner >> testUpdate [ 
	| pair bpe|
	bpe := WordPieceLearner new.
	bpe fromText: self text2 .
	
	pair:= #('#w' '#e').
	
	self assert: (bpe letters occurrencesOf: '#w') equals: 13.
	self assert: (bpe letters occurrencesOf: '#e') equals: 17.
	self assert: (bpe letters occurrencesOf: '#r') equals: 2.
	self assert: (bpe letters occurrencesOf: 'l') equals: 7.
	self assert: (bpe letters occurrencesOf: '#o') equals: 7.
	self assert: (bpe letters occurrencesOf: 'n') equals: 6.
	self assert: (bpe letters occurrencesOf: '#s') equals: 9.
	self assert: (bpe letters occurrencesOf: '#t') equals: 9.
	self assert: (bpe letters occurrencesOf: 'w') equals: 3.
	self assert: (bpe letters occurrencesOf: '#i') equals: 3.
	self assert: (bpe letters occurrencesOf: '#d') equals: 3.
	
	self assert: bpe pairPositions keys asSet equals: #(#('l' '#o') #('#o' '#w') #('#w' '#e') #('#e' '#r') #('n' '#e') #('#e' '#w') #('#e' '#s') #('#s' '#t') 
	#('w' '#i') #('#i' '#d') #('#d' '#e') ) asSet.
	
	self assert: (bpe pairs occurrencesOf: #('l' '#o')) equals: 7.
	self assert: (bpe pairs occurrencesOf: #('#o' '#w')) equals: 7.
	self assert: (bpe pairs occurrencesOf: #('#w' '#e')) equals: 8.
	self assert: (bpe pairs occurrencesOf: #('#e' '#r')) equals: 2.
	self assert: (bpe pairs occurrencesOf: #('n' '#e')) equals: 6.
	self assert: (bpe pairs occurrencesOf: #('#e' '#w')) equals: 6.
	self assert: (bpe pairs occurrencesOf: #('#e' '#s')) equals: 9.
	self assert: (bpe pairs occurrencesOf: #('#s' '#t')) equals: 9.
	self assert: (bpe pairs occurrencesOf: #('w' '#i')) equals: 3.
	self assert: (bpe pairs occurrencesOf: #('#i' '#d')) equals: 3.
	self assert: (bpe pairs occurrencesOf: #('#d' '#e')) equals: 3.
	
	self assert: (bpe pairsScores at: #('l' '#o')) equals: 7/(7*7)asFloat .
	self assert: (bpe pairsScores at: #('#o' '#w')) equals: 7/(7*13)asFloat .
	self assert: (bpe pairsScores at: #('#w' '#e')) equals: 8/(13*17)asFloat .
	self assert: (bpe pairsScores at: #('#e' '#r')) equals: 2/(17*2)asFloat .
	self assert: (bpe pairsScores at: #('n' '#e')) equals: 6/(6*17)asFloat .
	self assert: (bpe pairsScores at: #('#e' '#w')) equals: 6/(17*13)asFloat .
	self assert: (bpe pairsScores at: #('#e' '#s')) equals: 9/(17*9)asFloat .
	self assert: (bpe pairsScores at: #('#s' '#t')) equals: 9/(9*9)asFloat .
	self assert: (bpe pairsScores at: #('w' '#i')) equals: 3/(3*3)asFloat .
	self assert: (bpe pairsScores at: #('#i' '#d')) equals: 3/(3*3)asFloat .
	self assert: (bpe pairsScores at: #('#d' '#e')) equals: 3/(3*17)asFloat .
	
	bpe update: pair .
	
	self assert: (bpe letters occurrencesOf: '#w') equals: 5.
	self assert: (bpe letters occurrencesOf: '#we') equals: 8.
	self assert: (bpe letters occurrencesOf: '#e') equals: 9.
	self assert: (bpe letters occurrencesOf: '#r') equals: 2.
	self assert: (bpe letters occurrencesOf: 'l') equals: 7.
	self assert: (bpe letters occurrencesOf: '#o') equals: 7.
	self assert: (bpe letters occurrencesOf: 'n') equals: 6.
	self assert: (bpe letters occurrencesOf: '#s') equals: 9.
	self assert: (bpe letters occurrencesOf: '#t') equals: 9.
	self assert: (bpe letters occurrencesOf: 'w') equals: 3.
	self assert: (bpe letters occurrencesOf: '#i') equals: 3.
	self assert: (bpe letters occurrencesOf: '#d') equals: 3.
	
	self assert: (bpe pairs occurrencesOf: #('l' '#o')) equals: 7.
	self assert: (bpe pairs occurrencesOf: #('#o' '#w')) equals: 5.
	self assert: (bpe pairs occurrencesOf: #('#w' '#e')) equals: 0.
	self assert: (bpe pairs occurrencesOf: #('#o' '#we')) equals: 2.
	self assert: (bpe pairs occurrencesOf: #('#we' '#r')) equals: 2.
	self assert: (bpe pairs occurrencesOf: #('n' '#e')) equals: 6.
	self assert: (bpe pairs occurrencesOf: #('#e' '#we')) equals: 6.
	self assert: (bpe pairs occurrencesOf: #('#we' '#s')) equals: 6.
	self assert: (bpe pairs occurrencesOf: #('#e' '#s')) equals: 3.
	self assert: (bpe pairs occurrencesOf: #('#s' '#t')) equals: 9.
	self assert: (bpe pairs occurrencesOf: #('w' '#i')) equals: 3.
	self assert: (bpe pairs occurrencesOf: #('#i' '#d')) equals: 3.
	self assert: (bpe pairs occurrencesOf: #('#d' '#e')) equals: 3.
	
	self assert: bpe pairPositions keys asSet equals: #(#('l' '#o') #('#o' '#w') #('#o' '#we') #('#we' '#r') #('n' '#e') #('#e' '#we') #('#we' '#s') #('#s' '#t') 
	#('w' '#i') #('#i' '#d') #('#d' '#e') #('#e' '#s') ) asSet.
	
	self assert: (bpe pairsScores at: #('l' '#o')) equals: 7/(7*7)asFloat .
	self assert: (bpe pairsScores at: #('#o' '#w')) equals: 5/(7*5)asFloat .
	self assert: (bpe pairsScores at: #('#o' '#we')) equals: 2/(7*8)asFloat .
	self assert: (bpe pairsScores at: #('#we' '#r')) equals: 2/(8*2)asFloat .
	self assert: (bpe pairsScores at: #('n' '#e')) equals: 6/(6*9)asFloat .
	self assert: (bpe pairsScores at: #('#e' '#we')) equals: 6/(9*8)asFloat .
	self assert: (bpe pairsScores at: #('#we' '#s')) equals: 6/(8*9)asFloat .
	self assert: (bpe pairsScores at: #('#s' '#t')) equals: 9/(9*9)asFloat .
	self assert: (bpe pairsScores at: #('w' '#i')) equals: 3/(3*3)asFloat .
	self assert: (bpe pairsScores at: #('#i' '#d')) equals: 3/(3*3)asFloat .
	self assert: (bpe pairsScores at: #('#d' '#e')) equals: 3/(3*9)asFloat .
	self assert: (bpe pairsScores at: #('#e' '#s')) equals: 3/(9*9)asFloat .
	self assert: (bpe pairsScores includesKey: #('#w' '#e')) equals: false.
	
	self assert: bpe affectedPairSet equals: #(#('#o' '#w') #('#e' '#w') #('n' '#e') #('#e' '#r') #('#e' '#s') #('#d' '#e')) asSet .
	
	
	
	
	
	
	
]

{ #category : 'tests' }
TestWordPieceLearner >> testUpdateAfterThreeMergeOneStepIncreaseVocabulary [

	| wordpiece |
	wordpiece := WordPieceLearner new. 
	wordpiece fromText: self text2.
	
	self assert: wordpiece vocabulary size equals: 11.

	wordpiece mergesOneStep .
	wordpiece mergesOneStep .
	wordpiece mergesOneStep .
	wordpiece addToVocabulary: 'low'.
	wordpiece update: #('lo' '#w').
	
	self assert: (wordpiece vocabulary includes: 'low') equals: true.
	self assert: wordpiece vocabulary size equals: 15.
	
	self assert: (wordpiece vocabulary size ~= wordpiece letters keys size) equals: true.
	self assert: (wordpiece letters keys asSet size = wordpiece lettersPositions keys size) equals: true.
	self assert: (wordpiece vocabulary ~= wordpiece letters keys asSet) equals: true.
	self assert: (wordpiece letters keys asSet = wordpiece lettersPositions keys asSet) equals: true.
	
	self assert: wordpiece vocabulary equals: #('l' '#o' '#w' '#e' '#r' 'n' '#s' '#t' 'w' '#i' '#d' '#id' 'wid' 'lo' 'low') asSet.
	
	self assert: (wordpiece letters includes: 'lo') equals: false .
	self assert: (wordpiece letters includes: '#w') equals: true.
	
	self assert: (wordpiece letters occurrencesOf: 'low') equals: 7.
	self assert: (wordpiece letters occurrencesOf: '#w') equals: 6.
	self assert: (wordpiece letters occurrencesOf: '#e') equals: 17.
	self assert: (wordpiece letters occurrencesOf: '#r') equals: 2.
	self assert: (wordpiece letters occurrencesOf: 'n') equals: 6.
	self assert: (wordpiece letters occurrencesOf: '#s') equals: 9.
	self assert: (wordpiece letters occurrencesOf: '#t') equals: 9.
	self assert: (wordpiece letters occurrencesOf: 'wid') equals: 3.
]

{ #category : 'tests' }
TestWordPieceLearner >> testUpdateAfterThreeMergeOneStepRecomputePairs [

	|wordpiece|
	wordpiece := WordPieceLearner new.
	wordpiece words: self text2 .
	wordpiece computeVocabulary .
	wordpiece computePairs .
	wordpiece mergesOneStep .
	wordpiece mergesOneStep .
	wordpiece mergesOneStep .
	wordpiece update: #('lo' '#w').
	
	self assert: (wordpiece pairPositions keys size = wordpiece pairs keys size) equals: true.
	self assert: (wordpiece pairsScores keys size = wordpiece pairs keys size) equals: true.
	self assert: (wordpiece pairPositions keys asSet = wordpiece pairs keys asSet ) equals: true.
	self assert: (wordpiece pairsScores keys asSet = wordpiece pairs keys asSet ) equals: true.
	
	self assert: (wordpiece pairs includes: #('lo' '#w')) equals: false.
	
	self assert: wordpiece pairPositions keys asSet equals: #( #('#w' '#e') #('low' '#e') #('#e' '#r') #('n' '#e') #('#e' '#w') #('#e' '#s') #('#s' '#t') 
	#('wid' '#e')) asSet.
	
	self assert: (wordpiece pairs occurrencesOf: #('low' '#e')) equals: 2.
	self assert: (wordpiece pairs occurrencesOf: #('#w' '#e')) equals: 6.
	self assert: (wordpiece pairs occurrencesOf: #('#e' '#r')) equals: 2.
	self assert: (wordpiece pairs occurrencesOf: #('n' '#e')) equals: 6.
	self assert: (wordpiece pairs occurrencesOf: #('#e' '#w')) equals: 6.
	self assert: (wordpiece pairs occurrencesOf: #('#e' '#s')) equals: 9.
	self assert: (wordpiece pairs occurrencesOf: #('#s' '#t')) equals: 9.
	self assert: (wordpiece pairs occurrencesOf: #('wid' '#e')) equals: 3.
	
	self assert: (wordpiece pairsScores at: #('low' '#e')) equals: 2/(7*17)asFloat .
	self assert: (wordpiece pairsScores at: #('#w' '#e')) equals: 6/(6*17)asFloat .
	self assert: (wordpiece pairsScores at: #('#e' '#r')) equals: 2/(17*2)asFloat .
	self assert: (wordpiece pairsScores at: #('n' '#e')) equals: 6/(6*17)asFloat .
	self assert: (wordpiece pairsScores at: #('#e' '#w')) equals: 6/(17*6)asFloat .
	self assert: (wordpiece pairsScores at: #('#e' '#s')) equals: 9/(17*9)asFloat .
	self assert: (wordpiece pairsScores at: #('#s' '#t')) equals: 9/(9*9)asFloat .
	self assert: (wordpiece pairsScores at: #('wid' '#e')) equals: 3/(3*17)asFloat .
]

{ #category : 'tests' }
TestWordPieceLearner >> testUpdateToLettersAndLettersPosition [ 
	|wordpiece subword|
	wordpiece := WordPieceLearner new.
	
	self assert: wordpiece letters size equals: 0.
	self assert: wordpiece lettersPositions size equals: 0.
	
	subword := Subword new subword: 'l'; occurence: 1; position: 0.
	wordpiece addToLettersAndLettersPositions: subword .
	
	subword := Subword new subword: 'l'; occurence: 2; position: 3.
	wordpiece addToLettersAndLettersPositions: subword .
	
	self assert: (wordpiece letters occurrencesOf: 'l') equals: 3.
	self assert: (wordpiece lettersPositions at: 'l') equals: #(0 3) asSet.
	
	subword := Subword new subword: 'l'; occurence: 1; position: 0.
	wordpiece updateLettersAndLettersPositions: subword .
	
	self assert: (wordpiece letters occurrencesOf: 'l') equals: 2.
	self assert: (wordpiece lettersPositions at: 'l') equals: #(3) asSet.
]

{ #category : 'accessing structure variables' }
TestWordPieceLearner >> text2 [
	^ '
low low low low low
lower lower
newest newest newest newest newest newest 
widest widest widest'
]

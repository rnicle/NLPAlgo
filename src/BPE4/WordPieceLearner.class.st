Class {
	#name : 'WordPieceLearner',
	#superclass : 'BPELearner',
	#instVars : [
		'letters',
		'lettersPositions',
		'pairsScores',
		'affectedPairSet'
	],
	#category : 'BPE4',
	#package : 'BPE4'
}

{ #category : 'adding' }
WordPieceLearner >> addNewPairsScoresFrom: aSubword and: aSubword1 [
"Ajout d'une nouvelle paire formée par aSubword et aSubword1 dans pairesScores."

	|pair|.
	pair := { aSubword subword . aSubword1 subword }.
	
	(pairs occurrencesOf: pair) = 0 ifTrue: [ pairsScores removeKey: pair ifAbsent:[] ]
		
	 											ifFalse: [ pairsScores 
																	at: pair 
																	put: (pairs occurrencesOf: pair )/ ((letters occurrencesOf: pair first) * (letters occurrencesOf: pair second )) asFloat] .
]

{ #category : 'adding' }
WordPieceLearner >> addToAffectedPairSet: pair [
"Ajout de la nouvelle paire pair dans affectedPairSet"
	
	affectedPairSet add: pair 
]

{ #category : 'adding' }
WordPieceLearner >> addToLettersAndLettersPositions: aSubword [

"Ajout d'un nouveau chaîne de caractère dans letters et lettersPositions à partir de aSubword."

	letters add: aSubword subword 
				withOccurrences: aSubword occurence .
				
	lettersPositions at: aSubword subword 
						update: [:set| set add: aSubword position ; yourself ] 
						initial: (Set with: aSubword position)


]

{ #category : 'accessing' }
WordPieceLearner >> affectedPairSet [
"Renvoie l'ensemble des paires affectées par la fusion (les paires contenant l'un des élémentsde la paire fusionnée)"

	^ affectedPairSet 
]

{ #category : 'adding' }
WordPieceLearner >> computePairs [
"Ajout de paires dans pairs, pairPositions (grâce à la méthode computePairs en parcourant la liste châinée de mots) et pairsScores (obtenus grâce aux éléments de pairs et letters)."

	super computePairs .
	
	pairs associationsDo: [ :each| 
		pairsScores 
			at: each key 
			put: each value/ ((letters occurrencesOf: each key first) * (letters occurrencesOf: each key second)) asFloat ]

]

{ #category : 'operations' }
WordPieceLearner >> createNewVocabulary: pair [
"Construit un nouveau vocabulaire en concatenant le premier élément de la paire avec le second élément privé de son premier caractère."

	|newVocabulary|
	newVocabulary := pair first, pair second allButFirst .
	^ newVocabulary 
]

{ #category : 'accessing' }
WordPieceLearner >> findPairToMerge [ 
"Cherche la paire ayant la fréquence maximale dans pairsScores et le renvoie."

	^ (pairsScores associations detectMax: [:assoc | assoc value]) key
]

{ #category : 'nodes' }
WordPieceLearner >> fusion: anArray [
"Concatène les sous-mots du premier et du second nœud référencés dans le vecteur fourni, en mettant à jour le sous-mot du premier nœud, puis supprime le second nœud de la liste chaînée."
	anArray first value subword: (anArray first value subword , anArray second value subword allButFirst ).
	words removeLink: anArray second .
]

{ #category : 'initialization' }
WordPieceLearner >> initialize [ 
	super initialize .
	pairsScores := Dictionary new.
	letters := Bag new.
	lettersPositions := Dictionary new.
	affectedPairSet := Set new .
]

{ #category : 'accessing' }
WordPieceLearner >> letters [ 
"renvoie un bag contenant tous les chaînes de caractères qui composent le texte."

	^letters 
]

{ #category : 'accessing' }
WordPieceLearner >> lettersPositions [
"Retourne un dictionnaire associant chaque caractère du texte à un ensemble de ses positions dans le texte."


	^ lettersPositions 
]

{ #category : 'adding' }
WordPieceLearner >> pairsAffectedByMerging: aPair [
"Ajout des paires affectées par la fusion de aPair dans affectedPairSet grâce à la méthode tryAddPairAffectedByMergeWith:in:
et en parcourant lettersPositions car les paires affectées par la fusion sont les paires contenant l'un des éléments de la paire fusionnée"

	| pair|
	pair:= {( Subword new subword: aPair first) . ( Subword new subword: aPair second)}.
	
	(lettersPositions at: aPair first ) do: [ :each | 
		
		({ each previousLink value . each value } ~= pair ) ifTrue: [ each value tryAddPairAffectedByMergeWith: each previousLink value in: self ].
		
		({ each value . each nextLink value } ~= pair ) ifTrue: [ each nextLink value tryAddPairAffectedByMergeWith: each value in: self ]
		
			].
			
	(lettersPositions at: aPair second ) do: [ :each | 
		
		({ each previousLink value . each value } ~= pair ) ifTrue: [ each value tryAddPairAffectedByMergeWith: each previousLink value in: self ].
		
		({ each value . each nextLink value } ~= pair ) ifTrue: [ each nextLink value tryAddPairAffectedByMergeWith: each value in: self ]
		
			].
]

{ #category : 'accessing' }
WordPieceLearner >> pairsScores [
"Renvoie un dictionnaire associant chaque paire à son score correspondant."

	^pairsScores 
]

{ #category : 'operations' }
WordPieceLearner >> splitWord: aString [
"Transforme une chaîne en une collection de caractères, 
en préfixant le premier caractère tel quel et en ajoutant un '#' devant chaque caractère suivant."

	|col|
	col:=OrderedCollection new .
	col add: aString first asString.
	
	2 to: aString size do: [ :i| 
		col add: '#',(aString at: i) asString ] .
	^col .
]

{ #category : 'update' }
WordPieceLearner >> update: aPair [
	| position|
	affectedPairSet removeAll . "initialiser affectedPairSet à chaque mises à jours car elle change à chaque mises à jours."
	self pairsAffectedByMerging: aPair . "ajoute toutes paires affectée par la fusion dans affectedPairSet."
	position := pairPositions at: aPair . "récupère la position de chacun des éléments du paire fusionnée dans le texte."
	
	position do: [ :each |           
		self updateLettersAndLettersPositions: each first value. "mises à jours de l'occurence du premier élément de la paire fusionée 
		dans letters et lettersPositions"
		self updateLettersAndLettersPositions: each second value. "mises à jours de l'occurence du second élément de la paire fusionée 
		dans letters et lettersPositions"
		 ].
	
	super update: aPair . "Mises à jours des paires voisines de la paire fusionnée."

	affectedPairSet do: [ :each |    "mises à jours des paires affectées par la fusion dans pairsScores"
		self updatePairsScoresFrom: each
		 ].
	
	position do: [ :each | self addToLettersAndLettersPositions: each first value ]. "ajouts du nouveau chaîne de caratère, ainsi que ses occurences et ses positions dans le texte, obtenus grâce à la fusion dans letters et lettersPositions."
	
	position do: [ :each|   "ajouts des nouveaux paires obtenus grâce à la fusion dans pairsScores."
		each first value 
			tryAddPairsScoreWith: each first previousLink value 
			in: self.
		each first nextLink value 
			tryAddPairsScoreWith: each first value  
			in: self].
		
	pairsScores removeKey: aPair . "suppresion de la paire fusionnée dans pairsScores"
]

{ #category : 'update' }
WordPieceLearner >> updateLettersAndLettersPositions: aSubword [

	letters add: aSubword subword withOccurrences: aSubword occurence negated .
	
	(letters occurrencesOf: aSubword subword ) = 0 ifTrue: [ letters removeKey: aSubword 
																						subword ifAbsent: []].
	
	lettersPositions at: aSubword subword  update: [:set| set remove: aSubword position  
																				ifAbsent:[] ; yourself ].
	
	(lettersPositions at: aSubword subword ) size = 0 ifTrue: [ lettersPositions removeKey: aSubword subword ]
	


]

{ #category : 'adding' }
WordPieceLearner >> updatePairsScoresFrom: pair [
	
	(pairs occurrencesOf: pair) = 0 ifTrue: [ pairsScores removeKey: pair ifAbsent:[] ]
		
	 											ifFalse: [ pairsScores at: pair 
																				put: (pairs occurrencesOf: pair )/ ((letters occurrencesOf: pair first) * (letters occurrencesOf: pair second )) asFloat] .
]

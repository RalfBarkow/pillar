Class {
	#name : #PRListTest2,
	#superclass : #PRParseDocumentGroupTest,
	#category : #'Pillar-Tests-Core'
}

{ #category : #private }
PRListTest2 >> actualClass [
	^ PRList
]

{ #category : #private }
PRListTest2 >> listItemClass [
	^ PRListItem
]

{ #category : #private }
PRListTest2 >> listItemWithText: aString [
	^ self listItemClass new
		add: (PRText content: aString);
		yourself
]

{ #category : #'tests-parsing' }
PRListTest2 >> testParseEmpty [
	| wiki text tree |
	wiki := self wikiString.
	text := self textString: 1 level: 1.
	tree := PRDocument new
		add: (self actualClass new
			add: self listItemClass new;
			yourself);
		yourself.
	self parserAssertWiki: wiki equalsTree: tree.
	self pillarWriterAssertTree: tree equalsWiki: wiki.
	self textWriterAssertTree: tree equalsText: text
]

{ #category : #'tests-parsing' }
PRListTest2 >> testParseFlat [
	| wiki text tree nLine |
	nLine := Smalltalk os lineEnding.
	wiki := self wikiString , '1st' , nLine , self wikiString , '2nd' , nLine , self wikiString , '3rd'.
	text := (self textString: 1 level: 1) , '1st' , nLine , (self textString: 2 level: 1) , '2nd' , nLine
		, (self textString: 3 level: 1) , '3rd'.
	tree := PRDocument new
		add:
				(self actualClass new
						add: (self listItemWithText: '1st');
						add: (self listItemWithText: '2nd');
						add: (self listItemWithText: '3rd');
						yourself);
		yourself.
	self parserAssertWiki: wiki equalsTree: tree.
	self pillarWriterAssertTree: tree equalsWiki: wiki.
	self textWriterAssertTree: tree equalsText: text
]

{ #category : #'tests-parsing' }
PRListTest2 >> testParseMultiple [
	| wiki text tree nLine |
	nLine := Smalltalk os lineEnding.
	wiki := self wikiString , '1st' , nLine , self wikiString , '2nd' , nLine , nLine , self wikiString , '3rd'.
	text := (self textString: 1 level: 1) , '1st' , nLine , (self textString: 2 level: 1) , '2nd' , nLine , nLine
		, (self textString: 1 level: 1) , '3rd'.
	tree := PRDocument new
		add:
				(self actualClass new
						add: (self listItemWithText: '1st');
						add: (self listItemWithText: '2nd');
						yourself);
		add: PREmptyParagraph new;
		add:
				(self actualClass new
						add: (self listItemWithText: '3rd');
						yourself);
		yourself.
	self parserAssertWiki: wiki equalsTree: tree.
	self pillarWriterAssertTree: tree equalsWiki: wiki.
	self textWriterAssertTree: tree equalsText: text
]

{ #category : #'tests-parsing' }
PRListTest2 >> testParseWithTrailingSpaces [
	| wiki tree |
	wiki := self wikiString , ' 1st'.
	tree := PRDocument new
		add:
			(self actualClass new
				add: (self listItemWithText: '1st');
				yourself);
		yourself.
	self parserAssertWiki: wiki equalsTree: tree
]

{ #category : #private }
PRListTest2 >> textString: anObject level: anInteger [
	^ (2 to: anInteger) inject: '' into: [ :result :each | result , '	' ]
]

{ #category : #private }
PRListTest2 >> wikiString [
	self subclassResponsibility
]
Extension { #name : #String }

{ #category : #'*Ride-Pharo' }
String >> asSnakeCase [

	"Convert to snake_case, i.e, remove spaces, and convert starting 
	uppercase to lowecase and using underscore as separator."

	"'A man, a plan, a canal, panama' asSnakeCase >>> 'a_man,a_plan,a_canal,panama'"

	"'Here 123should % be 6 the name6 of the method' asSnakeCase  >>> 'ere_123should_%_be_6_the_name6_of_the_method'"

	| char |
	^ self species streamContents: [ :output | 
		  self readStreamDo: [ :input | 
			  [ input atEnd ] whileFalse: [ 
				  char := input next.
				  char isUppercase
					  ifTrue: [ 
						  input position = 1
							  ifTrue: [ output nextPut: char asLowercase ]
							  ifFalse: [ 
								  output
									  nextPut: $_;
									  nextPut: char asLowercase ] ]
					  ifFalse: [ 
						  (char = Character space or: [ char = $- ])
							  ifFalse: [ output nextPut: char ]
							  ifTrue: [ output nextPut: $_ ] ] ] ] ]
]

Extension { #name : #BlockClosure }

{ #category : #'*Ride' }
BlockClosure >> logDebug [

	^ self logLevel: #DEBUG
]

{ #category : #'*Ride' }
BlockClosure >> logError [

	^ self logLevel: #ERROR
]

{ #category : #'*Ride' }
BlockClosure >> logInfo [

	^ self logLevel: #INFO
]

{ #category : #'*Ride' }
BlockClosure >> logLevel: aSymbol [

	"Log if the level is allowed, bypass computing the receiver if it itsn't"

	^ (Ride allowsLoglevel: aSymbol) ifTrue: [ 
		  Ride log: self value level: aSymbol ]
]

{ #category : #'*Ride' }
BlockClosure >> logWarning [

	^ self logLevel: #WARNING
]

{ #category : #'*Ride' }
BlockClosure >> serviceCacheAt: aKey [

	^ Ride service cache at: aKey ifAbsentPut: self
]

{ #category : #'*Ride' }
BlockClosure >> sessionCacheAt: aKey [

	^ RideCurrentSession value cache at: aKey ifAbsentPut: self
]

{ #category : #'*Ride' }
BlockClosure >> systemValueAt: aKey [

	^ Ride resource values at: aKey ifAbsentPut: self
]

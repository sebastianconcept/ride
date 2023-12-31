Extension { #name : #BlockClosure }

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

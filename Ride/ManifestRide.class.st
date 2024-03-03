"
manifest
"
Class {
	#name : #ManifestRide,
	#superclass : #PackageManifest,
	#category : #'Ride-Manifest'
}

{ #category : #'code-critics' }
ManifestRide class >> ruleSentNotImplementedRuleV1FalsePositive [

	<ignoreForCoverage>
	^ #(#(#(#RGPackageDefinition #(#Ride)) #'2024-03-02T21:33:29.969701-03:00') )
]

"
A BreakpointTest is a test class for testing the behavior of Breakpoint
"
Class {
	#name : #BreakpointTest,
	#superclass : #TestCase,
	#instVars : [
		'previousBreakpoints',
		'cls'
	],
	#category : #'Reflectivity-Tools-Tests'
}

{ #category : #utilities }
BreakpointTest >> newDummyClass [
	^ Object
		subclass: #DummyClassForBreakpoint
		instanceVariableNames: ''
		classVariableNames: ''
		package: 'DummyPackage'
]

{ #category : #running }
BreakpointTest >> setUp [
	super setUp.
	cls := self newDummyClass.
	previousBreakpoints := Breakpoint all copy.
	Breakpoint all removeAll.
]

{ #category : #running }
BreakpointTest >> tearDown [
	| pkg |	
	Breakpoint all addAll: previousBreakpoints.
	cls ifNotNil: [ cls isObsolete ifFalse: [ cls removeFromSystem ] ].
	pkg := 'DummyPackage' asPackageIfAbsent: [ ]. 
	pkg ifNotNil: [ pkg removeFromSystem ].
	super tearDown.
]

{ #category : #tests }
BreakpointTest >> testAddBreakpoint [
	|bp|
	cls compile: 'dummy ^42'.
	self assertEmpty: Breakpoint all.
	bp := Breakpoint new.
	bp	node: (cls >> #dummy) ast;
		once;
		install.
	self assertCollection: Breakpoint all includesAll: {bp}.
	bp remove

]

{ #category : #tests }
BreakpointTest >> testModifyMethodWithBreakpoint [
	cls compile: 'dummy ^42'.
	self assertEmpty: Breakpoint all.
	Breakpoint new
		node: (cls >> #dummy) ast;
		once;
		install.
	self assert: (cls >> #dummy) hasBreakpoint.
	cls compile: 'dummy ^43'.
	self assertEmpty: Breakpoint all
]

{ #category : #tests }
BreakpointTest >> testRemoveBreakpoint [
	| bp |
	cls compile: 'dummy ^42'.
	self assertEmpty: Breakpoint all.
	bp := Breakpoint new.
	bp
		node: (cls >> #dummy) ast;
		once;
		install.
	bp remove.
	self assertEmpty: Breakpoint all
]

{ #category : #tests }
BreakpointTest >> testRemoveClassWithBreakpoint [
	cls compile: 'dummy ^42'.
	self assertEmpty: Breakpoint all.
	Breakpoint new
		node: (cls >> #dummy) ast;
		once;
		install.
	self assert: (cls >> #dummy) hasBreakpoint.
	cls removeFromSystem.
	self assertEmpty: Breakpoint all
]

{ #category : #tests }
BreakpointTest >> testRemoveMethodWithBreakpoint [
	cls compile: 'dummy ^42'.
	self assertEmpty: Breakpoint all.
	Breakpoint new
		node: (cls >> #dummy) ast;
		once;
		install.
	self assert: (cls >> #dummy) hasBreakpoint.
	cls removeSelector: #dummy.
	self
		assertEmpty: cls methods;
		assertEmpty: Breakpoint all
]

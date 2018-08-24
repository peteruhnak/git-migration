ui
do: aBlock displaying: aString
	aString
		displayProgressFrom: 0
		to: 2
		during: [ :bar | 
			bar value: 1.
			World doOneCycle.
			aBlock value.
			bar value: 2 ]
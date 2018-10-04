accessing
commitMessage
	^ String
		<< [ :stream | 
			stream << (info message copyWithout: Character null) withUnixLineEndings.
			(self coauthors sorted: #name ascending)
				ifNotEmpty: [ :co | 
					stream lf.
					stream lf.
					co
						do: [ :each | stream << 'Co-authored-by: ' << each name << ' <' << each email << '>' ]
						separatedBy: [ stream lf ] ] ]
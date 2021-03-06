$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path).Replace(".Tests.", ".")
. "$here\$sut"

InModuleScope ImprovedConvertFromJson {

	#region Test data
	$jsonHash = @"
	{
	    "glossary": {
	        "title": "example glossary",
			"GlossDiv": {
	            "title": "S",
				"GlossList": {
	                "GlossEntry": {
	                    "ID": "SGML",
						"SortAs": "SGML",
						"GlossTerm": "Standard Generalized Markup Language",
						"Acronym": "SGML",
						"Abbrev": "ISO 8879:1986",
						"GlossDef": {
	                        "para": "A meta-markup language, used to create markup languages such as DocBook.",
							"GlossSeeAlso": ["GML", "XML"]
	                    },
						"GlossSee": "markup"
	                }
	            }
	        }
	    }
	}
"@

	$jsonArray = @"
[
		{
			color: "red",
			value: "#f00"
		},
		{
			color: "green",
			value: "#0f0"
		},
		{
			color: "blue",
			value: "#00f"
		}
	]
"@
#endregion

	Describe "ConvertFrom-JsonWithArgs" {
		It "Can parse JSON dictionary" {
			$output = ConvertFrom-JsonWithArgs -InputObject $jsonHash
            $output 					| Should Not BeNullOrEmpty
			$output.glossary 			| Should Not BeNullOrEmpty
			$output.glossary.title 		| Should Not BeNullOrEmpty
			$output.glossary.title		| Should Be "example glossary"
		}

		It "Can parse JSON array" {
			$output = ConvertFrom-JsonWithArgs -InputObject $jsonArray
			$output 					| Should Not BeNullOrEmpty
			$output.Length 				| Should Be 3
			$output[0] 					| Should Not BeNullOrEmpty
			$output[0].color 			| Should Be "red"
		}

		It "Sets MaxLength" {
			{ConvertFrom-JsonWithArgs -InputObject $jsonArray -MaxJsonLength 1} | Should Throw
		}
	}
}

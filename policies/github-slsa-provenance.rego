# METADATA
# title: GitHub SLSA Provenance
# description: >-
#   Verify SLSA Provenance created in GitHub meets requirements.
package festoji.policies.github_slsa_provenance

import future.keywords.contains
import future.keywords.if
import future.keywords.in

# METADATA
# title: Materials
# description: Verify SLSA Provenance materials are correct.
# custom:
#   short_name:  materials
#   failure_msg: Unexpected materials
deny contains result if {
	some att in input.attestations
	match := [material |
		some material in att.statement.predicate.materials
		material.uri == "git+https://github.com/lcarva/festoji@refs/heads/master"
	]
	count(match) == 0
	result := "Unexpected materials"
}

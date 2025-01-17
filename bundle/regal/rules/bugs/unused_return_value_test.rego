package regal.rules.bugs["unused-return-value_test"]

import rego.v1

import data.regal.ast
import data.regal.capabilities
import data.regal.config
import data.regal.rules.bugs["unused-return-value"] as rule

test_fail_unused_return_value if {
	r := rule.report with input as ast.with_rego_v1(`allow if {
		indexof("s", "s")
	}`)
		with data.internal.combined_config as {"capabilities": capabilities.provided}
	r == {{
		"category": "bugs",
		"description": "Non-boolean return value unused",
		"level": "error",
		"location": {"col": 3, "file": "policy.rego", "row": 6, "text": "\t\tindexof(\"s\", \"s\")"},
		"related_resources": [{
			"description": "documentation",
			"ref": config.docs.resolve_url("$baseUrl/$category/unused-return-value", "bugs"),
		}],
		"title": "unused-return-value",
	}}
}

test_success_unused_boolean_return_value if {
	r := rule.report with input as ast.with_rego_v1(`allow if { startswith("s", "s") }`)
		with data.internal.combined_config as {"capabilities": capabilities.provided}
	r == set()
}

test_success_return_value_assigned if {
	r := rule.report with input as ast.with_rego_v1(`allow if { x := indexof("s", "s") }`)
		with data.internal.combined_config as {"capabilities": capabilities.provided}
	r == set()
}

test_success_function_arg_return_ignored if {
	r := rule.report with data.internal.combined_config as {"capabilities": capabilities.provided}
		with input as ast.with_rego_v1(`allow if {
		indexof("s", "s", i)
	}`)
	r == set()
}

test_success_not_triggered_by_print if {
	r := rule.report with data.internal.combined_config as {"capabilities": capabilities.provided}
		with input as ast.with_rego_v1(`allow if {
		print(lower("A"))
	}`)
	r == set()
}

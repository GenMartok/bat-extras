setup() {
	set - pos1 \
		--val1 for_val1 \
		--val2=for_val2 \
		pos2 \
		--flag1 \
		-v3=for_val3 \
		-v4 \
		-v55 \
		-vn for_val4 \
		--flag2

	source "${LIB}/print.sh"
	source "${LIB}/opt.sh"
}

assert_opt_value() {
	assert [ "$OPT_VAL" = "$1" ]
}

assert_opt_valueless() {
	assert [ -z "$OPT_VAL" ]
}

test:long() {
	description "Parse long options."

	while shiftopt; do
		if [[ "$OPT" = "--flag1" ]]; then
			assert_opt_valueless
			return
		fi
	done

	fail 'Failed to find option.'
}

test:long_value_implicit() {
	description "Parse long options in '--long value' syntax."

	while shiftopt; do
		if [[ "$OPT" = "--val1" ]]; then
			shiftval
			assert_opt_value 'for_val1'
			return
		fi
	done

	fail 'Failed to find option.'
}

test:long_value_explicit() {
	description "Parse long options in '--long=value' syntax."

	while shiftopt; do
		if [[ "$OPT" = "--val2" ]]; then
			shiftval
			assert_opt_value 'for_val2'
			return
		fi
	done

	fail 'Failed to find option.'
}

test:short_value_implicit_number() {
	description "Parse short options in '-k0' syntax."

	while shiftopt; do
		if [[ "$OPT" = "-v4" ]]; then
			shiftval
			assert_opt_value '4'
			return
		fi
	done

	fail 'Failed to find option.'
}


test:short_value_implicit_number2() {
	description "Parse short options in '-k0' syntax."

	while shiftopt; do
		if [[ "$OPT" = "-v55" ]]; then
			shiftval
			assert_opt_value '55'
			return
		fi
	done

	fail 'Failed to find option.'
}

test:short_value_implicit() {
	description "Parse short options in '-k value' syntax."

	while shiftopt; do
		if [[ "$OPT" = "-vn" ]]; then
			shiftval
			assert_opt_value 'for_val4'
			return
		fi
	done

	fail 'Failed to find option.'
}

test:short_value_explicit() {
	description "Parse short options in '-k=value' syntax."

	while shiftopt; do
		if [[ "$OPT" =~ ^-v3 ]]; then
			assert_equal "$OPT" "-v3=for_val3"
			return
		fi
	done

	fail 'Failed to find option.'
}

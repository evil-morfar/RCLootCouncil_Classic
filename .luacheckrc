std = "lua51"
max_line_length = false
allow_defined_top = true
exclude_files = {
   ".luacheckrc"
}

ignore = {
   "111/_",    -- Setting an undefined (_) global variable.
   "113",      -- Accessing an undefined global variable.
   "131",      -- Unused implicitly defined global variable.
   "212",      -- Unused argument.
   "412",      -- Redefining an argument.
   "421/data", --	Shadowing a local variable (data).
   "431",      -- Shadowing an upvalue.
}

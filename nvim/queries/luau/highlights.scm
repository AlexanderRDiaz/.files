; extends

; Override PascalCase capture to @variable
((identifier) @variable
  (#lua-match? @variable "^[A-Z]"))

; Constants
((identifier) @constant
  (#lua-match? @constant "^[A-Z][A-Z_0-9]+$"))

local self = {}

self.diagnostics = {
    error = "",
    warn = "",
    info = "",
    hint = "",
}

self.progress_spinner = { "", "", "", "", "", "" }

self.checkmark = "󰄬"

return self

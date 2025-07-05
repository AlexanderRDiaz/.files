local python_path = vim.fn.exepath("python3")

-- In case of no available python install through a package manager.
if python_path == nil or python_path == "" then
    python_path = vim.g.homebrew_install_dir .. "/bin/python3"
    if io.open(python_path, "r") then
        vim.g.python3_host_prog = python_path
    end
else
    vim.g.python3_host_prog = python_path
end

require("main.set")
require("main.lazy")
require("main.remap")

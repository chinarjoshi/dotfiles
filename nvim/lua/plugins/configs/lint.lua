local ok, lint = pcall(require, 'lint')
local present, luacheck = pcall(require, 'lint.linters.luacheck')
if not (ok and present) then
    return
end

lint.linters_by_ft = {
    python = { 'flake8' },
    lua = { 'luacheck' },
    cpp = { 'clangtidy' },
}
luacheck.args = {
    '--formatter', 'plain', '--codes', '--globals', 'vim', '--ranges', '-'
}

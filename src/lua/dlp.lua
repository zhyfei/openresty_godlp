local _M = {
    _VERSION = '0.3',
}
local mt = {
    __metatable = 0, --protected metatable
    __index = function(_, k) ngx.log(ngx.ERR, k .. " member not exist") return nil end,
    __newindex = function(_, k, v) error("Update Prohibited", 2) end
}
local dlpengine = require "libdlp"
dlp_engine = nil

local function resp_replace_kw(chunk, eof)
    local buffered = ngx.ctx.buffered
    local replace_flag = false
    if not buffered then
        buffered = {}
        ngx.ctx.buffered = buffered
    end

    if nil ~= chunk and "" ~= chunk then
        buffered[#buffered + 1] = chunk
        ngx.arg[1] = nil
    end
   
    if nil ~= buffered and eof then
        local whole = table.concat(buffered)
        ngx.ctx.buffered = nil
        local new_context, n, err
        local engine = dlp_engine
        if engine == nil then
           ngx.log(ngx.ERR, "fuck engine is nil", ngx.ctx.test)
           return
        end
        new_context = engine:deidentify(whole)
        ngx.arg[1] = new_context
    end
end


function _M.init_worker(confPath)
    local engine = dlpengine.New(confPath, tostring(ngx.worker.id()))
    if engine == nil then
        return
    end
    ngx.log(ngx.ERR, "engine init success")
    dlp_engine = engine
    return dlp_engine
end

function _M.body_filter_by_lua()
	local resp_body = ngx.arg[1] --获取响应体
	local eof = ngx.arg[2]
	resp_replace_kw(resp_body, eof)
end
return _M

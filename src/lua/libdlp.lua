local ffi = require('ffi')
local ffi_new  = ffi.new
local ffi_cast = ffi.cast


-- module
local _M = {
    _VERSION = '0.3',
}
local so_name = "libdlp.so"
local lib
local store = {} -- handle array

-- metatable
local mt = {
    __metatable = 0, --protected metatable
    __index = function(_, k) ngx.log(ngx.ERR, k .. " member not exist") return nil end,
    __newindex = function(_, k, v) error("Update Prohibited", 2) end
}

-- C function prototypes
ffi.cdef[[
    int NewEngine(const char* conf_path, char* namespace, void** engine);
    int Deidentify(void* engine, const char* inputText, char** outputText, unsigned long* outlen);
    void Close(void* engine);
    void FreeString(char* s);
]]

-- Function to create the engine
local function NewEngine(conf_path, namespace)
    local engine = ffi.new("void*[1]")
    local namespacestr = ffi.cast("char*", namespace)
    local ret = lib.NewEngine(conf_path, namespacestr, engine)
    if ret ~= 0 then
        print("Failed to create the engine.")
        return nil
    end
    return engine[0]
end

-- 每次调用Deidentify都会创建一个新的outputText，需要在外部释放
-- Function to deidentify text
local function _deidentify(self, inputText)
    local outputText = ffi.new("char*[1]")
    local outlen = ffi.new("unsigned long[1]")
    local inputTextC = ffi.cast("const char*", inputText)    
    local ret = lib.Deidentify(self.engine, inputTextC, outputText, outlen)
    if ret ~= 0 then
        print("Deidentification failed.")
        lib.FreeString(outputText[0])
        return inputText
    end
    local result = ffi.string(outputText[0], outlen[0])
    lib.FreeString(outputText[0])
    return result
end

-- Function to close the engine
local function _close(self)
    lib.Close(self.engine)
end



-- load library
for k,_ in string.gmatch(package.cpath, "[^;]+") do
    local so_path = string.match(k, "(.*/)")
    if so_path then
        so_path = so_path .. so_name
        local f = io.open(so_path)
        if f ~= nil then
            io.close(f)
            lib = ffi.load(so_path)
        end
    end
end

if not lib then
    error("can not find " .. so_name)
end

function _M.New(conf_path, namespace)
    local Engine = NewEngine(conf_path, namespace)
    print("in lib start to initialize engine", Engine)
    if not Engine  then
        return nil
    end

    local self = setmetatable({
        engine = Engine,
        deidentify = _deidentify,        
        close = _close
    }, mt)
    return self
end
return _M

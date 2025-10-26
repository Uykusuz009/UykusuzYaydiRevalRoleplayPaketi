----- ----- ----- ----- ----- 
---- github.com/clarosep ----
----- ----- ----- ----- -----

function createClass()
    local cls = {}
    local instance = {}

    cls.__index = cls

    function cls.new(...)
        local self = setmetatable({}, cls)
        if self.init then
            self:init(...)
        end
        return self
    end

    function cls:addMethod(name, fn)
        self[name] = fn
    end

    function cls:extend(name)
        local subclass = createClass()
        subclass.__index = subclass
        subclass.__super = self
        setmetatable(subclass, { __index = self })
        subclass.__type = name
        return subclass
    end

    setmetatable(instance, cls)
    return cls, instance
end
if SERVER then
    AddCSLuaFile("tarkovhealthsystem/cl_thsinit.lua")
    AddCSLuaFile("tarkovhealthsystem/sh_thsdatabase.lua")
    include("tarkovhealthsystem/cl_thsinit.lua")
    include("tarkovhealthsystem/sh_thsdatabase.lua")
elseif CLIENT then
    include("tarkovhealthsystem/cl_thsinit.lua")
    include("tarkovhealthsystem/sh_thsdatabase.lua")
end
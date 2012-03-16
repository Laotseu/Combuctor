﻿--[[
	itemFrameEvents.lua
		A single event handler for the frame object
--]]

local AddonName, Addon = ...
local FrameEvents = Addon:NewModule('FrameEvents')
local frames = {}

function FrameEvents:Load()
	local CSet = Addon('Sets')

	CSet:RegisterMessage(self, 'COMBUCTOR_SET_ADD', 'UpdateSets')
	CSet:RegisterMessage(self, 'COMBUCTOR_SET_UPDATE', 'UpdateSets')
	CSet:RegisterMessage(self, 'COMBUCTOR_SET_REMOVE', 'UpdateSets')

	CSet:RegisterMessage(self, 'COMBUCTOR_CONFIG_SET_ADD', 'UpdateSetConfig')
	CSet:RegisterMessage(self, 'COMBUCTOR_CONFIG_SET_REMOVE', 'UpdateSetConfig')

	CSet:RegisterMessage(self, 'COMBUCTOR_SUBSET_ADD', 'UpdateSubSets')
	CSet:RegisterMessage(self, 'COMBUCTOR_SUBSET_UPDATE', 'UpdateSubSets')
	CSet:RegisterMessage(self, 'COMBUCTOR_SUBSET_REMOVE', 'UpdateSubSets')

	CSet:RegisterMessage(self, 'COMBUCTOR_CONFIG_SUBSET_ADD', 'UpdateSubSetConfig')
	CSet:RegisterMessage(self, 'COMBUCTOR_CONFIG_SUBSET_REMOVE', 'UpdateSubSetConfig')
end

function FrameEvents:UpdateSets(msg, name)
	for f in self:GetFrames() do
		if f:HasSet(name) then
			f:UpdateSets()
		end
	end
end

function FrameEvents:UpdateSetConfig(msg, key, name)
	for f in self:GetFrames() do
		if f.key == key then
			f:UpdateSets()
		end
	end
end

function FrameEvents:UpdateSubSetConfig(msg, key, name, parent)
	for f in self:GetFrames() do
		if f.key == key and f:GetCategory() == parent then
			f:UpdateSubSets()
		end
	end
end

function FrameEvents:UpdateSubSets(msg, name, parent)
	for f in self:GetFrames() do
		if f:GetCategory() == parent then
			f:UpdateSubSets()
		end
	end
end


function FrameEvents:Register(f)
	frames[f] = true
end

function FrameEvents:Unregister(f)
	frames[f] = nil
end

function FrameEvents:GetFrames()
	return pairs(frames)
end

FrameEvents:Load()
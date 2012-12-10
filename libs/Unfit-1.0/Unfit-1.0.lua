--[[
Copyright 2011-2012 João Cardoso
Unfit is distributed under the terms of the GNU General Public License (or the Lesser GPL).
This file is part of Unfit.

Unfit is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

Unfit is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with Unfit. If not, see <http://www.gnu.org/licenses/>.
--]]
local function err(msg,...) geterrorhandler()(msg:format(tostringall(...)) .. " - " .. time()) end

local Lib = LibStub:NewLibrary('Unfit-1.0', 4)
if not Lib then
	return
else
	Lib.unusable = Lib.unusable or {}
end


--[[ Data ]]--

local _, Class = UnitClass('player')

if Class == 'DEATHKNIGHT' then
	Lib.unusable = {{3, 4, 10, 11, 13, 14, 15, 16}, {6}} -- weapons, armor, dual wield
elseif Class == 'DRUID' then
	Lib.unusable = {{1, 2, 3, 4, 8, 9, 14, 15, 16}, {4, 5, 6}, true}
elseif Class == 'HUNTER' then
	Lib.unusable = {{5, 6, 16}, {5, 6}}
elseif Class == 'MAGE' then
	Lib.unusable = {{1, 2, 3, 4, 5, 6, 7, 9, 11, 14, 15}, {3, 4, 5, 6}, true}
elseif Class == 'MONK' then
	Lib.unusable = {{2, 3, 4, 6, 9, 13, 14, 15, 16}, {4, 5, 6}}
elseif Class == 'PALADIN' then
	Lib.unusable = {{3, 4, 10, 11, 13, 14, 15, 16}, {}, true}
elseif Class == 'PRIEST' then
	Lib.unusable = {{1, 2, 3, 4, 6, 7, 8, 9, 11, 14, 15}, {3, 4, 5, 6}, true}
elseif Class == 'ROGUE' then
	Lib.unusable = {{2, 6, 7, 9, 10, 16}, {4, 5, 6}}
elseif Class == 'SHAMAN' then
	Lib.unusable = {{3, 4, 7, 8, 9, 14, 15, 16}, {5}}
elseif Class == 'WARLOCK' then
	Lib.unusable = {{1, 2, 3, 4, 5, 6, 7, 9, 11, 14, 15}, {3, 4, 5, 6}, true}
elseif Class == 'WARRIOR' then
	Lib.unusable = {{16}, {}}
end
local Unusable = Lib.unusable

for class = 1, 2 do
	local subs = {GetAuctionItemSubClasses(class)}
	for i, subclass in ipairs(Unusable[class]) do
		if not subclass or not subs[subclass] then
			err("subclass = %s, class = %s, i = %s",subclass,class,i)
		end
		Unusable[subs[subclass]] = true
	end
		
	Unusable[class] = nil
	subs = nil
end

--TTT = Unusable


--[[ API ]]--

function Lib:IsItemUnusable(...)
	if ... then
		local subclass, _, slot = select(7, GetItemInfo(...))
		return Lib:IsClassUnusable(subclass, slot)
	end
end

function Lib:IsClassUnusable(subclass, slot)
	if subclass then
		return Unusable[subclass] or slot == 'INVTYPE_WEAPONOFFHAND' and Unusable[3]
	end
end
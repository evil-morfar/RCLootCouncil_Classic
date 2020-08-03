--- WoW APIs available in retail that's no longer available or changed in Classic
function RCLootCouncil.Utils.GetNumClasses ()
	return _G.MAX_CLASSES
end

function GetNumSpecializationsForClassID (classID) -- REVIEW: Needed?
   -- All classes have 3 specs
   return 3
end

function GetClassInfo (classID) -- REVIEW: Needed?
   local info = C_CreatureInfo.GetClassInfo(classID)
   if info then
      return info.className, info.classFile, info.classID
   end
   return nil
end

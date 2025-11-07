tell application "QLab"
	set userGroupCueNumber to "FOLD001" -- Q number da Folder
	set userOverlap to -1 -- Overlap: tempo antes do final do áudio para o próximo iniciar
	
	tell front workspace
		set theGroupCue to cue userGroupCueNumber
		set countCues to count cues of theGroupCue
		
		-- Embaralhar: mover randomicamente os cues pra dentro da própria folder
		repeat countCues times
			set eachCueID to uniqueID of some item of items 1 thru -1 of (cues of theGroupCue as list)
			move cue id eachCueID of theGroupCue to end of theGroupCue
		end repeat
		
		-- Ajustar ordem e lógica de continuação
		set shuffledCues to cues of theGroupCue
		repeat with i from 1 to countCues
			set eachCue to item i of shuffledCues
			
			if i is not countCues then
				-- Para todos os cues, exceto o último
				set post wait of eachCue to (duration of eachCue) + userOverlap
				set continue mode of eachCue to auto_follow
			else
				-- Para o último: não continuar
				set post wait of eachCue to 0
				set continue mode of eachCue to do_not_continue
			end if
		end repeat
		
		-- Tocar a Folder (ela vai seguir a ordem embaralhada com auto-follow)
		start theGroupCue
	end tell
end tell

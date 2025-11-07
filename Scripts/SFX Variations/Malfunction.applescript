tell application id "com.figure53.QLab.4"
	tell front workspace
		repeat
			set staticCue to cue "AMB999"
			
			if staticCue exists then
				-- Delay aleatório entre 0 e 0.6s antes do play
				set delayBeforePlay to (random number from 0 to 2000) / 1000
				delay delayBeforePlay
				
				start staticCue
				
				-- Delay aleatório entre 0 e 1.2s antes do stop
				set delayBeforeStop to (random number from 0 to 500) / 1000
				delay delayBeforeStop
				
				stop staticCue
			else
				display dialog "? Cue 'AMB999' not found." buttons {"OK"} default button "OK"
				exit repeat
			end if
		end repeat
	end tell
end tell


--Repetição aleatoria de um cue especifico
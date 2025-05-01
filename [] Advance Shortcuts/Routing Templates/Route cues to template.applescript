-- @description Route tracks to template
-- @author Ben Smith
-- @link bensmithsound.uk
-- @version 2.2
-- @testedmacos 10.14.6
-- @testedqlab 4.0.8
-- @about Routes the selected audio track/s the same as a selected template cue
-- @separateprocess TRUE

-- @changelog
--   v2.2  + Agregate Route click tracks to channels, Route Soundcheck tracks to template, Set crosspoints to template and Set gangs to template to one script
--   v2.1  + will now correctly route audio if it is ganged differently to the routing option
--   v2.0  + moved common functions to external script
--   v1.4  + works with videos as well
--   v1.3  + allows assignment of UDVs from the script calling this one
--   v1.2  + added option to turn off renaming cues
--         + added error catching
--   v1.1  + takes number of output channels from the notes of cues, to streamline editing for new projects


-- QLab Router Consolidado - Seleção de comportamento via menu dropdown

try
	renameCues
on error
	set renameCues to false
end try

try
	variableCueListName
on error
	set variableCueListName to "Other scripts & utilities"
end try

try
	templateCueListName
on error
	set templateCueListName to "Other scripts & utilities"
end try

try
	templateGroupCueName
on error
	set templateGroupCueName to "Routing templates"
end try

-- Opções disponíveis
set optionsList to {"Route Levels Gangs All", "Route Levels Skip Master", "Route Levels Skip Outputs", "Route Levels Skip Inputs + Master", "Route Levels Skip Crosspoints"}
set selectedOptionList to choose from list optionsList with prompt "Selecione o tipo de roteamento:"
if selectedOptionList is false then return
set selectedOption to item 1 of selectedOptionList

-- Flags de controle
set skipMaster to false
set skipInputs to false
set skipOutputs to false
set skipCrosspoints to false

if selectedOption is "Route Levels Skip Master" then
	set skipMaster to true
else if selectedOption is "Route Levels Skip Outputs" then
	set skipOutputs to true
else if selectedOption is "Route Levels Skip Inputs + Master" then
	set skipInputs to true
	set skipMaster to true
else if selectedOption is "Route Levels Skip Crosspoints" then
	set skipInputs to true
end if

tell application id "com.figure53.Qlab.4" to tell front workspace
	
	set audioChannelCount to (notes of (first cue of (first cue list whose q name is variableCueListName) whose q name is "Output channel count")) as integer
	set rowCount to (notes of (first cue of (first cue list whose q name is variableCueListName) whose q name is "Row count")) as integer
	
	set templateList to (first cue list whose q name is templateCueListName)
	set templateGroupCue to first cue in templateList whose q name is templateGroupCueName
	set availableTemplates to cues in templateGroupCue
	set templateNames to {}
	repeat with c in availableTemplates
		set end of templateNames to (q name of c)
	end repeat
	
	set selectedTemplateName to choose from list templateNames with prompt "Selecione o cue de TEMPLATE:"
	if selectedTemplateName is false then return
	set templateCue to first cue in templateGroupCue whose q name is selectedTemplateName
	
	set selectedCues to (selected as list)
	repeat with eachCue in selectedCues
		if q type of eachCue is in {"Audio", "Video"} then
			
			-- remover todos os gangs antes de aplicar os níveis
			repeat with rowIndex from 0 to rowCount - 1
				repeat with colIndex from 0 to audioChannelCount
					try
						setGang eachCue row rowIndex column colIndex gang ""
					on error
						-- ignorar
					end try
				end repeat
			end repeat
			
			-- aplicar níveis conforme opção escolhida
			repeat with rowIndex from 0 to rowCount - 1
				repeat with colIndex from 0 to audioChannelCount
					set skipLevel to false
					
					if skipMaster and rowIndex is equal to 0 and colIndex is equal to 0 then
						set skipLevel to true
					else if skipInputs and rowIndex ≥ 1 then
						set skipLevel to true
					else if skipOutputs and rowIndex is equal to 0 and colIndex ≥ 1 then
						set skipLevel to true
					else if skipInputs and rowIndex ≥ 1 then
						set skipLevel to true
					end if
					
					if not skipLevel then
						try
							set theLevel to getLevel templateCue row rowIndex column colIndex
							setLevel eachCue row rowIndex column colIndex db theLevel
						on error
							-- ignorar
						end try
					end if
				end repeat
			end repeat
			
			-- aplicar gangs após os níveis
			repeat with rowIndex from 0 to rowCount - 1
				repeat with colIndex from 0 to audioChannelCount
					try
						set theGang to getGang templateCue row rowIndex column colIndex
						if theGang is not missing value then
							setGang eachCue row rowIndex column colIndex gang theGang
						end if
					on error
						-- ignorar
					end try
				end repeat
			end repeat
			
			-- renomeia se ativado
			if renameCues is true then
				try
					set oldName to q display name of eachCue
					set text item delimiters to " | "
					set baseName to text item 1 of oldName
					set text item delimiters to ""
					set newName to baseName & " | " & selectedTemplateName
					set q name of eachCue to newName
				on error
					-- ignorar renomeação
				end try
			end if
		end if
	end repeat
end tell

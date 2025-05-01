-- @description Import all script to user library
-- @author Ben Smith
-- @link bensmithsound.uk
-- @version 2.2
-- @testedmacos 10.15.7
-- @testedqlab 4.0.8
-- @about Run this script in MacOS's "Script Editor" to import all scripts in a folder (including within subfolders) to the user's "Library/Script Libraries"
-- @separateprocess TRUE

-- @changelog
--   v2.2  + fix compile all scripts from github, organize scripts inside folders.
--   v2.1  + can install specific versions of the library from github, and notes the version if launched in Qlab.
--   v2.0  + can now optionally import scripts directly from github
--   v1.3  + add default location when choosing a folder
--   v1.2  + creates "Script Libraries" folder if it doesn't already exist


use AppleScript version "2.4" -- Yosemite (10.10) or later
use framework "Foundation"
use scripting additions

property githubRepoURL : "https://github.com/antoniondc/Qlab-Scripts.git"
property gitVersionToGet : "latest" -- "latest" or specific tag

-- HFS path for Notes display
property baseCompiledFolder : (path to library folder from user domain as text) & "Script Libraries:QLab:"
-- POSIX path for file operations
property posixBaseCompiledFolder : POSIX path of (path to library folder from user domain) & "Script Libraries/QLab/"

property totalCount : 0
property successCount : 0
property failCount : 0
property failedFiles : {}

-- 🧹 Reset counters
on resetCounters()
	set totalCount to 0
	set successCount to 0
	set failCount to 0
	set failedFiles to {}
end resetCounters

-- 📁 Create folder (accepts HFS or POSIX)
on makeFolder(pathStr)
	-- Determine POSIX folder
	if pathStr begins with "/" then
		set posixFolder to pathStr
	else
		set posixFolder to POSIX path of pathStr
	end if
	-- Use NSFileManager
	set fm to current application's NSFileManager's defaultManager()
	set errRef to missing value
	set ok to fm's createDirectoryAtPath:posixFolder withIntermediateDirectories:true attributes:(missing value) |error|:(errRef)
	if not ok then
		set errMsg to (errRef's localizedDescription() as text)
		log "❌ Failed to create folder: " & pathStr & " — " & errMsg
	end if
end makeFolder

-- 🔍 Get base name, stripping extension
on nameFromPath(pathStr)
	set AppleScript's text item delimiters to "/"
	set nameItems to text items of pathStr
	set fileNameExt to item -1 of nameItems
	set AppleScript's text item delimiters to ""
	set AppleScript's text item delimiters to "."
	set nameParts to text items of fileNameExt
	if (count of nameParts) > 1 then
		set baseName to (items 1 thru -2 of nameParts) as text
	else
		set baseName to fileNameExt
	end if
	set AppleScript's text item delimiters to ""
	return baseName
end nameFromPath

-- 📜 Compile one .applescript into .scpt, preserving relative tree
on compileScript(sourcePath, baseSourceFolderPOSIX)
	set fileName to nameFromPath(sourcePath)
	set totalCount to totalCount + 1
	
	-- Compute POSIX-relative subfolder from baseSourceFolder
	try
		-- strip trailing slash for sed prefix match
		set baseNoSlash to baseSourceFolderPOSIX
		if baseNoSlash ends with "/" then set baseNoSlash to text 1 thru -2 of baseNoSlash
		set findCmd to "cd " & quoted form of baseSourceFolderPOSIX & " && dirname " & quoted form of sourcePath & " | sed 's|^" & baseNoSlash & "||;s|^/||'"
		set relativePath to do shell script findCmd
	on error
		set relativePath to ""
	end try
	
	-- Build full POSIX target folder
	set compiledTargetPOSIX to posixBaseCompiledFolder
	if relativePath is not "" then
		set compiledTargetPOSIX to compiledTargetPOSIX & relativePath & "/"
	end if
	makeFolder(compiledTargetPOSIX)
	
	-- Compile to .scpt
	set targetFilePOSIX to compiledTargetPOSIX & fileName & ".scpt"
	set targetPathQuoted to quoted form of targetFilePOSIX
	try
		do shell script "/usr/bin/osacompile -o " & targetPathQuoted & " " & quoted form of sourcePath
		set successCount to successCount + 1
	on error errMsg
		set failCount to failCount + 1
		set end of failedFiles to fileName
		log "❌ Compilation failed for " & fileName & ": " & errMsg
	end try
end compileScript

-- 🔄 Recursively compile all .applescript, skipping .git directories
on compileAllFrom(folderPathPOSIX)
	set findCmd to "find " & quoted form of folderPathPOSIX & " -path '*/.git*' -prune -o -name '*.applescript' -print"
	set scriptList to paragraphs of (do shell script findCmd)
	repeat with scriptPath in scriptList
		if scriptPath is not "" then my compileScript(scriptPath, folderPathPOSIX)
	end repeat
end compileAllFrom

-- ▶️ Main
try
	delay 0.1
	resetCounters()
	
	-- Choose source
	set userChoice to button returned of (display dialog "Install from GitHub or local folder?" buttons {"GitHub", "Local", "Cancel"} default button "GitHub")
	if userChoice is "Local" then
		set sourceFolderPOSIX to POSIX path of (choose folder with prompt "Select folder containing AppleScript files:")
	else if userChoice is "GitHub" then
		-- Ensure git exists
		try
			do shell script "which git"
		on error
			display dialog "Git is not installed or not in PATH." buttons {"OK"} default button "OK"
			error "Git not available"
		end try
		
		-- Clone repo
		set tempClonePOSIX to POSIX path of (path to home folder) & "qlab-scripts-temp/"
		do shell script "rm -rf " & quoted form of tempClonePOSIX
		if gitVersionToGet is "latest" then
			do shell script "git clone --depth 1 " & githubRepoURL & " " & quoted form of tempClonePOSIX
		else
			do shell script "git clone --branch " & gitVersionToGet & " --single-branch " & githubRepoURL & " " & quoted form of tempClonePOSIX
		end if
		set sourceFolderPOSIX to tempClonePOSIX
	end if
	
	-- Prepare target
	makeFolder(baseCompiledFolder)
	display notification "🚀 Compiling QLab scripts…" with title "QLab Sync"
	compileAllFrom(sourceFolderPOSIX)
	
	-- Git metadata: rename cue & update notes
	if userChoice is "GitHub" then
		try
			set versionTag to do shell script "cd " & quoted form of sourceFolderPOSIX & " && git describe --tags"
			tell application id "com.figure53.QLab.4"
				tell front workspace
					set sel to selected as list
					if (count of sel) > 0 then
						set lastCue to last item of sel
						if q type of lastCue is "Script" then
							-- Rename
							set currentName to q display name of lastCue
							if currentName contains "|" then
								set AppleScript's text item delimiters to "|"
								set currentName to last text item of currentName
								set AppleScript's text item delimiters to ""
							end if
							set q name of lastCue to versionTag & " installed | " & currentName
							-- Append notes
							try
								set oldNotes to notes of lastCue
							on error
								set oldNotes to ""
							end try
							set newNotes to "GitHub: " & githubRepoURL & return & "Install Dir: " & baseCompiledFolder & return & oldNotes
							set notes of lastCue to newNotes
						end if
					end if
				end tell
			end tell
		on error errMsg
			log "⚠️ Could not rename cue or set notes: " & errMsg
		end try
		-- Clean temp
		try
			do shell script "rm -rf " & quoted form of sourceFolderPOSIX
		on error
			log "⚠️ Could not delete temp folder: " & sourceFolderPOSIX
		end try
	end if
	
	-- Final summary
	set summaryMessage to "📦 Total: " & totalCount & return & "✔️ Success: " & successCount & return & "❌ Failed: " & failCount
	if failCount > 0 then
		set AppleScript's text item delimiters to " | "
		set failedListStr to failedFiles as text
		set AppleScript's text item delimiters to ""
		display dialog summaryMessage & return & return & "Failed Files: " & failedListStr buttons {"OK"} default button "OK"
	else
		display notification summaryMessage with title "QLab Import Summary"
	end if
on error errMsg
	display dialog "❌ Error during sync: " & errMsg buttons {"OK"} default button "OK"
end try

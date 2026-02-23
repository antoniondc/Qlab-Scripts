-- Example configuration for this script
-- set VAR_NAME to value
set USER_APP to "Spotify" -- (Spotify, TIDAL, VLC, iTunes, Music)
set USER_MODE to "complete" --(simple, complete)
set ACTION_TO_PERFORM to "Toggle" --(Play, Pause, Toggle, Next, Previous, Increase Volume, Decrease Volume, Shuffle, Repeat)
--set SPOTIFY_ARG to "spotify:playlist:0vvXsWCC9xrXsKd4FyS8kM" --(ou caminho/url para VLC em openfile/openurl)
set FADE_TIME to 30

set utils to getScriptFromLibrary("Applescript Utilities.scpt")
utils's initGlobals()
run getScriptFromLibrary("Control:Applications:Media player control.scpt")

on getScriptFromLibrary(relativeSubPath)
	return load script file ((path to library folder from user domain as text) & "Script Libraries:Qlab:" & relativeSubPath)
end getScriptFromLibrary

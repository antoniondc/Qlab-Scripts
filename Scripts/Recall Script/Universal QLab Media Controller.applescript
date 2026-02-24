--------------------------------------------------------------------------------
-- Universal QLab Media Controller
--------------------------------------------------------------------------------
set USER_APP to "Spotify" -- (Spotify, TIDAL, VLC, iTunes, Music)
set USER_MODE to "complete" --(simple, complete)
set ACTION_TO_PERFORM to "Toggle" --(Play, Pause, Toggle, Next, Previous, Increase Volume, Decrease Volume, Shuffle, Repeat)
set FADE_TIME to 30 -- duração do fade em segundos
--set SPOTIFY_ARG to "spotify:playlist:0vvXsWCC9xrXsKd4FyS8kM" -- URI/URL (Spotify, VLC file/url)
--set PLAYLIST_NAME to "My Top Rated"
--set ENABLE_EQ to true
--set SHUFFLE_PLAYLIST to false
--set REPEAT_PLAYLIST to false
--set SET_VOLUME to 0 -- volume alvo final 0..100
--set SCRIPT_LANG to "pt"-- "en" ou "pt" para TIDAL menu labels


--------------------------------------------------------------------------------
-- Inicializa as Utilities
--------------------------------------------------------------------------------
set utils to getScriptFromLibrary("Applescript Utilities.scpt")
utils's initGlobals()
run getScriptFromLibrary("Control:Applications:Media player control.scpt")

on getScriptFromLibrary(relativeSubPath)
	return load script file ((path to library folder from user domain as text) & "Script Libraries:Qlab:" & relativeSubPath)
end getScriptFromLibrary


--------------------------------------------------------------------------------
-- Script metadata
--------------------------------------------------------------------------------
property SCRIPT_DESCRIPTION : "Universal media controller for QLab: Spotify, TIDAL, VLC & Music/iTunes. Includes play, pause, next, previous, shuffle, repeat, fade in/out, target volume, playlist start. Native AppleScript for Spotify/Music/VLC, UI scripting for TIDAL. Returns focus to QLab."
property SCRIPT_AUTHOR : "Antonio Nunes"
property SCRIPT_VERSION : "2.6"
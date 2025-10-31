--setup list of performancesTARGET_LIST_NAMETARGET_LIST_NAMETARGET_LIST_NAMETARGET_LIST_NAMETARGET_LIST_NAMETARGET_LIST_NAMETARGET_LIST_NAMETARGET_LIST_NAMETARGET_LIST_NAMETARGET_LIST_NAMETARGET_LIST_NAME
-- author: Micpol
set myCueLists to {"Auto", "Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday mat", "Saturday eve"}
--get day of week and hours of time from system clock
tell application "System Events"
	set thedate to (current date)
	set theday to weekday of thedate
	set thehour to (hours) of thedate
end tell
tell application id "com.figure53.QLab.4" to tell front workspace
	--select performance or Auto Mode
	set selectedCueList to (choose from list myCueLists with title "Show Selector" with prompt "Select which show is today?" default items "Auto")
	if selectedCueList is {"Auto"} then
		--select appropriate cuelist by day
		if theday is Saturday then
			--select appropriate saturday cuelist by time
			if thehour > 17 then
				set userCueList to "Saturday Eve"
			else
				set userCueList to "Saturday Mat"
			end if
		else if theday is Friday then
			set userCueList to "Friday"
		else if theday is Thursday then
			set userCueList to "Thursday"
		else if theday is Wednesday then
			set userCueList to "Wednesday"
		else if theday is Tuesday then
			set userCueList to "Tuesday"
		else if theday is Monday then
			set userCueList to "Monday"
		else if theday is Sunday then
			set userCueList to "Sunday"
			
		end if
	else
		set userCueList to selectedCueList
	end if
	--test for cancel button
	if userCueList is false then
		return
	else
		set current cue list to first cue list whose q name is userCueList
	end if
end tell
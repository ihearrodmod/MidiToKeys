# MidiToKeys

This is a spoon (plugin) for [Hammerspoon](https://www.hammerspoon.org/) on Mac that allows a MIDI device to send keystrokes to an application.
This can be used for virtual pianos, games, etc.

To use, install Hammerspoon and place the MidiToKeys.spoon directory into your Spoons directory

Then add this to your init.lua (can be modified to change hotkeys):
```lua
hs.loadSpoon("MidiToKeys")

spoon.MidiToKeys:bindHotkeys({
	toggle = {{"option", "shift"}, "s"},

	incrementDevice = {{"option", "shift"}, "d"}
})
```

Option + Shift + S will enable/disable the keystroke functionality

Option + Shift + D will change the device being used for input

init.lua inside MidiToKeys.spoon can be modified (through right click -> Show Package Contents) to change the MIDI to keystroke mapping

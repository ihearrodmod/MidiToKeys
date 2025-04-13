-- Hammerspoon configuration to map MIDI keyboard inputs to letter keystrokes

local module = {_deviceIndex = 0}

module.name = "MidiToKeys"
module.version = "0.1"
module.author = "Rodmod"
module.license = "MIT - https://opensource.org/licenses/MIT"

local function sendKeyEvent(key, isDown, mod)
    if mod then
        hs.eventtap.event.newKeyEvent(mod[1], true):post()
        hs.eventtap.event.newKeyEvent(key, isDown):post()
        hs.eventtap.event.newKeyEvent(mod[1], false):post()
    else
        hs.eventtap.event.newKeyEvent(key, isDown):post()
    end
end

local mapping88 = {
    {{"ctrl"}, "1"},
	{{"ctrl"}, "2"},
	{{"ctrl"}, "3"},
	{{"ctrl"}, "4"},
    {{"ctrl"}, "5"},
    {{"ctrl"}, "6"},
    {{"ctrl"}, "7"},
    {{"ctrl"}, "8"},
    {{"ctrl"}, "9"},
    {{"ctrl"}, "0"},
    {{"ctrl"}, "q"},
    {{"ctrl"}, "w"},
    {{"ctrl"}, "e"},
    {{"ctrl"}, "r"},
    {{"ctrl"}, "t"},

    "1",
	{{"shift"}, "1"},
	"2",
	{{"shift"}, "2"},
	"3",
	"4",
    {{"shift"}, "4"},
	"5",
	{{"shift"}, "5"},
	"6",
	{{"shift"}, "6"},
	"7",
	"8",
	{{"shift"}, "8"},
	"9",
	{{"shift"}, "9"},
	"0",
	"q",
	{{"shift"}, "q"},
	"w",
	{{"shift"}, "w"},
	"e",
	{{"shift"}, "e"},
	"r",
	"t",
	{{"shift"}, "t"},
	"y",
	{{"shift"}, "y"},
	"u",
	"i",
	{{"shift"}, "i"},
	"o",
	{{"shift"}, "o"},
	"p",
	{{"shift"}, "p"},
	"a",
	"s",
    {{"shift"}, "s"},
	"d",
	{{"shift"}, "d"},
	"f",
	"g",
	{{"shift"}, "g"},
	"h",
	{{"shift"}, "h"},
	"j",
	{{"shift"}, "j"},
	"k",
	"l",
	{{"shift"}, "l"},
	"z",
	{{"shift"}, "z"},
	"x",
	"c",
	{{"shift"}, "c"},
	"v",
	{{"shift"}, "v"},
	"b",
	{{"shift"}, "b"},
	"n",
	"m",

    {{"ctrl"}, "y"},
	{{"ctrl"}, "u"},
	{{"ctrl"}, "i"},
	{{"ctrl"}, "o"},
	{{"ctrl"}, "p"},
	{{"ctrl"}, "a"},
	{{"ctrl"}, "s"},
	{{"ctrl"}, "d"},
	{{"ctrl"}, "f"},
	{{"ctrl"}, "g"},
	{{"ctrl"}, "h"},
	{{"ctrl"}, "j"}
}

function module:_connectMidi()
	self._midiInput = hs.midi.newVirtualSource(hs.midi.virtualSources()[self._deviceIndex + 1])

	self._midiInput:callback(function(object, deviceName, commandType, description, metadata)

		if metadata.note then
			local mapping = mapping88[metadata.note-20]
			if commandType == "noteOn" then
				if type(mapping) == "table" then
					sendKeyEvent(mapping[2], true, mapping[1])
				else
					sendKeyEvent(mapping, true)
				end
				
			elseif commandType == "noteOff" then
				if type(mapping) == "table" then
					sendKeyEvent(mapping[2], false, mapping[1])
				else
					sendKeyEvent(mapping, false)
				end
			end
		end
		
	end)
end


function module:start()
	if not self._midiInput then
		if #hs.midi.virtualSources() < 1 then
			hs.alert.show("No MIDI device found")
			return
		end

		self:_connectMidi()

		hs.alert.show("MIDI to Keystroke Enabled")
	end
end

function module:stop()
	if self._midiInput then
		self._midiInput:callback(nil)

		self._midiInput = nil

		hs.alert.show("MIDI to Keystroke Disabled")
	end
end

function module:toggle()
	if not self._midiInput then
		self:start()
	else
		self:stop()
	end
end

function module:incrementDevice()
	local devices = hs.midi.virtualSources()
	if #devices > 0 then
		self._deviceIndex = (self._deviceIndex + 1) % #devices

		if self._midiInput then
			self._midiInput:callback(nil)
		end
		
		self:_connectMidi()

		hs.alert.show("Enabled MIDI to Keystroke on " .. devices[self._deviceIndex + 1])
	else
		hs.alert.show("No MIDI device found")
	end
end

function module:bindHotkeys(mapping)
  local spec = {
    start = hs.fnutils.partial(self.start, self),
    stop = hs.fnutils.partial(self.stop, self),

	toggle = hs.fnutils.partial(self.toggle, self),

	incrementDevice = hs.fnutils.partial(self.incrementDevice, self)
  }
  hs.spoons.bindHotkeysToSpec(spec, mapping)
  return self
end

return module

local yard = "BY" -- change on a per-yard basis
local y = yard
--arrow points towards yard

if event.train then
	if not S[y].yard_active then return end -- train using yard under NOSHUNT
	-- train using headshunt to shunt
	if atc_arrow then set_autocouple() end
end
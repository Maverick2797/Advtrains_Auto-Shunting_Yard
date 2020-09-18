local yard = "BY" --change yard id on per-yard basis
dir = "N" --change on per-end basis
inv_dir = "S" --change on per-end basis
local clockspeed = 5
y = yard


local check_yard_active = function(yard_active,clockspeed)
	if not atc_id then return end
	if yard_active == true then
		atc_send("B0S0")
		atc_set_text_outside("Waiting for yard to clear")
		atc_set_text_inside("Waiting for yard to clear")
		interrupt(clockspeed,"check_active")
		return
	else
		--yard entry procedure
		--save train info
		S[y].rc = get_rc() or ""
		S[y].line = get_line() or ""
		S[y].yard_active = true
		
		atc_set_text_outside("Auto-Shunting Active")
		atc_set_text_inside("Auto-Shunting Active")
		set_route(y..dir.."ENTRY","PICKUP")
		
		if S[y].rc:match(y.."RTS") == true or S[y].single_dir then
			S[y].RTS = true
			S[y].dir = inv_dir
		else
			S[y].dir = dir
		end
		atc_send("S3")
		return
	end
end

if event.train then
	local rc =  get_rc() or ""
	if rc:match(yard.."NOSHUNT") then
		--need to decide how to proceed here
		return
	else
		check_yard_active(S[y].yard_active,clockspeed)
	end
end

if event.int then
	check_yard_active(S[y].yard_active,clockspeed)
end
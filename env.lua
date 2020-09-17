F.pickup = function(yard,dir,lane)
	local y = yard
	if S[y].yard_active then
		if atc_arrow then
			if S[y].dir == dir then
				set_route(yard..dir.."_"..lane, "HEADSHUNT")
				local plen = train_length()
				local rc = split_at_fc("B0")
				local trc = yard..dir.."_"..rc
				if plen == train_length() and (rc == "" or S[y].rc:match(trc)) then
					S[y].exiting = true
				end
				if rc and rc ~= "" then
					set_rc(yard..dir.."_"..rc)
				else
					set_rc(S[y].rc)
					S[y].exiting = true
				end
			else -- if S[y].dir ~= dir
				if S[y].RTS then -- loop around to other HS
					S[y].RTS = nil
					set_route(yard..dir.."_"..lane,"AROUND")
					split_off_locomotive("B0")
					set_rc("AROUND_"..S[y].dir)
					return
				else
					atc_send("B0WRS4")
				end
			end
		end -- nothing to do if train goes against arrow
	end
end

F.EOL = function(yard,dir,lane)
	local y = yard
	if S[y].yard_active then
		if S[y].dir == dir then
			if atc_arrow then
				if not S[y].exiting then
				--return to PICKUP via headshunt
				split_off_locomotive("B0")
				set_rc("PICKUP")
				set_route(yard..dir.."_"..lane, "HEADSHUNT")
				
				else
				--if S[y].exiting then loco has already sorted to correct lane for departure
				--S[y].exiting set by the pickup track
				set_rc(S[y].rc)
				set_route(yard..dir.."_"..lane, "EXIT")
				S[y].exiting = nil
				end
			end
		else -- EOL Bounce
			atc_send("B0WD1RS4")
		end
	end
end
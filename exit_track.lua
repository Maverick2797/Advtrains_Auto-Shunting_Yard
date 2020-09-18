local yard = "yard_id"
y = yard

if event.train then
	if atc_arrow then
		if S[y].exiting then
			if S[y].rc then set_rc(S[y].rc) end
			if S[y].line then set_line(S[y].line) end
		end
	end
end
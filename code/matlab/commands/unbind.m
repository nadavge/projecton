function unbind
    % Send an unbind command
    global s;
	if ~isempty(s),
		fprintf(s, 'u');
		fclose(s);
		delete(s);
	end
end
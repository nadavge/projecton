function unbind
    % Send an unbind command
    global s;
	if ~isempty(s),
		fprintf(s, '%s', 'u');
		fclose(s);
		delete(s);
	end
end
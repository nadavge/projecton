function check_version(teensy_version)
    global s;
	
	version = '0.3.0';
	
	if ~strcmp(version, teensy_version),
		fprintf(2, ['Teensy and matlab versions don''t match!\n  Teensy: ' teensy_version '\n  Matlab: ' version '\n']);
		fprintf(2, '\nUnbinding...\n');
		unbind;
	end

end
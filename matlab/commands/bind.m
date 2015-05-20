function bind(com_port)
    BAUD_RATE = 12000000;
	global buffer fs s mop_enabled;
	
	% Default com port for teensy
	if ~exist('com_port'),
		display('Using def. port (3)')
		com_port = 3;
	end
	
	mop_enabled = 0;
    buffer = [];
    fs = 0;

    s = serial(strcat('COM', num2str(com_port)),'BaudRate',BAUD_RATE);
    s.BytesAvailableFcnMode = 'terminator';
    s.Terminator = 13; % New line character
    s.BytesAvailableFcn = @serial_callback;
    % 20000 > (2 Hex digits) 2.5 * BUFF_SIZE (9000) 
    s.InputBufferSize = 20000;
    fopen(s);
    % Send a bind command
    fprintf(s, 'b');
end
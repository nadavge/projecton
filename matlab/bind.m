BAUD_RATE = 115200;
s = serial('COM12','BaudRate',BAUD_RATE);
s.BytesAvailableFcnMode = 'terminator';
s.Terminator = 13; % New line character
s.BytesAvailableFcn = @serial_callback;
% 8192 > (2 Hex digits + space) 3 * BUFF_SIZE 
s.InputBufferSize = 8192;
fopen(s);
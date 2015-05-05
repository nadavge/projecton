BAUD_RATE = 115200;
s = serial('COM12','BaudRate',BAUD_RATE);
s.BytesAvailableFcnMode = 'terminator';
s.Terminator = 13; % New line character
s.BytesAvailableFcn = @serial_callback;
% 20000 > (2 Hex digits) 2.5 * BUFF_SIZE (9000) 
s.InputBufferSize = 20000;
fopen(s);
% Ack on bind
fprintf(s, '1');
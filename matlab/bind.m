BAUD_RATE = 115200;
s = serial('COM12','BaudRate',BAUD_RATE);
s.BytesAvailableFcnMode = 'terminator';
s.Terminator = 13; % New line character
s.BytesAvailableFcn = @serial_callback;
fopen(s);
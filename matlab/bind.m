BAUD_RATE = 115200;
s = serial('COM12','BaudRate',BAUD_RATE);
s.BytesAvailableFcnMode = 'terminator';
s.BytesAvailableFcn = @serial_callback;
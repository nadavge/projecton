function serial_callback(obj, event)
%SERIAL_CALLBACK Summary of this function goes here
%   Detailed explanation goes here
    display(fscanf(obj));
    display(event.Data);
    %fopen(s);
    %display fscanf(s)
    %fclose(s);
end


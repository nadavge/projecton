function [ num ] = hex32dec( hex )
%HEX32DEC Transform hex repr of 32 bit int to 32 bit int
    num = typecast(uint32(hex2dec(hex)), 'int32');
end


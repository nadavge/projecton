function [ num ] = hex32dec( data )
%HEX32DEC Transform hex repr of 32 bit int to 32 bit int
    num = double(typecast(uint32(hex2dec(data)), 'int32'));
end


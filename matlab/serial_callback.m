function serial_callback(obj, event)
%SERIAL_CALLBACK Summary of this function goes here
%   Detailed explanation goes here
    CODE_IDX = 1:2;
    DATA_START = 4;
    LINE_FEED = 10;
    
    raw_data = fscanf(obj);
    % Remove line feed if exists
    if uint8(raw_data(1)) == LINE_FEED,
        raw_data = raw_data(2:end);
    end
    
    code = raw_data(CODE_IDX);
    data = raw_data(DATA_START:end);
    
    display(code);
    display(data);
    
    if strcmp(code, 'B1'),
       A = zeros(length(data)/2, 1);
       i = 1;
       j = 1;
       while i < length(data),
          a = data(i:i+1);
          i = i + 2;
          A(j) = hex2dec(a);
          j = j + 1;
       end
       
    end
end


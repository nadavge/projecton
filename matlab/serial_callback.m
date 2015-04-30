function serial_callback(obj, event)
%SERIAL_CALLBACK Summary of this function goes here
%   Detailed explanation goes here
	CODE_MIC_READ= 'B\d+';
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
    
    if regexp(code,CODE_MIC_READ),
		mic_read(code(2), data); 
    end
end


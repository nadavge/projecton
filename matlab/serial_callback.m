function serial_callback(serial, event)
%SERIAL_CALLBACK Summary of this function goes here
%   Detailed explanation goes here
	CODE_MIC_READ = 'B\d+';
	CODE_EVENT_INDEX = 'EI';
	CODE_FREQUENCY = 'FS';
	CODE_DEBUG = 'DB';
	
    CODE_IDX = 1:2;
    DATA_START = 4;
    LINE_FEED = 10;
	NEW_LINE = 13;
    
    raw_data = fscanf(serial);
    % Remove line feed if exists
    if uint8(raw_data(1)) == LINE_FEED,
        raw_data = raw_data(2:end);
    end
	
	% Remove new line if exists
    if uint8(raw_data(end)) == NEW_LINE,
        raw_data = raw_data(1:end-1);
    end
    
    code = raw_data(CODE_IDX);
    data = raw_data(DATA_START:end);
    
    %display(code);
    %display(data);
    
    if regexp(code,CODE_MIC_READ),
		ack(serial);
		mic_read(code(2), data);
	elseif regexp(code, CODE_EVENT_INDEX),
		handle_event(data);
	elseif regexp(code, CODE_FREQUENCY),
		freq_read(data);
	elseif regexp(code, CODE_DEBUG),
		display(data);
    end
end


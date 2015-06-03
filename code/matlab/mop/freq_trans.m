function new_vec = freq_trans(old_vec, old_fs, new_fs)
% FREQ_TRANS Transform a vector to a new frequency
    
    f_ratio = old_fs/new_fs;
    T = length(old_vec)/old_fs;
    
    new_length = floor(T * new_fs);
    new_vec = zeros(1, new_length);

    for k=1:new_length,
        % Unfloored yet
        m_start = (k-1)*f_ratio + 1;
        m_start_index = floor(m_start);
        m_end = k*f_ratio + 0.9999;
        m_end_index = floor(m_end);
        
        % Create an averaged reading
        new_value = sum(old_vec(m_start_index+1:m_end_index-1));
        
        if (m_start_index ~= m_end_index),
            window_start = (m_start_index+1 - m_start);
            new_value = new_value + window_start*old_vec(m_start_index);
            
            window_end = (m_end - m_end_index);
            new_value = new_value + window_end*old_vec(m_end_index);          
        else
            window = m_end - m_start;
            new_value = new_value + window*old_vec(m_start_index);
        end
        
        new_value = new_value / (m_end - m_start);
        
        new_vec(k) = new_value;
    end
end
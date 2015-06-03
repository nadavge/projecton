function once
    global s;
    
    if ~isempty(s),
        fprintf(s, '%s', 'o');
    end
end
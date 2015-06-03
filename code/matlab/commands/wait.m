function wait
    global s;
    
    if ~isempty(s),
        fprintf(s, '%s', 'w');
    end
end
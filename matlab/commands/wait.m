function wait
    global s;
    
    if ~isempty(s),
        fprintf(s, 'w');
    end
end
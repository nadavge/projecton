function unbind
    % Send an unbind command
    global s;
    fprintf(s, 'u');
    fclose(s);
    delete(s);
end
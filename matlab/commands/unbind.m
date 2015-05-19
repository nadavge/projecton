% Send an unbind command
fprintf(s, 'u');
fclose(s);
delete(s);
clear s;
clear buffer;
clear fs;
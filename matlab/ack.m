function ack( serial )
%ACK send a received your message acknowledgement
	fprintf(serial, '%d', 1);
end
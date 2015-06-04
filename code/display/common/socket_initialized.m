function answer = socket_initialized( sockets_cell, socket_index )
% SOCKET_INITIALIZED Checks wether the socket at socket index was initialized
	answer = length(sockets_cell) >= socket_index &&...
	         ~isempty(sockets_cell{ socket_index });
end

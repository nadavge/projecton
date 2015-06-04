function delete_shot( timer_obj, ~ )
%DELETE_SHOT Deletes the shot printed on figure
%	This needs to be bounded to a timer
	global to_delete;
	
	handlers = to_delete(1:2);
	
	to_delete(1:2) = [];
	
	delete(handlers{1});
	delete(handlers{2});
	
	stop(timer_obj);
	delete(timer_obj);
end

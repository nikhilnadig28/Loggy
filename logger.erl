-module(logger).
-export([start/1, stop/1]).

start(Nodes) ->
	spawn_link(fun() -> init(Nodes) end).
	
stop(Logger) ->
	Logger ! stop.

init(Nodes) ->
	Table = lists:map(fun(X) -> {X, 0} end, Nodes),
	loop([], Table).

loop(SortList, Table) ->
	receive 
		{log, From, Time, Msg} -> 
			% io:format("TIme : ~w~n",[Time]),
			% NewQueue = time:clock(From, Time, Table),
			NewQueue = time:vclock(From, Time, Table), %Vector Time
			SortedPeers = lists:keysort(2, [{From, Time, Msg}] ++ SortList),
			[H | T] = NewQueue,
			{_, Min} = H,
		NextQueue = time:safe(Min, SortedPeers, NewQueue),
		loop(NextQueue, NewQueue);
	stop ->
		ok
	end.



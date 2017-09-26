-module(worker).
-export([start/5, stop/1, peers/2]).

start(Name, Logger, Seed, Sleep, Jitter) ->
	spawn_link(fun() -> init(Name, Logger, Seed, Sleep, Jitter) end).

stop(Worker) -> 
	Worker ! stop.


init(Name, Log, Seed, Sleep, Jitter) ->
	PeerList = [{george, 0}, {john, 0}, {paul, 0}, {ringo, 0}],
	random:seed(Seed, Seed, Seed),
	receive
		{peers, Peers} ->

			loop(Name, Log, Peers, Sleep, Jitter, PeerList);
		stop ->
			ok
	end.


peers(Wrk, Peers) ->
	Wrk ! {peers, Peers}.


loop(Name, Log, Peers, Sleep, Jitter, PeerList) ->
	Wait = random:uniform(Sleep),
	receive
		{msg, Time, Msg} ->
			{UpdatedTime, CurrentNode} = time:peerupdate(Name, Time, PeerList),
			Log ! {log, Name, UpdatedTime, {received, Msg}},
			loop(Name, Log, Peers, Sleep, Jitter, CurrentNode);
		stop ->
			ok;
		Error -> 
			Log ! {log, Name, time, {error, Error}}

	after Wait -> 
			Selected = select(Peers),
			% Time = na,
			{Time, CurrentNode} = time:inc(Name, PeerList), 
			Message = {hello, random:uniform(100)},
			Selected ! {msg, Time, Message},
			jitter(Jitter),
			Log ! {log, Name, Time, {sending, Message}},
			loop(Name, Log, Peers, Sleep, Jitter, CurrentNode)
	end.

select(Peers) ->
	lists:nth(rand:uniform(length(Peers)), Peers).
	jitter(0) ->ok;
	jitter(Jitter) -> timer:sleep(rand:uniform(Jitter)).




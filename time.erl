-module (time).
-export ([zero/0, inc/2, peerupdate/3, merge/2, leq/2, update/3, safe/3]).

zero() ->
	0.
% return the time T incremented by one. Name would be used later
inc(Name, PeerList) ->
	case lists:keyfind(Name, 1, PeerList) of
		{_, Value} ->
			{Value + 1, lists:keyreplace(Name, 1, PeerList, {Name, Value + 1})};

		false -> 
			0

	end.

peerupdate(Name, Time, PeerList) ->
	case lists:keyfind(Name, 1, PeerList) of
		{_, Value} ->
			{merge(Value, Time) + 1, lists:keyreplace(Name, 1, PeerList, {Name, merge(Value, Time)})};

		true -> 
			PeerList

	end.

% returns maximun of the 2 numbers
merge(Ti, Tj) ->
	erlang:max(Ti, Tj).

% if Ti < Tj true. Else, false.
leq(Ti, Tj) ->
	if
		Ti < Tj ->
			true;
		true ->
			false
	end.


%return a clock that has been updated given that we have received a log messgae from
% a node at a given time
update(From, Time, Table) -> 
	case lists:keyfind(From, 1, Table) of
		{_, Value} ->
			lists:keysort(2, lists:keyreplace(From, 1, Table, {From, Time}));
		false ->
			false
	end.
	

%is it safe to log an event that happened at a given time. true or false
safe(Min, SortedPeers, NewQueue) ->
	
	case SortedPeers of
		[{Name, Time, {Action, {Msg,Id}}} | T] = SortedPeers ->
			case Time =< Min of
				true ->
					LogMessage = [{Name, Time, {Action, {Msg, Id}}}],
					log(LogMessage, SortedPeers),
					safe(Min, T, NewQueue);
				false ->
					SortedPeers
			end;
		[] ->
			[]
	end.

log(LogMessage, SortedPeers) ->
	case LogMessage of
			[{From, Time, Msg} | T] ->
				io:format("log : ~w ~w ~p ~n", [From, Time, Msg]),
				io:format("Length : ~w~n",[length(SortedPeers)]),
				log(T, SortedPeers);
			[] ->
				ok
	end.
	

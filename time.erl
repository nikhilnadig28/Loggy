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
			Max = merge(Value, Time),
			{Max + 1, lists:keyreplace(Name, 1, PeerList, {Name, Max})};

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

 %return a clock to keep track of the nodes
 % clock(Nodes, List) ->

 	% lists:foldl(fun(X,AccIn) -> [{X,0}|AccIn] end,[], Nodes).

%return a clock that has been updated given that we have received a log messgae from
% a node at a given time
update(From, Time, Table) -> 
	case lists:keyfind(From, 1, Table) of
		{_, Value} ->
			lists:keysort(2, lists:keyreplace(From, 1, Table, {From, Time}));
		false ->
			false
	end.
	% CurrentNode = lists:keyfind(From, 1, AllNodes),


	% {_, CurrentList} = CurrentNode,
	% case CurrentList of
	%  	[] ->
	%  		NewQueue = lists:keyreplace(From, 1, AllNodes, {From, CurrentList ++ [{Time, Msg}]});
	%  	_ ->
	%  		{OldTime, _} = lists:last(CurrentList),
	%  		case Time > OldTime of
	%  			true ->
	%  				NewQueue = lists:keyreplace(From, 1, Time, {From, CurrentList ++ [{Time, Msg}]});
	%  			false ->
	%  				NewQueue = AllNodes

	%  		end
	%  end,

	%  NewQueue.

%is it safe to log an event that happened at a given time. true or false
safe(Min, SortedPeers, NewQueue) ->
	% case Clock of
	% 	[{Name, Time, {Action, {Msg, Id}}} | T] = Clock ->
	% 		case Time =< MinTime of
	% 			true ->
	% 				Print = [{Name,Time,{Action,{Msg,Id}}}],
	% 				logger:log(Print),
	% 				safeprint(Min,T,Updated);
	% 			false->
	% 				Sorted
	% 		end;
	% 	[]->
	% 		[]
	% end.
	case SortedPeers of
		[{Name, Time, {Action, {Msg,Id}}} | T] = SortedPeers ->
			case Time =< Min of
				true ->
					LogMessage = [{Name, Time, {Action, {Msg, Id}}}],
					log(LogMessage),
					safe(Min, T, NewQueue);
				false ->
					SortedPeers
			end;
		[] ->
			[]
	end.

log(LogMessage) ->
	case LogMessage of
			[{From, Time, Msg} | T] ->
				io:format("log : ~w ~w ~p ~n", [From, Time, Msg]),
				log(T);
			[] ->
				ok
	end.
	

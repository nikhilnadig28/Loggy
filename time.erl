-module (time).
-export ([zero/0, inc/2, merge/2, leq/2, clock/1, update/3, safe/2]).

zero() ->
	0.
% return the time T incremented by one. Name would be used later
inc(Name, T) ->
	[Name, T + 1].

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
 clock(Nodes) ->
 	0.

%return a clock that has been updated given that we have received a log messgae from
% a node at a given time
update(Node, Time, Clock) ->
	0.

%is it safe to log an event that happened at a given time. true or false
safe(Time, Clock) ->
	0.

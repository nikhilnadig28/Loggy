-module (time).
-export ([function/arity]).

zero() ->
	0.
% return the time T incremented by one. Name would be used later
inc(Name, T) ->
	T + 1.

merge(Ti, Tj) ->
	erlang:max(Ti, Tj).

leq(Ti, Tj) ->
	if
		Ti < Tj ->
			true,
		true ->
		false
	end.

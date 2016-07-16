%% @author jani
%% @doc @todo Add description to test.


-module(rest).

%% ====================================================================
%% API functions
%% ====================================================================
-include("/usr/lib/erlang/lib/stdlib-1.17.3/include/qlc.hrl"). 
-include("/usr/lib/yaws/include/yaws_api.hrl"). 
-export([out/1, addAirport/4, handle/2]). 
%-compile(export_all)..



%% ====================================================================
%% Internal functions
%% ====================================================================

-define(RECORD_TYPE, airport). 
-define(RECORD_KEY_FIELD, code).

-record(?RECORD_TYPE,
		{?RECORD_KEY_FIELD, city, country, name }).

out(Arg) ->
	Method = method(Arg),
	io:format("~p:~p ~p Request ~n", 
	[?MODULE, ?LINE, Method]), 
	handle(Method, Arg).

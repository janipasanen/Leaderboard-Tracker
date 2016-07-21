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

method(Arg) ->
	Rec = Arg#arg.req,
	Rec#http_request.method.

convert_to_json(Lines) ->
	Data = [{obj,
		[{airport, Line#RECORD_TYPE.code},
		{airport, Line#RECORD_TYPE.city},
		{airport, Line#RECORD_TYPE.country},
		{airport, Line#RECORD_TYPE.name}]}
	|| Line <- Lines],
	JsonData = {obj, [{data, Data}]},
	rfc4627:encode(JsonData).

addAirport(Code, City, Country, Name) ->
	NewRec = #?RECORD_TYPE{
			  ?RECORD_KEY_FIELD = Code,
			  city = City,
			  country = Country,
			  name = Name},
		io:format("~p:~p Adding Airport ~p~n",
				  [?MODULE, ?LINE, NewRec]),
	Add = fun() ->
				  mnesia:write(NewRec)
		  end,
	{atomic, _Rec} = mnesia:transaction(Add),
	NewRec.

handle('GET', _Arg) -> 
	io:format("~n ~p:~p GET Request ~n", 
			  [?MODULE, ?LINE]),
	Records = do(qlc:q([X || X <- mnesia:table(?RECORD_TYPE)])),
	Json = convert_to_json( Records),
	io:format("~n ~p:~p GET Request Response ~p ~n", [?MODULE, ?LINE, Json]),
	{html, Json};

handle('POST', _Arg) -> 
	{ok, Json, _} = rfc4627:decode(Arg#arg.clidata),
	io:format("~n ~p:~p POST Request ~p~n", 
			  [?MODULE, ?LINE, Json]),
	Airport = rfc4627:get_field(Json, "airport", <<>>),
	City = rfc4627:get_field(Json, "city", <<>>),
	Country = rfc4627:get_field(Json, "country", <<>>),
	Name = rfc4627:get_field(Json, "name", <<>>),
	_Status = addAirport(Airport, City, Country, Name),
	[{status, 201},
	{html, Arg#arg.clidata}];

handle('PUT', Arg) ->
	[IndexValue, _] = string:tokens(Arg#arg.pathinfo), 
	{ok, Json, _} = rfc4627:decode(Arg#arg.clidata),
	io:format("~p:~p PUT Request ~p ~p~n", 
			  [?MODULE, ?LINE, IndexValue, Json]),
	Airport = rfc4627:get_field(Json, "airport", <<>>),
	City = rfc4627:get_field(Json, "city", <<>>),
	Country = rfc4627:get_field(Json, "country", <<>>),
	Name = rfc4627:get_field(Json, "name", <<>>),

	NewRec = #?RECORD_TYPE{
		?RECORD_KEY_FIELD = Airport,
		city = City,
		country = Country,
		name = Name},

	io:format("~p:~p Renaming ~p",
				  [?MODULE, ?LINE, NewRec]),
	ChangeName = fun() ->
			mnesia:delete(
				{?RECORD_KEY_FIELD, IndexValue}),
						mnesia:write(NewRec)
				end,
	{atamic, _Rec} = mnesia:transaction(ChangeName),
	[{status, 200},
	{html, IndexValue}];

handle('DELETE', Arg) ->
	[IndexValue, _] = string:tokens(Arg#arg.pathinfo),
	io:format("~p:~p DELETE request ~p",
		[?MODULE, ?LINE, IndexValue]),

	Delete = fun() ->
		mnesia:delete(
			{?RECORD_KEY_FIELD, IndexValue})
		end,

	Resp = mnesia:transaction(Delete),
	case Resp of
		{atomic, ok} ->
			[{status, 204}];
		{_, Error} ->
			io:format("~p:~p Error ~p ",
				[?MODULE, ?LINE, Error]),
			[{status, 400}
			{html, Error}]
	end;

handle(Method, _) ->
	[{error, "Unknown method " ++ Method},
	{status, 405},
	{header, "Allow: GET, HEAD, POST, PUT, DELETE"}
	].

do(Q) -> 
	F = fun() ->
		qlc:e(Q)
	end,
	{atomic, Value} = mnesia:transaction(F),
	Value.

-module(puzzle12).
-export([run/0]).

readFile(FileName) ->
	{ok, Binary} = file:read_file(FileName),
    [binary_to_list(Bin) || Bin <- binary:split(Binary,<<"\n">>,[global])].

newShipDirection(Facing, Turn) ->
    _Facing = if 
		Facing + Turn >= 360 -> (Facing + Turn) - 360;
	    Facing + Turn < 0 -> 360 - abs(Facing + Turn);
		true -> Facing + Turn
    end.

moveShip(Facing, Instruction) ->
    Move = string:slice(Instruction, 0, 1),
	By = list_to_integer(string:slice(Instruction, 1)),

	case Move of
		"L" -> {newShipDirection(Facing, 0 - By),0,0};
		"R" -> {newShipDirection(Facing, By),0,0};
		"F" -> 
			case Facing of
				0 -> {Facing, By, 0};
				90 -> {Facing, 0, By};
				180 -> {Facing, 0 - By, 0};
				270 -> {Facing, 0, 0 - By}
			end;
		"N" -> {Facing, By, 0};
		"E" -> {Facing, 0, By};
		"S" -> {Facing, 0 - By, 0};
		"W" -> {Facing, 0, 0 - By}
	end.

part1(Data) ->
	ets:insert(position, [{facing, 90}, {verticle, 0}, {horizontal, 0}]),

    lists:foreach(
		fun(Instruction) ->
			{Facing, Verticle, Horizontal} = moveShip(ets:lookup_element(position, facing, 2), Instruction),

			ets:insert(
				position, 
				[
					{facing, Facing}, 
					{verticle, ets:lookup_element(position, verticle, 2) + Verticle}, 
					{horizontal, ets:lookup_element(position, horizontal, 2) + Horizontal}
				]
			)
		end, Data
	),

    abs(ets:lookup_element(position, verticle, 2)) + abs(ets:lookup_element(position, horizontal, 2)).

moveWaypoint(WaypointVerticle, WaypointHorizontal, Turn) ->
    case Turn of
		90 -> {0 - WaypointHorizontal, WaypointVerticle};
		180 -> 
			{_WaypointVerticle, _WaypointHorizontal} = moveWaypoint(WaypointVerticle, WaypointHorizontal, 90),
			moveWaypoint(_WaypointVerticle, _WaypointHorizontal, 90);
		270 -> 
			{_WaypointVerticle, _WaypointHorizontal} = moveWaypoint(WaypointVerticle, WaypointHorizontal, 90),
			{__WaypointVerticle, __WaypointHorizontal} = moveWaypoint(_WaypointVerticle, _WaypointHorizontal, 90),
		    moveWaypoint(__WaypointVerticle, __WaypointHorizontal, 90);
		-90 -> {WaypointHorizontal, 0 - WaypointVerticle};
		-180 ->
			{_WaypointVerticle, _WaypointHorizontal} = moveWaypoint(WaypointVerticle, WaypointHorizontal, -90),
			moveWaypoint(_WaypointVerticle, _WaypointHorizontal, -90);
		-270 ->
			{_WaypointVerticle, _WaypointHorizontal} = moveWaypoint(WaypointVerticle, WaypointHorizontal, -90),
			{__WaypointVerticle, __WaypointHorizontal} = moveWaypoint(_WaypointVerticle, _WaypointHorizontal, -90),
		    moveWaypoint(__WaypointVerticle, __WaypointHorizontal, -90)
	end.

moveShipWithWaypoint(WaypointVerticle, WaypointHorizontal, Instruction) ->
	Move = string:slice(Instruction, 0, 1),
	By = list_to_integer(string:slice(Instruction, 1)),

	case Move of
		"L" -> {moveWaypoint(WaypointVerticle, WaypointHorizontal, 0 - By), 0, 0};
		"R" -> {moveWaypoint(WaypointVerticle, WaypointHorizontal, By), 0, 0};
		"F" -> {{WaypointVerticle, WaypointHorizontal}, By * WaypointVerticle, By * WaypointHorizontal};
		"N" -> {{WaypointVerticle + By, WaypointHorizontal}, 0, 0};
		"E" -> {{WaypointVerticle, WaypointHorizontal + By}, 0, 0};
		"S" -> {{WaypointVerticle - By, WaypointHorizontal}, 0, 0};
		"W" -> {{WaypointVerticle, WaypointHorizontal - By}, 0, 0}
	end.

part2(Data) ->
	ets:insert(position, [{waypoint_verticle, 1}, {waypoint_horizontal, 10}, {ship_verticle, 0}, {ship_horizontal, 0}]),

	lists:foreach(
		fun(Instruction) ->
			{{WaypointVerticle, WaypointHorizontal}, ShipVerticle, ShipHorizontal} = 
				moveShipWithWaypoint(
					ets:lookup_element(position, waypoint_verticle, 2), 
					ets:lookup_element(position, waypoint_horizontal, 2),
					Instruction
				),

			ets:insert(
				position, 
				[
					{waypoint_verticle, WaypointVerticle}, 
					{waypoint_horizontal, WaypointHorizontal},
					{ship_verticle, ets:lookup_element(position, ship_verticle, 2) + ShipVerticle}, 
					{ship_horizontal, ets:lookup_element(position, ship_horizontal, 2) + ShipHorizontal}
				]
			)
		end, Data
	),

    abs(ets:lookup_element(position, ship_verticle, 2)) + abs(ets:lookup_element(position, ship_horizontal, 2)).

run() ->
	Data = readFile("puzzle12[input]"),
	ets:new(position, [set, named_table]),

	io:format("Part 1: ~p~n", [part1(Data)]),
    io:format("Part 2: ~p~n", [part2(Data)]).

#!/usr/bin/env escript

main([File]) ->
    {ok, Bin} = file:read_file(File),
    Val = parse(Bin),
    io:format("~p~n",[length(part1(Val))]).

parse(Bin) when is_binary(Bin) ->
    [list_to_integer(X) || X <- string:tokens(binary_to_list(Bin), "\r\n\t ")].

part1(L) -> lists:reverse(part1(L,[])).

part1([], Acc) -> Acc;
part1([_], Acc) -> Acc;
part1([A,B|T], Acc) when A < B ->
    part1([B|T], [B|Acc]);
part1([A,B|T], Acc) when A > B ->
    part1([B|T], Acc).


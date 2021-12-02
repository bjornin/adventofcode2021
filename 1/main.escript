#!/usr/bin/env escript

main([File]) ->
    {ok, Bin} = file:read_file(File),
    Val = parse(Bin),
    io:format("part1: ~p~n",[part1(Val)]),
    io:format("part2: ~p~n",[part2(Val)]).

parse(Bin) when is_binary(Bin) ->
    [list_to_integer(X) || X <- string:tokens(binary_to_list(Bin), "\n")].

part1(L) -> part1(L,0).
part1([_], Acc) -> Acc;
part1([A,B|T], Acc) when A < B ->
    part1([B|T], Acc+1);
part1([A,B|T], Acc) when A >= B ->
    part1([B|T], Acc).

part2(L) -> part2(L,0).
part2([_,_,_], Acc) -> Acc;
part2([A,B,C,D|T], Acc) when A+B+C < B+C+D ->
    part2([B,C,D|T], Acc+1);
part2([A,B,C,D|T], Acc) when A+B+C >= B+C+D ->
    part2([B,C,D|T], Acc).
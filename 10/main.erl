-module(main).
-compile(export_all).

main() ->
    main(["input.txt"]).

main([File]) ->
    {ok, Bin} = file:read_file(File),
    P = parse(Bin),
    {R, A} = check(P),
    io:format("part1: ~p~n", [A]),
    S = score(R),
    io:format("part2: ~p~n", [S]).
    
parse(Bin) when is_binary(Bin) ->
    [parse_line(X) || X <- string:tokens(binary_to_list(Bin), "\n\r")].

parse_line(B) ->
    [list_to_binary([X]) || X <- B].

check(P) -> check(P, [], 0).
check([], Rest, Acc) -> {Rest, Acc};
check([H|T], Rest, Acc) ->
    try check_line(H) of
        S -> check(T, [S|Rest], Acc)
    catch
        A ->
            check(T, Rest, Acc + A)
    end.

check_line(P) -> check_line(P, []).
check_line([], S) -> lists:reverse(S);
check_line([H|T], [Sh|St]) ->
    if H == <<")">>, Sh =/= <<"(">> -> throw(3);
        H == <<")">> -> check_line(T, St);
        H == <<"]">>, Sh =/= <<"[">> -> throw(57);
        H == <<"]">> -> check_line(T, St);
        H == <<"}">>, Sh =/= <<"{">> -> throw(1197);
        H == <<"}">> -> check_line(T, St);
        H == <<">">>, Sh =/= <<"<">> -> throw(25137);
        H == <<">">> -> check_line(T, St);
        true -> check_line(T,[H|[Sh|St]])
    end;
check_line([H|T], S) ->
    check_line(T, [H|S]).

score(S) -> score(S, []).
score([], Sum) ->
    lists:nth(round(length(Sum)/2),lists:sort(Sum));
score([H|T], Sum) ->
    score(T, [score_line(lists:reverse(H))|Sum]).

score_line(S) -> score_line(S, 0).
score_line([], Sum) -> Sum;
score_line([H|T], Sum) ->
    if H == <<"(">> -> score_line(T, Sum * 5 + 1);
        H == <<"[">> -> score_line(T, Sum * 5 + 2);
        H == <<"{">> -> score_line(T, Sum * 5 + 3);
        H == <<"<">> -> score_line(T, Sum * 5 + 4);
        true -> score_line(T,Sum)
    end.
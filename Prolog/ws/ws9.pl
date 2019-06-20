/* Q1
    same_elements/2
    same_element(L1, L2) holds if:
    - Elems in L1 are in L2
    - Vice versa

    Only work in mode where both lists are ground

*/

members([],_).
members([H|T], L) :- 
    member(H, L),
    members(T,L).

same_elements(L1, L2) :- 
    members(L1, L2),
    members(L2, L1).

/* Q2
    same as previous one, make it Nlog(N)
    in time complexity

    Note that prolog sort removes duplicates
*/

same_elements_log(L1, L2) :- 
    sort(L1, Sorted),
    sort(L2, Sorted).

/* Q3
    times/4
    times(W,X,Y,Z). holds if:
    - All arguments are integers
    - W*X + Y = Z
    - 0 <= Y < |W|

    Works when W and at least on of X and Z are bound to integer
    Deterministic when 3 of 4 args are ground
*/

/* Q4 
    Solve water container problem
    two containers: 5L and 3L. The goal is to get 
    4L water in 5L container.

    fill/1
    fill(To) where To is the capacity of container to fill

    empty/1
    empty(From) where From is capacity of container to empty

    pour/2
    pour(From, To)

    container/1

    Solve this by first define all the possible next operations and their effects
    Bring non-deteministic movement by using Prolog Variables

    It eventually reach the goal, and all the actions after that are don't cares

*/

next(fill(3), [_,B], [3, B]).
next(fill(5), [A,_], [A, 5]). 
next(empty(3), [_,B], [0,B]).
next(empty(5), [A,_], [A,0]).

next(pour(3,5), [A,B], [C,D]) :- 
    (
        A + B > 5 -> 
        C is A - (5-B),
        D is 5;
        C is 0,
        D is B + A
    ).

next(pour(5,3), [A,B], [C,D]) :- 
    (
        A + B > 3 ->
        C is 3,
        D is B - (3-A);
        C is B + A,
        D is 0
    ).


container([_,4], _, _):- 
    print("success").
container(State, History, [Action|Actions]) :- 
    next(Action, State, State_),
    \+ member(State_, History),
    container(State_, [State_|History], Actions).

container(Action) :-
    container([0,0], [], Action).

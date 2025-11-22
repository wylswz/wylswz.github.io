/* Q1
    list_of/2
    list_of(Elt, List) holds if:
    - every element if List equals to Elt

    Works in any mode
*/

list_of(_,[]).
list_of(E, [E|T]) :- 
    list_of(E,T).

/* Q2
    all_same/1
    all_same(List) holds if:
    - All elements are same
*/
all_same([]).
all_same([_]).
all_same([E|[E|T]]) :- 
    all_same([E|T]).

/* Q3
    adjacent/3
    adjacent(E1, E2, List) holds if:
    E1 appear immediately before E2 in List

*/

adjacent(E1, E2, List) :- 
    append(_, [E1, E2|_], List).

/* Q4
    same predicate as Q3, but implement it recursively
*/

adjacent_r(E1, E2, [E1,E2|_]).
adjacent_r(E1, E2, [_|T]) :-
    adjacent_r(E1, E2, T).

/* Q5
    before/3
    before(E1,E2,List) holds if: 
    - E1 occurs before E2 in List

    Solve this recursively.
    If List starts with E1, then we need to make sure 
    E2 is in tail. If not, apply this to tail.
*/
before(E1, E2, [E1|T]) :- 
    member(E2,T).
before(E1, E2, [_|T]) :- 
    before(E1, E2, T).

/* Q6
    tree/3
    tree(L, N, R) represents a tree with label N and left
    sub-tree L and right sub-tree R. Atom empty is Leaf.

    intset_member/2
    intset_member(N, Set) holds if:
    - N is a member of Set
    *Avoid unnecessary recursion by comparing N with label of Set

    intset_insert/3
    intset_insert(N, Set0, Set) where
    Set has N as a member. There should be no duplicated elements
*/
intset_member(N, tree(_,N,_)).
intset_member(N, tree(L,N0,_)) :- 
    N < N0,
    intset_member(N, L).
intset_member(N, tree(_, N0, R)) :- 
    N >= N0,
    intset_member(N,R).

intset_insert(N, empty, tree(empty, N, empty)).
intset_insert(N, tree(L,N,R), tree(L,N,R)).
intset_insert(N, tree(L1,N1,R1), tree(L2,N1,R1)) :-
    N < N1,
    intset_insert(N, L1, L2).
intset_insert(N, tree(L1,N1,R1), tree(L1,N1,R2)) :- 
    N >= N1,
    intset_insert(N, R1, R2).

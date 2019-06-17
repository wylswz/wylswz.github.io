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
*/

same_elements_log(L1, L2) :- 
    sort(L1, Sorted),
    sort(L2, Sorted).

:- ensure_loaded(borders).
:- ensure_loaded(cities).
:- ensure_loaded(countries).
:- ensure_loaded(rivers).

/*
    Q1 borders(X,australia).
    Q2 borders(B, france), borders(B, spain).
    Q3 borders(B, france), borders(B, spain), country(B,_,_,_,_,_,_,_).
    
*/

/* Q4
    country/1 
    country(C) is True if C is a country 
*/
country(A) :- 
    country(A,_,_,_,_,_,_,_).

/* Q5
    larger/2 
    larger(C1, C2) holds when C1 is larger

    country(Country,Region,Latitude,Longitude,
        Area (sqmiles),
        Population,
        Capital,Currency)
*/
larger(C1, C2) :- 
    country(C1,_,_,_,A1,_,_,_),
    country(C2,_,_,_,A2,_,_,_),
    A1 > A2.

/*
    river_country/2 
    river_country(River, Country) holds if:
    - River is a river
    - Country is a country
    - River flows into or outof Country

    country_region/2
    country_region(Country, Region) holds if:
    - Country is a country in Region
*/
river_country(River, Country) :- 
    river(River, L),
    country(Country),
    member(Country, L).

country_region(Country, Region) :- 
    country(Country, Region, _,_,_,_,_,_).

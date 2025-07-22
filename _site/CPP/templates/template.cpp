#include<iostream>

using namespace std;

class my_class {
    public:
    static const int size_type = 12345;
};

template <int Size>
int getSize() {
    return Size;
}

/**
template <typename T>
T::size_type munge(T const &a) {
    T::size_type * i(T::npos);
}
*/


template<typename Base, typename T>
bool instance_of(T t) {
    return std::is_base_of<Base, T>::value;
}



class Pizza {
private:
    bool beef;
    bool tomato;
    bool bake;
public:
    Pizza() {
        beef = 0;
        tomato = 0;
        bake = 0;
    }

    void addTomato() {
        tomato = 1;
    }

    void addBeef() {
        beef = 1;
    }

    void doBake() {
        bake = 1;
    }

    Pizza(Pizza&&) = default;
    Pizza& operator =(Pizza&&) = default;

    void disp() {
        cout << "Beef: "<< beef << "Tomato: " << tomato << "Baked: " << bake <<endl;
    }
};

class Biscuit {
private:
    bool baked;
    bool tomato;

public:
    Biscuit() {
        baked = 0;
    }

    void doBake() {
        baked = 1;
    }

    void addTomato() {
        tomato = 1;
    }


    void disp() {
        cout << "[Biscuit] " <<"Tomato: "<< tomato << "Baked: " << baked << endl;
    }

};

template<typename T>
struct TomatoFoodCreator {
    static T create() {
        T t;
        t.addTomato();
        return t;
    }
};

template<typename T>
struct BeefFoodCreator {
    static T create() {
        T t;
        t.addBeef();
        return t; 
    }
};

template<typename T>
struct Baker {
    static void bake(T& t) {
        t.doBake();
    }
};

template <typename Creator, typename Baker>
struct PizzaFactory {
    static Pizza getPizza() {
        Pizza p = Creator::create();
        Baker::bake(p);
        return p;
    }
}
;

template<template <typename FoodType> class Creator, template <typename FoodType> class Baker>
struct PizzaFactory2
{
    static Pizza getPizza() {
        Pizza p = Creator<Pizza>::create();
        Baker<Pizza>::bake(p);
        return p;
    }
};

template<template <typename FoodType> class Creator , template <typename FoodType> class Baker>
struct BiscuitFactory {
    static Biscuit getBiscuit() {
        Biscuit b = Creator<Biscuit>::create();
        Baker<Biscuit>::bake(b);
        return b;
    }
};


int main() {
    Pizza p = PizzaFactory2<TomatoFoodCreator, Baker>::getPizza();
    p.disp();

    Pizza p2 = PizzaFactory2<BeefFoodCreator, Baker>::getPizza();
    p2.disp();
    
    Biscuit b = BiscuitFactory<TomatoFoodCreator, Baker>::getBiscuit();
    b.disp();
}
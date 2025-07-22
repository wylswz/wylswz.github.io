#include<stdlib.h>
#include<iostream>
using namespace std;


typedef int Integer;

class My_Class {
private:
    int val;
public:
    My_Class(const My_Class& mc) {
        val = mc.val;
    }

    My_Class(My_Class&&) noexcept{};
};

struct Type_Collection {
    typedef int A;
};

template<typename T>
typename std::enable_if<is_integral<T>::value, int>::type func(T val) {
    return 1;
}


int main() {
    cout<<std::rank<int[1][2][3]>::value<<endl;
    remove_const<const int>::type a = 3;

    cout<<"Move constructable: "<<is_move_constructible<My_Class>::value<<endl;
    cout<<"Trivially Move constructable: "<<is_trivially_move_constructible<My_Class>::value<<endl;
    cout<<"No Throw Move constructable: "<<is_nothrow_move_constructible<My_Class>::value<<endl;
}
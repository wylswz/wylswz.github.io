#include<stdlib.h>
#include<iostream>
#include<string.h>
#include<sstream>

using namespace std;

class Movable {

public:
    int *val;

    Movable() {
        val = NULL;
    }

    Movable(int i[5]) {
        val = &i[0];
    }

    Movable(Movable&& that) {
        cout << "rvalref"<<endl;
        val = that.val;
        that.val = NULL;
    } 

    string to_string() {
        stringstream s;
        s << "Movable[val=" <<val[0] << ", " << val[1] << ", " << val[2] << ", " <<val[3] << ", "  << val[4] << "]";
        return s.str();
    }

    Movable& operator= (Movable&& that) noexcept {
        val = that.val;
        that.val = NULL;
        return *this;
    }

    Movable& operator= (Movable& that) = default;

};


int main() {
    int a[5] {1,2,3,4,5};
    Movable m1(a);
    Movable m2 = move(m1);

    cout<<m1.to_string()<<endl;
    cout<<m2.to_string()<<endl;
}
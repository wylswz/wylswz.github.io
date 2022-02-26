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


int get_num() {
    
}


int main() {
    cout<<getSize<3>()<<endl;
    auto f = getSize<45>;
    auto f2 = getSize<43>;

    // Here f is templated function pointer
    cout<<f2()<<endl;
    my_class mc;
    cout<<get_num()<<endl;
    bool is_fp = std::is_floating_point<int>::value;
    int a[1][2][3];

    cout<<is_fp<<endl;
    cout<<std::rank<int[1][2][3]>::value<<endl;
    remove_const<const int>::type a = 3;

}
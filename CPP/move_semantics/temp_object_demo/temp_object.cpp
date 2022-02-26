#include<iostream>

using namespace std;

class My_Class {
private:

public:
    int val;

    My_Class() {
        this -> val = 4;
    }


    My_Class(My_Class&& that) {
        cout<<"moved"<<endl;
        val = that.val;
    }

    My_Class& operator = (My_Class&& that) {
        cout<<"move assigned"<<endl;
        return *this;
    }

};


// const My_Class& get_object() {
//     // initial value of reference to non-const must be an lvalueC/C++(461)
//     return My_Class();
// }


/**
 * @brief Get the object object
 * 
 * a reference to temp object is returned
 * recap: What is a reference in C++? 
 * 
 * @return const My_Class& 
 */
My_Class get_object() {
    return My_Class();
}

/**
 * @brief Get the object by copying temp value object
 * 
 * Temporary value is copied and returned
 * 
 * @return My_Class 
 */
My_Class get_object_by_copying_temp_value() {
    return My_Class();
}



int main() {
    My_Class obj2 = get_object();

    return 0;
}


#include<iostream>
#include<sstream>
#include<cstring>
using namespace std;

int main()
{
    string **str= new string*[5];
    for(int i= 0; i<5; i++)
    {
        str[i]= new string[4];
    }
    str[0][1]= "a";
    str[0][0]= "b";
    string *ptr= &str[0][1];
    cout<< ptr<< endl;
    cout<< &str[0][1]<< endl;
    delete ptr;
    cout<< str[0][1];
}
 
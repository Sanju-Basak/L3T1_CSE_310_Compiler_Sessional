#include<iostream>
#include<fstream>
#include<cstring>
#include "1805064_SymbolTable.h"


using namespace std;

int main()
{
    freopen("input.txt", "r", stdin);
    freopen("output.txt", "w", stdout);
    cin>> bucket;
    SymbolTable st;
    string s;
    while(cin>>s)
    {
        if(s.compare("I")== 0){
            string str1;
            string str2;
            cin>> str1;
            cin>> str2;
            cout<< "I "<< str1<< " "<< str2<< endl;
            cout<< endl;
            st.insert(str1, str2);
            cout<< endl;
        }else if(s.compare("S")== 0){
            cout<< "S\n";
            cout<< endl;
            st.EnterScope();
            cout<< endl;
        }else if(s.compare("P")== 0){
            string str;
            cin>> str;
            if(str.compare("A")== 0){
                cout<< "P A \n";
                cout<< endl;
                st.printAll();
                cout<< endl;
            }else{
                cout<< "P C\n";
                cout<< endl;
                st.printCurrent();
                cout<< endl;
            }
        }else if(s.compare("L")== 0){
            string str;
            cin>> str;
            cout<< "L "<< str<< endl;
            cout<< endl;
            st.lookUp(str);
            cout<< endl;
        }else if(s.compare("E")== 0){
            cout<< "E\n";
            cout<< endl;
            st.ExitScope();
            cout<< endl;
        }else if(s.compare("D")==0){
            string str;
            cin>> str;
            cout<< "D "<< str<< endl;
            cout<< endl;
            st.remove(str);
            cout<< endl;
        }
    }
}
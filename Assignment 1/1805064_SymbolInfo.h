#include<iostream>
#include<cstring>
using namespace std;

class SymbolInfo
{
private:
    string name;
    string type;
public:
    SymbolInfo* next;
    SymbolInfo(){
    }
    SymbolInfo(string name, string type);
    ~SymbolInfo();
    string getName();
    void setName(string name);
    string getType();
    void setType(string name);

};

SymbolInfo::SymbolInfo(string name, string type)
{
    this->name= name;
    this->type= type;
}

SymbolInfo::~SymbolInfo()
{
}

string SymbolInfo::getName(){
    return name;
}

void SymbolInfo::setName(string name){
    this->name= name;
}

string SymbolInfo::getType(){
    return type;
}

void SymbolInfo::setType(string type){
    this->type= type;
}




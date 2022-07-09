#include<iostream>
#include<sstream>
#include<fstream>
#include "1805064_ScopeTable.h"

using namespace std;

int bucket= 7;

class SymbolTable
{
private:
    ScopeTable* current;
public:
    SymbolTable();
    ~SymbolTable();
    void EnterScope();
    void ExitScope();
    bool insert(string name, string type);
    void printCurrent(FILE *fp);
    void printAll(FILE *fp);
    SymbolInfo* lookUp(string str);
    bool remove(string name);
};

SymbolTable::SymbolTable()
{
    current= new ScopeTable(bucket);
    current->id.append("1");
}

SymbolTable::~SymbolTable()
{
    
    while(current->parentScope != NULL){
        ScopeTable* temp= current;
        current= temp->parentScope;
        temp->parentScope= NULL;
        delete temp;
    }
    
    delete current;
    current= NULL;
}

void SymbolTable::EnterScope(){
    ScopeTable *sc= new ScopeTable(bucket);
    sc->parentScope= current;
    current= sc;
    current->id.append(current->parentScope->id);
    stringstream ss;
    ss<< ((current->parentScope->count)+ 1);
    current->id.append(".");
    current->id.append(ss.str());
    //cout<< "New ScopeTable with id " << current->id << " created"<< endl;
}

void SymbolTable::ExitScope(){
    ScopeTable* temp;
    temp= current;
    current= temp->parentScope;
    current->count++;
    temp->parentScope= NULL;
    //cout<< "ScopeTable with id " << temp->id << " removed\n";
    delete temp;
}

bool SymbolTable::insert(string str1, string str2)
{
    if(current->insertSymbol(str1, str2))
        return true;
    else
        return false;
}


void SymbolTable::printCurrent(FILE *fp){
    current->printScopeTable(fp);
}

void SymbolTable::printAll(FILE *fp){
    ScopeTable *temp;
    temp= current;
    while(temp != NULL){
        temp->printScopeTable(fp);
        fprintf(fp, "\n");
        temp= temp->parentScope;
    }
}

SymbolInfo* SymbolTable::lookUp(string str)
{
    ScopeTable *temp;
    SymbolInfo* smb;
    temp= current;
    while(temp != NULL){
        smb= temp->lookUpSymbol(str);
        if(smb != NULL)
        {
            return smb;
        }
        temp= temp->parentScope;
    }
   //cout<< "Not found\n";
    return NULL;
}

bool SymbolTable::remove(string str){
    if(current->deleteSymbol(str))
        return true;
    else
        return false;
}






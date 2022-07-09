#include<iostream>
#include<fstream>
#include<cstring>
#include<algorithm>
#include "1805064_SymbolInfo.h"
using namespace std;


static unsigned long sdbm(string str)
 {
        unsigned long hash = 0;
        for(int c,i=0 ;i< str.length(); i++ )
        {
            c= str[i];
            hash = c + (hash << 6) + (hash << 16) - hash;
        }
        return hash;
 }



class ScopeTable
{
private:
    SymbolInfo** smb;
    int bucketNo;
public:
    
    ScopeTable* parentScope= NULL;
    string id;
    int count;
    ScopeTable(int n);
    ~ScopeTable();
    bool insertSymbol(string str1, string str2);
    SymbolInfo* lookUpSymbol(string str);
    bool deleteSymbol(string str);
    void printScopeTable(FILE *fp);
    int hashFunc(string name){
    return sdbm(name)% bucketNo;
    }
    int getBucketNo();
    void setBucketNo(int n);
};

ScopeTable::ScopeTable(int n)
{
    this->bucketNo= n;
    smb= new SymbolInfo* [n];
    for(int i=0; i<n; i++)
        smb[i]= NULL;
    count= 0;
    
}

ScopeTable::~ScopeTable()
{
    for(int i=0; i<bucketNo; i++)
    {  
        while(smb[i] != NULL){
            SymbolInfo* temp= smb[i];
            smb[i]= temp->next;
            delete temp;
        } 
    }
    delete[] smb;
    smb= NULL;
}

bool ScopeTable::insertSymbol(string str1, string str2){
    //freopen("1805064_log.txt","a", stdout);
    int c= 0;
    SymbolInfo *temp= new SymbolInfo(str1, str2);
    int index= hashFunc(str1);
    SymbolInfo *temp2= smb[index];
    while(temp2 != NULL){
        if(temp2->getName().compare(str1)== 0){
        
            //cout<< "<" << str1 << "," << str2 << "> already exists in current ScopeTable\n"; 
            delete temp;
            return false;
        }
        temp2= temp2->next;
    }

    if(smb[index]== NULL){
        smb[index]= temp;
        //cout<< "Inserted in ScopeTable# "<<  id << " at position "<<  index<< " , " << c<< endl;
    }
    else{
        c++;
        SymbolInfo *temp2= smb[index];
        while(temp2->next != NULL){
            temp2= temp2->next;
            c++;
        }
        temp2->next= temp;
        //cout<< "Inserted in ScopeTable# "<<  id << " at position "<<  index<< " , " << c<< endl;
    }
    return true;
    

}

SymbolInfo* ScopeTable::lookUpSymbol(string str){
    int c=0;
    int index= hashFunc(str);
    SymbolInfo *temp2= smb[index];
    while(temp2 != NULL){
        if(temp2->getName().compare(str)== 0){
            //cout<< "Found in ScopeTable# "<<  id << " at position "<<  index<< " , " << c<< endl;
            return temp2;
        }
        temp2= temp2->next;
        c++;
    }
    
    return NULL;

}

void ScopeTable::printScopeTable(FILE *fp){
    fprintf(fp, "ScopeTable # %s\n", id.c_str());
    //cout<< "ScopeTable # "<< id<< endl;
    for(int i=0; i<bucketNo; i++){
        int k= 0;
        SymbolInfo* temp= smb[i];
        while(temp != NULL){
            if(k != 1){
                fprintf(fp, "%d --> ", i);
            }
            k=1;
            fprintf(fp, "< %s : %s > ", temp->getName().c_str(), temp->getType().c_str());
            // cout<< i<< "--> ";
            // cout<< "< "<<  temp->getName()<< " : "<< temp->getType()<< "> ";
            temp = temp->next;
        }
        if(k==1){
            fprintf(fp, "\n");
        }
        
    }
    
}

bool ScopeTable::deleteSymbol(string str){
    int c= 0;
    int index= hashFunc(str);
    SymbolInfo *temp2= smb[index];
    SymbolInfo *prev= NULL;
    if(temp2 != NULL && temp2->getName().compare(str) == 0){
        smb[index]= temp2->next;
        delete temp2;
        //cout<< "Found in ScopeTable# "<< id<< " at position "<< index<< " , "<< c << endl;
        cout<< endl;
        //cout<< "Deleted Entry "<< index<< " , "<< c<< " from current ScopeTable\n";
        return true;
    }

    else{
        while (temp2 != NULL && temp2->getName().compare(str) != 0)
        {
            c++;
            prev= temp2;
            temp2= temp2->next;
        }
        if(temp2 == NULL){
            cout<< "Not found\n";
            cout<<endl;
            cout<< str<< " Not Found\n";
            return false;
        }
        prev->next= temp2->next;
        delete temp2;
        //cout<< "Found in ScopeTable# "<< id<< " at position "<< index<< " , "<< c << endl;
        //cout<< "Deleted Entry "<< index<< " , "<< c<< " from current ScopeTable\n";
        return true;
    }

}

int ScopeTable::getBucketNo()
{
    return this->bucketNo;
}

void ScopeTable::setBucketNo(int n){
    bucketNo= n;
}

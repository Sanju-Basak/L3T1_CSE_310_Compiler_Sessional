#include<iostream>
#include<sstream>
#include<fstream>
#include<vector>


using namespace std;


///////////////////////////////  SYMBOL INFO   ////////////////////////////////////

class SymbolInfo
{
private:
    string name;
    string type;
public:
    SymbolInfo* next;

    string retType; //return type of function
    int size;   //size of array

    struct param{
    string par_name;
    string par_type;
    }temp_par;

    vector<param> param_list;   

    SymbolInfo(){
    }
    SymbolInfo(string name, string type){
        this->name= name;
        this->type= type;
    }
    ~SymbolInfo(){

    }
    string getName(){
        return name;
    }
    void setName(string name){
        this->name= name;
    }
    string getType(){
        return type;
    }
    void setType(string type){
        this->type= type;
    }

    string getRetType(){
        return retType;
    }
    void setRetType(string retType){
        this->retType= retType;
    }

    int getSize(){
        return size;
    }
    void setSize(int size){
        this->size= size;
    }

    void addParamList(string name, string type){
        temp_par.par_name= name;
        temp_par.par_type= type;

        param_list.push_back(temp_par);
    }

    param getParam(int index){
        return param_list[index];
    }

    int getParamSize(){
        return param_list.size();
    }


};

///////////////////////////////  SCOPE TABLE   ////////////////////////////////////


class ScopeTable
{
private:
    SymbolInfo** smb;
    int bucketNo;
    
    unsigned long sdbm(string str)
 {
        unsigned long hash = 0;
        for(int c,i=0 ;i< str.length(); i++ )
        {
            c= str[i];
            hash = c + (hash << 6) + (hash << 16) - hash;
        }
        return hash;
 }


public:
    
    ScopeTable* parentScope= NULL;
    string id;
    int count;
    ScopeTable(int n)
{
    this->bucketNo= n;
    smb= new SymbolInfo* [n];
    for(int i=0; i<n; i++)
        smb[i]= NULL;
    count= 0;
    
}

   ~ScopeTable()
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

    bool insertSymbol(SymbolInfo& symbol){
    //freopen("1805064_log.txt","a", stdout);
    int c= 0;
    //SymbolInfo *temp= new SymbolInfo(symbol.getName(), symbol.getType());
    int index= hashFunc(symbol.getName());
    SymbolInfo *temp2= smb[index];
    while(temp2 != NULL){
        if(temp2->getName().compare(symbol.getName())== 0){
        
            //cout<< "<" << str1 << "," << str2 << "> already exists in current ScopeTable\n"; 
            //delete temp;
            return false;
        }
        temp2= temp2->next;
    }

    if(smb[index]== NULL){
        smb[index]= &symbol;
        //cout<< "Inserted in ScopeTable# "<<  id << " at position "<<  index<< " , " << c<< endl;
    }
    else{
        c++;
        SymbolInfo *temp2= smb[index];
        while(temp2->next != NULL){
            temp2= temp2->next;
            c++;
        }
        temp2->next= &symbol;
        //cout<< "Inserted in ScopeTable# "<<  id << " at position "<<  index<< " , " << c<< endl;
    }
    return true;
    

}


    SymbolInfo* lookUpSymbol(string str){
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


    bool deleteSymbol(string str){
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


    void printScopeTable(FILE *fp){
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

    int hashFunc(string name){
    return sdbm(name)% bucketNo;
    }


    int getBucketNo(){
        return this->bucketNo;
    }

    void setBucketNo(int n){
        bucketNo= n;
    }
};


///////////////////////////////  SYMBOL TABLE   ////////////////////////////////////


class SymbolTable
{
private:
    ScopeTable* current;
    int bucket= 30;
public:
    SymbolTable(){
        current= new ScopeTable(bucket);
        current->id.append("1");
    }

    ~SymbolTable(){
    while(current->parentScope != NULL){
        ScopeTable* temp= current;
        current= temp->parentScope;
        temp->parentScope= NULL;
        delete temp;
    }
    
    delete current;
    current= NULL;
    }

    void EnterScope(){
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
    void ExitScope(){
    ScopeTable* temp;
    temp= current;
    current= temp->parentScope;
    current->count++;
    temp->parentScope= NULL;
    //cout<< "ScopeTable with id " << temp->id << " removed\n";
    delete temp;
}

    bool insert(SymbolInfo& symbol)
{
    if(current->insertSymbol(symbol))
        return true;
    else
        return false;
}


    void printCurrent(FILE *fp){
    current->printScopeTable(fp);
}

void printAll(FILE *fp){
    ScopeTable *temp;
    temp= current;
    while(temp != NULL){
        temp->printScopeTable(fp);
        fprintf(fp, "\n");
        temp= temp->parentScope;
    }
}



SymbolInfo* lookUp(string str){
    ScopeTable* temp= current;
    SymbolInfo* smb;
    if(temp != NULL){
        smb= temp->lookUpSymbol(str);
        return smb;
    }
    return NULL;
}
    
SymbolInfo* lookUpAll(string str)
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
   bool remove(string str){
    if(current->deleteSymbol(str))
        return true;
    else
        return false;
}
};















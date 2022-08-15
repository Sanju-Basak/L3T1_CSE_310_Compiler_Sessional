%{

#include<iostream>
#include<cstdlib>
#include<cstring>
#include<cmath>
#include<vector>
#include "1805064_SymbolTable.h"

using namespace std;

int yyparse(void);
int yylex(void);
extern FILE *yyin;
extern int line_count;
extern int error;

FILE *logout, *errout;

SymbolTable st;


///////for variable dec //////

struct var{
    string var_name;
    int var_size;
}temp_var;

vector<var> var_list;

///////// for parameter dec    //////////

struct param{
    string par_name;
    string par_type;
}temp_par;

vector<param> param_list;

vector<string> arg_list;

//for function dec-def
string type, type_final;
string name, name_final;




void insertVar(var vin, string retType){
    SymbolInfo* sf= new SymbolInfo(vin.var_name, "ID");
    sf->setRetType(retType);
    sf->setSize(vin.var_size);

    st.insert(*sf);
}

void insertFunc(string name, string type, int size){
    SymbolInfo *sf= new SymbolInfo(name, "ID");
    sf->setRetType(type);
    sf->setSize(size);

    if(param_list.size()>0){
        string nm= param_list[0].par_name;
        for(int i=1; i< param_list.size(); i++){
            if(nm== param_list[i].par_name){
            fprintf(logout, "Error at line %d: Multiple declaration of %s in parameter \n\n", line_count, param_list[i].par_name.c_str());
            fprintf(errout, "Error at line %d: Multiple declaration of %s in parameter  \n\n", line_count, param_list[i].par_name.c_str());
            error++;            
        }
    }
    }


    for(int i=0; i< param_list.size(); i++){
        sf->addParamList(param_list[i].par_name, param_list[i].par_type);
    }

    st.insert(*sf);
}


//////////////////      Error Handling      /////////////////////

void error_undeclared_var(string v){
    error++;
    fprintf(logout, "Error at line %d: Undeclared variable %s\n\n", line_count, v.c_str());
    fprintf(errout, "Error at line %d: Undeclared variable %s\n\n", line_count, v.c_str());
    
}

void error_multiple_dec(string v){
    error++;
    fprintf(logout, "Error at line %d: Multiple declaration of %s\n\n", line_count, v.c_str());
    fprintf(errout, "Error at line %d: Multiple declaration of %s\n\n", line_count, v.c_str());
    
}

void error_varType(){
    error++;
    fprintf(logout, "Error at line %d: Variable type can not be void \n\n", line_count);
    fprintf(errout, "Error at line %d: Variable type can not be void \n\n", line_count);
    
}

void error_undeclared_func(string v){
    fprintf(logout, "Error at line %d: Undeclared Function %s\n\n", line_count, v.c_str());
    fprintf(errout, "Error at line %d: Undeclared Function  %s\n\n", line_count, v.c_str());
    error++;
}

void error_function_return_conflict(string v){
    error++; 
    fprintf(logout, "Error at line %d: Return type mismatch with function declaration in function  %s\n\n", line_count, v.c_str());
    fprintf(errout, "Error at line %d: Return type mismatch with function declaration in function  %s\n\n", line_count, v.c_str());
       
}

void error_not_function(string v){
    error++; 
    fprintf(logout, "Error at line %d: %s not a function\n\n", line_count, v.c_str());
    fprintf(errout, "Error at line %d: %s not a function \n\n", line_count, v.c_str());
 
}


void error_inconsistent_func_size(string v){
    error++; 
    fprintf(logout, "Error at line %d: Total number of arguments mismatch in function %s\n\n", line_count, v.c_str());
    fprintf(errout, "Error at line %d: Total number of arguments mismatch in function %s\n\n", line_count, v.c_str());
        
}

void error_inconsistent_func_type(int i, string v){
    error++; 
    fprintf(logout, "Error at line %d: %dth argument mismatch in function func %s\n\n", line_count, i, v.c_str());
    fprintf(errout, "Error at line %d: %dth argument mismatch in function func %s\n\n", line_count, i, v.c_str());
     
}


void error_function_paramSize(string v){
    error++; 
    fprintf(logout, "Error at line %d: Total number of arguments mismatch with declaration in function  %s\n\n", line_count, v.c_str());
    fprintf(errout, "Error at line %d: Total number of arguments mismatch with declaration in function %s\n\n", line_count, v.c_str());
       
}

void error_function_paramType(string v){
    error++; 
    fprintf(logout, "Error at line %d: arguments type mismatch with declaration in function  %s\n\n", line_count, v.c_str());
    fprintf(errout, "Error at line %d: arguments type mismatch with declaration in function %s\n\n", line_count, v.c_str());
    
}

void error_typecast_void(){
    error++; 
    fprintf(logout, "Error at line %d: Void function used in expression  \n\n", line_count);
    fprintf(errout, "Error at line %d: Void function used in expression  \n\n", line_count);
}

void error_type_cast_mod()
{
    error++; 
    fprintf(logout, "Error at line %d: Non-Integer operand on modulus operator \n\n", line_count);
    fprintf(errout, "Error at line %d: Non-Integer operand on modulus operator \n\n", line_count);
}


void error_modzero()
{
    error++; 
    fprintf(logout, "Error at line %d: Modulus by Zero \n\n", line_count);
    fprintf(errout, "Error at line %d: Modulus by Zero \n\n", line_count);
}

void error_type_mismatch(string v="")
{
    error++; 
    fprintf(logout, "Error at line %d: Type mismatch %s\n\n", line_count, v.c_str());
    fprintf(errout, "Error at line %d: Type mismatch %s\n\n", line_count, v.c_str());
}

void error_array_index_invalid(){
    error++; 
    fprintf(logout, "Error at line %d: Expression inside third brackets not an integer \n\n", line_count);
    fprintf(errout, "Error at line %d: Expression inside third brackets not an integer \n\n", line_count);   
}



void yyerror(string v)
{
	//write your code
    error++; 
    fprintf(logout, "Error at line %d: %s\n\n", line_count, v.c_str());
    fprintf(errout, "Error at line %d: %s\n\n", line_count, v.c_str());

}


%}

%union
{
    SymbolInfo* symbolInfo;
}

%token IF FOR INT FLOAT VOID ELSE WHILE RETURN PRINTLN INCOP DECOP ASSIGNOP NOT LPAREN RPAREN LCURL RCURL LTHIRD RTHIRD COMMA SEMICOLON 
%token<symbolInfo>  ADDOP MULOP RELOP LOGICOP CONST_INT CONST_FLOAT ID
%type <symbolInfo> start program unit variable var_declaration type_specifier func_declaration func_definition parameter_list id
%type <symbolInfo> expression factor unary_expression term simple_expression rel_expression statement statements compound_statement logic_expression expression_statement arguments argument_list declaration_list


/*
%left 
%right
*/

%nonassoc LOWER_THAN_ELSE
%nonassoc ELSE


%%

start :{
    //fprintf(assout, ".model small\n.stack 100h\n.data\n");
}  program
	{
		//write your code in this block in all the similar blocks below
        // $$= new SymbolInfo($1->getName(), "NON-TERMINAL");
        fprintf(logout, "Line %d: start : program\n\n", line_count);
        //fprintf(logout, "%s \n\n", $1->getName().c_str());
	}
	;

program : program unit 
    {
        $$= new SymbolInfo($1->getName()+ $2->getName(), "NON-TERMINAL");
        fprintf(logout, "Line %d: program : program unit\n\n", line_count);
        fprintf(logout, "%s%s\n\n", $1->getName().c_str(), $2->getName().c_str());
    }
	| unit
    {
        $$= new SymbolInfo($1->getName(), "NON-TERMINAL");
        fprintf(logout, "Line %d: program : unit\n\n", line_count);
        fprintf(logout, "%s \n\n", $1->getName().c_str());
    }


	;
	
unit : var_declaration
    {
        $$= new SymbolInfo($1->getName(), "NON-TERMINAL");
        fprintf(logout, "Line %d: unit : var_declaration\n\n", line_count);
        fprintf(logout, "%s \n\n", $1->getName().c_str());
    }
     | func_declaration
     {
        $$= new SymbolInfo($1->getName(), "NON-TERMINAL");
        fprintf(logout, "Line %d: unit : func_declaration\n\n", line_count);
        fprintf(logout, "%s \n\n", $1->getName().c_str());
     }
     | func_definition
     {
        $$= new SymbolInfo($1->getName(), "NON-TERMINAL");
        fprintf(logout, "Line %d: unit : func_definition\n\n", line_count);
        fprintf(logout, "%s \n\n", $1->getName().c_str());
     }
     ;
     
func_declaration : type_specifier id dummy_func1 LPAREN parameter_list RPAREN dummy_func1_dec SEMICOLON
                {
                    $$ = new SymbolInfo($1->getName()+" "+$2->getName()+"("+$5->getName()+")"+";\n", "NON_TERMINAL");
                    fprintf(logout, "Line %d: func_declaration : type_specifier ID LPAREN parameter_list RPAREN SEMICOLON\n\n", line_count);
                    fprintf(logout, "%s %s(%s); \n\n", $1->getName().c_str(), $2->getName().c_str(), $5->getName().c_str());

                    param_list.clear();
                }
		| type_specifier id dummy_func1 LPAREN RPAREN dummy_func1_dec SEMICOLON
        {
                $$ = new SymbolInfo($1->getName()+" "+$2->getName()+"();\n", "NON_TERMINAL");
                fprintf(logout, "Line %d: func_declaration : type_specifier ID LPAREN RPAREN SEMICOLON\n\n", line_count);
                fprintf(logout, "%s %s(); \n\n", $1->getName().c_str(), $2->getName().c_str()); 

                param_list.clear();           
        }
		;
		 
func_definition : type_specifier id dummy_func1 LPAREN parameter_list RPAREN dummy_func1_def compound_statement
                {
                    $$ = new SymbolInfo($1->getName()+" "+$2->getName()+"("+$5->getName()+") "+$8->getName()+ "\n", "NON_TERMINAL");
                    fprintf(logout, "Line %d: func_definition : type_specifier ID LPAREN parameter_list RPAREN compound_statement\n\n", line_count);
                    fprintf(logout, "%s %s(%s) %s \n\n", $1->getName().c_str(), $2->getName().c_str(), $5->getName().c_str(), $8->getName().c_str());
                }
		| type_specifier id dummy_func1 LPAREN RPAREN dummy_func1_def compound_statement
        {
                $$ = new SymbolInfo($1->getName()+" "+$2->getName()+"() "+$7->getName()+ "\n", "NON_TERMINAL");
                fprintf(logout, "Line %d: func_definition : type_specifier ID LPAREN RPAREN compound_statement\n\n", line_count);
                fprintf(logout, "%s %s() %s \n\n", $1->getName().c_str(), $1->getName().c_str(), $2->getName().c_str(), $7->getName().c_str());
        }
 		;	

dummy_func1: {
    type_final= type;
    name_final= name;


}
;

dummy_func1_dec: {

    ////Insert func name to symboTable
    if(st.lookUpAll(name_final)!= NULL){
        error_multiple_dec(name_final);
    }else{
        insertFunc(name_final, type_final, -2);
    }


}
;

dummy_func1_def: {
    ////Insert funcName if not inserted

    SymbolInfo* temp= st.lookUpAll(name_final);
    if(temp == NULL){
        insertFunc(name_final, type_final, -3);
    } else if(temp->getSize() != -2){
        error_multiple_dec(name_final);
    }

    else{
        ///function dec & def matching check
        if(temp->getRetType() != type_final){
            error_function_return_conflict(temp->getName());
        }else if(temp->getParamSize()==1 && param_list.size()== 0 && temp->getParam(0).par_type== "void"){
            temp->setSize(-3);
        }else if(temp->getParamSize()==0 && param_list.size()== 1 && param_list[0].par_type== "void"){
            temp->setSize(-3);
        }else if(temp->getParamSize() != param_list.size()){
            error_function_paramSize(temp->getName());


        }else{
            ///size same, type checking

            int i=0;
            while(i< param_list.size()){
                if(temp->getParam(i).par_type != param_list[i].par_type){
                    break;
                }
                i++;
            }

            if(i== param_list.size()){
                temp->setSize(-3);
            }else{
                error_function_paramType(name_final);
            }
        }

    } 
}

;

parameter_list  : parameter_list COMMA type_specifier id
        {
                $$ = new SymbolInfo($1->getName()+","+$3->getName()+ " "+ $4->getName(), "NON_TERMINAL");
                fprintf(logout, "Line %d: parameter_list  : parameter_list COMMA type_specifier ID\n\n", line_count);
                fprintf(logout, "%s, %s %s \n\n", $1->getName().c_str(), $3->getName().c_str(), $4->getName().c_str());

                ///updating parameter list
                temp_par.par_type = $3->getName();
                temp_par.par_name = $4->getName();

                param_list.push_back(temp_par);
        }
		| parameter_list COMMA type_specifier
        {
                $$ = new SymbolInfo($1->getName()+","+$3->getName(), "NON_TERMINAL");
                fprintf(logout, "Line %d: parameter_list  : parameter_list COMMA type_specifier\n\n", line_count);
                fprintf(logout, "%s, %s \n\n", $1->getName().c_str(), $3->getName().c_str());

                ///updating parameter list
                temp_par.par_type = $3->getName();
                temp_par.par_name = "";

                param_list.push_back(temp_par);
        }
 		| type_specifier id
        {
                $$ = new SymbolInfo($1->getName()+" "+$2->getName(), "NON_TERMINAL");
                fprintf(logout, "Line %d: parameter_list  : type_specifier ID\n\n", line_count);
                fprintf(logout, "%s %s \n\n", $1->getName().c_str(), $2->getName().c_str());

                ///updating parameter list
                temp_par.par_type = $1->getName();
                temp_par.par_name = $2->getName();

                param_list.push_back(temp_par);
        }
		| type_specifier
        {
                $$ = new SymbolInfo($1->getName(), "NON_TERMINAL");
                fprintf(logout, "Line %d: parameter_list  : type_specifier\n\n", line_count);
                fprintf(logout, "%s\n\n", $1->getName().c_str());

                ///updating parameter list
                temp_par.par_type = $1->getName();
                temp_par.par_name = "";

                param_list.push_back(temp_par);
        }
 		;

 		
compound_statement : LCURL dummy_func statements RCURL
        {
                $$ = new SymbolInfo("{\n"+ $3->getName()+ "}\n" , "NON_TERMINAL");
                fprintf(logout, "Line %d: compound_statement : LCURL statements RCURL\n\n", line_count);
                fprintf(logout, "{\n%s\n}\n\n", $3->getName().c_str());

                st.printAll(logout);
                st.ExitScope();
        }
 		    | LCURL dummy_func RCURL
             {
                $$ = new SymbolInfo("{\n}\n" , "NON_TERMINAL");
                fprintf(logout, "Line %d: compound_statement : LCURL RCURL\n\n", line_count);
                fprintf(logout, "{\n\n}\n\n");

                st.printAll(logout);
                st.ExitScope();
             }
 		    ;

dummy_func: {


            st.EnterScope();

            //ScopeTable enter param_list

            if(param_list.size()== 1 && param_list[0].par_type== "void"){

            }else{
                int i=0;
                while(i< param_list.size()){
                    temp_var.var_name= param_list[i].par_name;
                    temp_var.var_size= -1;

                    insertVar(temp_var, param_list[i].par_type);
                    i++;
                }
            }

            param_list.clear();
}
;
 		    
var_declaration : type_specifier  declaration_list SEMICOLON
                {
                    $$= new SymbolInfo($1->getName()+ " "+ $2->getName()+ ";\n", "NON-TERMINAL");
                    fprintf(logout, "Line %d: var_declaration : type_specifier declaration_list SEMICOLON\n\n", line_count);
                    fprintf(logout, "%s %s; \n\n", $1->getName().c_str(), $2->getName().c_str());

                    //insert to SymbolTable
                    if($1->getName()== "void"){
                        error_varType();

                        for(int i=0; i< var_list.size(); i++){
                            insertVar(var_list[i], "float");
                        }

                    }
                    else{
                         for(int i=0; i< var_list.size(); i++){
                            insertVar(var_list[i], $1->getName());
                        }

                    }
                    
                    var_list.clear();
                }
 		 ;
 		 
type_specifier	: INT
        {
            $$= new SymbolInfo("int", "NON-TERMINAL");
            fprintf(logout, "Line %d: type_specifier : INT\n\n", line_count);
            fprintf(logout, "int \n\n");

            type= "int";
        }
 		| FLOAT
        {
            $$= new SymbolInfo("float", "NON-TERMINAL");
            fprintf(logout, "Line %d: type_specifier : FLOAT\n\n", line_count);
            fprintf(logout, "float \n\n");

            type= "float";
        }
 		| VOID
         {
            $$= new SymbolInfo("void", "NON-TERMINAL");
            fprintf(logout, "Line %d: type_specifier : VOID\n\n", line_count);
            fprintf(logout, "void \n\n");

            type= "void";
         }
 		;

id: ID {
            $$ = new SymbolInfo($1->getName(), "NON_TERMINAL");
            name = $1->getName();
    }
    ;
 		
declaration_list : declaration_list COMMA id
                {
                    $$= new SymbolInfo($1->getName()+ ","+  $3->getName(), "NON-TERMINAL");
                    fprintf(logout, "Line %d: declaration_list : declaration_list COMMA ID\n\n", line_count);
                    fprintf(logout, "%s,%s \n\n", $1->getName().c_str(), $3->getName().c_str());

                    //updating variable list
                    temp_var.var_name= $3->getName();
                    temp_var.var_size= -1;

                    var_list.push_back(temp_var);

                    //Looking if already existed

                    if(st.lookUp($3->getName()) != NULL){
                        error_multiple_dec($3->getName());
                    }

                }
 		  | declaration_list COMMA id LTHIRD CONST_INT RTHIRD
           {    
                $$= new SymbolInfo($1->getName()+ ","+  $3->getName()+ "["+ $5->getName()+ "]", "NON-TERMINAL");
                fprintf(logout, "Line %d: declaration_list : declaration_list COMMA ID LTHIRD CONST_INT RTHIRD\n\n", line_count);
                fprintf(logout, "%s,%s[%s] \n\n", $1->getName().c_str(), $3->getName().c_str(), $5->getName().c_str());

                //updating variable list
                temp_var.var_name= $3->getName();
                int temp;
                temp= stoi($5->getName());
                temp_var.var_size= temp;   

                var_list.push_back(temp_var);

                //Looking if already existed

                if(st.lookUp($3->getName()) != NULL){
                    error_multiple_dec($3->getName());
                }


           }
 		  | id
           {
                $$= new SymbolInfo($1->getName(), "NON-TERMINAL");
                fprintf(logout, "Line %d: declaration_list : ID\n\n", line_count);
                fprintf(logout, "%s \n\n", $1->getName().c_str());

                //updating variable list
                temp_var.var_name= $1->getName();
                temp_var.var_size= -1;

                var_list.push_back(temp_var);

                //Looking if already existed

                if(st.lookUp($1->getName()) != NULL){
                    error_multiple_dec($1->getName());
                }
           }
 		  | id LTHIRD CONST_INT RTHIRD
           {
                $$= new SymbolInfo($1->getName()+ "["+ $3->getName()+ "]", "NON-TERMINAL");
                fprintf(logout, "Line %d: declaration_list : ID LTHIRD CONST_INT RTHIRD\n\n", line_count);
                fprintf(logout, "%s[%s] \n\n", $1->getName().c_str(), $3->getName().c_str());

                //updating variable list
                temp_var.var_name= $1->getName();
                int temp;
                temp= stoi($3->getName());
                temp_var.var_size= temp;

                var_list.push_back(temp_var);

                //Looking if already existed

                if(st.lookUp($1->getName()) != NULL){
                    error_multiple_dec($1->getName());
                }
           }
 		  ;
	  
statements : statement
        {
            $$= new SymbolInfo($1->getName(), "NON-TERMINAL");
            fprintf(logout, "Line %d: statements : statement\n\n", line_count);
            fprintf(logout, "%s \n\n", $1->getName().c_str());
        }
	   | statements statement
       {
            $$= new SymbolInfo($1->getName()+ $2->getName(), "NON-TERMINAL");
            fprintf(logout, "Line %d: statements : statements statement\n\n", line_count);
            fprintf(logout, "%s%s\n\n", $1->getName().c_str(), $2->getName().c_str());
       }
	   ;
	///////////////////////////////////////////////////////////////////////done////////////////////////////////////////////   
statement : var_declaration
        {
            $$= new SymbolInfo($1->getName(), "NON-TERMINAL");
            fprintf(logout, "Line %d: statement : var_declaration\n\n", line_count);
            fprintf(logout, "%s \n\n", $1->getName().c_str());
        }
	  | expression_statement
        {
            $$= new SymbolInfo($1->getName(), "NON-TERMINAL");
            fprintf(logout, "Line %d: statement : expression_statement\n\n", line_count);
            fprintf(logout, "%s \n\n", $1->getName().c_str());
        }
	  | compound_statement
        {
            $$= new SymbolInfo($1->getName(), "NON-TERMINAL");
            fprintf(logout, "Line %d: statement : compound_statement\n\n", line_count);
            fprintf(logout, "%s \n\n", $1->getName().c_str());
        }
	  | FOR LPAREN expression_statement dummy_func2_type dummy_func2_void expression_statement dummy_func2_type dummy_func2_void expression dummy_func2_type dummy_func2_void  RPAREN statement
      {
            $$= new SymbolInfo("for("+$3->getName()+ $6->getName()+ $9->getName()+ ")"+ $13->getName()+ "\n", "NON-TERMINAL");
            fprintf(logout, "Line %d: statement : FOR LPAREN expression_statement expression_statement expression RPAREN statement\n\n", line_count);
            fprintf(logout, "for(%s%s%s)%s \n\n", $3->getName().c_str(), $6->getName().c_str(), $9->getName().c_str(), $13->getName().c_str());
      }
	  | IF LPAREN expression dummy_func2_type RPAREN dummy_func2_void  statement   %prec LOWER_THAN_ELSE
      {
            $$= new SymbolInfo("if("+ $3->getName()+ ")"+ $7->getName()+ "\n", "NON-TERMINAL");
            fprintf(logout, "Line %d: statement : IF LPAREN expression RPAREN statement\n\n", line_count);
            fprintf(logout, "if(%s)%s \n\n", $3->getName().c_str(), $7->getName().c_str());
      }
	  | IF LPAREN expression dummy_func2_type RPAREN dummy_func2_void statement ELSE statement 
      {
            $$= new SymbolInfo("if("+ $3->getName()+ ")"+ $7->getName()+ " else"+ $9->getName()+ "\n", "NON-TERMINAL");
            fprintf(logout, "Line %d: statement : IF LPAREN expression RPAREN statement ELSE statement\n\n", line_count);
            fprintf(logout, "if(%s)%s else%s\n\n", $3->getName().c_str(), $7->getName().c_str(), $9->getName().c_str());
      }
	  | WHILE LPAREN expression dummy_func2_type RPAREN dummy_func2_void statement
      {
            $$= new SymbolInfo("while("+ $3->getName()+ ")"+ $7->getName()+ "\n", "NON-TERMINAL");
            fprintf(logout, "Line %d: statement : WHILE LPAREN expression RPAREN statement\n\n", line_count);
            fprintf(logout, "while(%s)%s\n\n", $3->getName().c_str(), $7->getName().c_str());
      }
	  | PRINTLN LPAREN id RPAREN SEMICOLON
      {
            $$= new SymbolInfo("printf("+ $3->getName()+ ");\n", "NON-TERMINAL");
            fprintf(logout, "Line %d: statement : PRINTLN LPAREN ID RPAREN SEMICOLON\n\n", line_count);
            fprintf(logout, "printf(%s);\n\n", $3->getName().c_str());

            if(st.lookUp($3->getName())== NULL){
                error_undeclared_var($3->getName());
            }
      }
	  | RETURN expression SEMICOLON
      {
            $$= new SymbolInfo("return "+ $2->getName()+ ";\n", "NON-TERMINAL");
            fprintf(logout, "Line %d: statement : RETURN expression SEMICOLON\n\n", line_count);
            fprintf(logout, "return %s;\n\n", $2->getName().c_str());

            if($2->getRetType()== "void"){
                error_typecast_void();
            }
      }
	  ;

dummy_func2_type:   {

    type_final= type;



}
;

dummy_func2_void:   {

    if(type_final== "void"){
        error_typecast_void();
    }
}
;
	  
expression_statement 	: SEMICOLON	
        {
            $$= new SymbolInfo(";\n", "NON-TERMINAL");
            fprintf(logout, "Line %d: expression_statement 	: SEMICOLON	\n\n", line_count);
            fprintf(logout, ";\n\n");


            $$->setRetType("int");
            type= "int";

        }
			| expression SEMICOLON 
            {
                $$= new SymbolInfo($1->getName()+ ";\n", "NON-TERMINAL");
                fprintf(logout, "Line %d: expression_statement 	: expression SEMICOLON \n\n", line_count);
                fprintf(logout, "%s;\n\n", $1->getName().c_str());

                $$->setRetType($1->getRetType());
                type= $1->getRetType();
            }
			;
	  
variable : id
        {
            $$= new SymbolInfo($1->getName(), "NON-TERMINAL");
            fprintf(logout, "Line %d: variable : ID\n\n", line_count);
            fprintf(logout, "%s\n\n", $1->getName().c_str());

            SymbolInfo *temp= st.lookUpAll($1->getName());

            if(temp != NULL && temp->getSize() != -1){
                if(temp->getSize() > -1){
                    error_type_mismatch( $1->getName()+ " is an array ");
                }else{
                    error_type_mismatch( $1->getName()+ " not a variable");
                }
                
            }

            if(temp == NULL){
                error_undeclared_var($1->getName());

                $$->setRetType("float");
            }else{
                if(temp->getRetType() != "void"){
                    $$->setRetType(temp->getRetType());
                }else{
                    $$->setRetType("float");
                }
            }


        }
	 | id LTHIRD expression RTHIRD 
     {
            $$= new SymbolInfo($1->getName()+ "["+ $3->getName()+ "]", "NON-TERMINAL");
            fprintf(logout, "Line %d: variable : ID LTHIRD expression RTHIRD \n\n", line_count);
            fprintf(logout, "%s[%s]\n\n", $1->getName().c_str(), $3->getName().c_str());
     
            SymbolInfo *temp= st.lookUpAll($1->getName());

            if(temp != NULL && temp->getSize() <= -1){
                if(temp->getSize() == -1){
                    error_type_mismatch( $1->getName()+ " is a variable ");
                }else{
                    error_type_mismatch( $1->getName()+ " not an array ");
                }
            }

            if($3->getRetType()== "void"){
                error_typecast_void();
            }

            if($3->getRetType() != "int"){
                error_array_index_invalid();
            }

            if(temp == NULL){
                error_undeclared_var($1->getName());

                $$->setRetType("float");
            }else{
                if(temp->getRetType() != "void"){
                    $$->setRetType(temp->getRetType());
                }else{
                    $$->setRetType("float");
                }
            }
     }
	 ;
	 
expression : logic_expression
        {
            $$= new SymbolInfo($1->getName(), "NON-TERMINAL");
            fprintf(logout, "Line %d: expression : logic_expression \n\n", line_count);
            fprintf(logout, "%s\n\n", $1->getName().c_str());

            $$->setRetType($1->getRetType());
            type= $1->getRetType();

        }
	   | variable ASSIGNOP logic_expression 
       {
            $$= new SymbolInfo($1->getName()+ "="+ $3->getName(), "NON-TERMINAL");
            fprintf(logout, "Line %d: expression : variable ASSIGNOP logic_expression \n\n", line_count);
            fprintf(logout, "%s=%s\n\n", $1->getName().c_str(), $3->getName().c_str());

            if($3->getRetType()== "void"){
                error_typecast_void();

                $3->setType("float");
            }

            if($1->getRetType() == "int" && $3->getRetType()== "float"){
                error_type_mismatch();
            }

            $$->setRetType($1->getRetType());
            type= $1->getRetType();
       }	
	   ;
			
logic_expression : rel_expression
        {
            $$= new SymbolInfo($1->getName(), "NON-TERMINAL");
            fprintf(logout, "Line %d: logic_expression : rel_expression \n\n", line_count);
            fprintf(logout, "%s\n\n", $1->getName().c_str());

            $$->setRetType($1->getRetType());
        }
		 | rel_expression LOGICOP rel_expression 
        {
            $$= new SymbolInfo($1->getName()+ $2->getName()+ $3->getName(), "NON-TERMINAL");
            fprintf(logout, "Line %d: logic_expression : rel_expression LOGICOP rel_expression \n\n", line_count);
            fprintf(logout, "%s%s%s\n\n", $1->getName().c_str(), $2->getName().c_str(), $3->getName().c_str());
        
            if($1->getRetType()== "void"){
                error_typecast_void();

            }

            if($3->getRetType()== "void"){
                error_typecast_void();

            }

            $$->setRetType("int");

        }	
		 ;
			
rel_expression	: simple_expression 
        {
            $$= new SymbolInfo($1->getName(), "NON-TERMINAL");
            fprintf(logout, "Line %d: rel_expression : simple_expression \n\n", line_count);
            fprintf(logout, "%s\n\n", $1->getName().c_str());

            $$->setRetType($1->getRetType());
        }
		| simple_expression RELOP simple_expression	
        {
            $$= new SymbolInfo($1->getName()+ $2->getName()+ $3->getName(), "NON-TERMINAL");
            fprintf(logout, "Line %d: rel_expression : simple_expression RELOP simple_expression \n\n", line_count);
            fprintf(logout, "%s%s%s\n\n", $1->getName().c_str(), $2->getName().c_str(), $3->getName().c_str());

            if($1->getRetType()== "void"){
                error_typecast_void();

            }

            if($3->getRetType()== "void"){
                error_typecast_void();

            }

            $$->setRetType("int");

        }	
		;
				
simple_expression : term 
        {
            $$= new SymbolInfo($1->getName(), "NON-TERMINAL");
            fprintf(logout, "Line %d: simple_expression : term \n\n", line_count);
            fprintf(logout, "%s\n\n", $1->getName().c_str());

            $$->setRetType($1->getRetType());
        }
		  | simple_expression ADDOP term 
        {
            $$= new SymbolInfo($1->getName()+ $2->getName()+ $3->getName(), "NON-TERMINAL");
            fprintf(logout, "Line %d: simple_expression : simple_expression ADDOP term  \n\n", line_count);
            fprintf(logout, "%s%s%s\n\n", $1->getName().c_str(), $2->getName().c_str(), $3->getName().c_str());
        
            if($1->getRetType()== "void"){
                error_typecast_void();

                $1->setRetType("float"); //default type
            }

            if($3->getRetType()== "void"){
                error_typecast_void();

                $3->setRetType("float"); //default type
            }

            if($1->getRetType()== "float" || $3->getRetType()== "float"){
                $$->setRetType("float");
            }else{
                $$->setRetType("int");
            }
        }
		  ;
					
term :	unary_expression
        {
            $$= new SymbolInfo($1->getName(), "NON-TERMINAL");
            fprintf(logout, "Line %d: term :unary_expression\n\n", line_count);
            fprintf(logout, "%s\n\n", $1->getName().c_str());

            $$->setRetType($1->getRetType());
        }
     |  term MULOP unary_expression
        {
            $$= new SymbolInfo($1->getName()+ $2->getName()+ $3->getName(), "NON-TERMINAL");
            fprintf(logout, "Line %d: term : term MULOP unary_expression  \n\n", line_count);
            fprintf(logout, "%s%s%s\n\n", $1->getName().c_str(), $2->getName().c_str(), $3->getName().c_str());

            if($1->getRetType()== "void"){
                error_typecast_void();

                $1->setRetType("float"); //default type
            }

            if($3->getRetType()== "void"){
                error_typecast_void();

                $3->setRetType("float"); //default type
            }

            if($2->getName() != "%" && ($1->getRetType()== "float" || $3->getRetType()== "float" )){
                $$->setRetType("float");
            }else if($2->getName() == "%" ){
                if(($1->getRetType()== "float" || $3->getRetType()== "float" )){
                    error_type_cast_mod();

                    $$->setRetType("int");
                }if($3->getName()== "0"){
                    error_modzero();
                }

            }else{
                $$->setRetType($1->getRetType());
            }
        }
     ;

unary_expression : ADDOP unary_expression  
        {
            $$= new SymbolInfo($1->getName()+ $2->getName(), "NON-TERMINAL");
            fprintf(logout, "Line %d: unary_expression : ADDOP unary_expression  \n\n", line_count);
            fprintf(logout, "%s%s\n\n", $1->getName().c_str(), $2->getName().c_str());

            if($2->getRetType()== "void"){
                error_typecast_void();

            $2->setRetType("float"); //default type
            }

            $$->setRetType($2->getRetType());
        }
		 | NOT unary_expression 
        {
            $$= new SymbolInfo("!"+ $2->getName(), "NON-TERMINAL");
            fprintf(logout, "Line %d: unary_expression : NOT unary_expression  \n\n", line_count);
            fprintf(logout, "!%s\n\n", $2->getName().c_str());

            if($2->getRetType()== "void"){
                error_typecast_void();
            }

            $$->setRetType("int");
        }
		 | factor 
        {
            $$= new SymbolInfo($1->getName(), "NON-TERMINAL");
            fprintf(logout, "Line %d: unary_expression : factor  \n\n", line_count);
            fprintf(logout, "%s\n\n", $1->getName().c_str());

            $$->setRetType($1->getRetType());
        }
		 ;
	
factor	: variable 
        {
            $$= new SymbolInfo($1->getName(), "NON-TERMINAL");
            fprintf(logout, "Line %d: factor: variable   \n\n", line_count);
            fprintf(logout, "%s\n\n", $1->getName().c_str());

            $$->setRetType($1->getRetType());

        }
	| id LPAREN argument_list RPAREN
        {
            $$= new SymbolInfo($1->getName()+ "("+ $3->getName()+ ")", "NON-TERMINAL");
            fprintf(logout, "Line %d: factor:  ID LPAREN argument_list RPAREN  \n\n", line_count);
            fprintf(logout, "%s(%s)\n\n", $1->getName().c_str(), $3->getName().c_str());

            //check argument list with parameter list
            SymbolInfo* temp= st.lookUpAll($1->getName());
            if(temp == NULL){
               error_undeclared_func($1->getName());

               $$->setRetType("float");
            } else if(temp->getSize() != -3){
                error_not_function($1->getName());

                $$->setRetType("float");

            }

            else{
                if(temp->getParamSize()==1 && arg_list.size()== 0 && temp->getParam(0).par_type== "void"){
                    
                    $$->setRetType(temp->getRetType());
                }else if(temp->getParamSize() != arg_list.size()){
                    error_inconsistent_func_size(temp->getName());

                    $$->setRetType(temp->getRetType());
                }else{
                ///size same, type checking

                    int i=0;
                    while(i< arg_list.size()){
                    if(temp->getParam(i).par_type != arg_list[i]){
                            break;
                        }
                        i++;
                    }

                    if(i== arg_list.size()){
                        $$->setRetType(temp->getRetType());
                    }else{
                        i++;
                        error_inconsistent_func_type(i, temp->getName());

                        $$->setRetType(temp->getRetType());
                    }
                }

            }

            arg_list.clear();
        }
	| LPAREN expression RPAREN
        {
            $$= new SymbolInfo("("+ $2->getName()+ ")", "NON-TERMINAL");
            fprintf(logout, "Line %d: factor: LPAREN expression RPAREN  \n\n", line_count);
            fprintf(logout, "(%s)\n\n", $2->getName().c_str());

            if($2->getRetType()== "void"){
                error_typecast_void();

                $$->setRetType("float");
            }

            $$->setRetType($2->getRetType());


        }
	| CONST_INT 
        {
            $$= new SymbolInfo($1->getName(), "NON-TERMINAL");
            fprintf(logout, "Line %d: factor : CONST_INT  \n\n", line_count);
            fprintf(logout, "%s\n\n", $1->getName().c_str());

            $$->setRetType("int");
        }
	| CONST_FLOAT
        {
            $$= new SymbolInfo($1->getName(), "NON-TERMINAL");
            fprintf(logout, "Line %d: factor : CONST_FLOAT  \n\n", line_count);
            fprintf(logout, "%s\n\n", $1->getName().c_str());

            $$->setRetType("float");
        }
	| variable INCOP 
        {
            $$= new SymbolInfo($1->getName()+ "++", "NON-TERMINAL");
            fprintf(logout, "Line %d: factor : variable INCOP  \n\n", line_count);
            fprintf(logout, "%s++\n\n", $1->getName().c_str());

            $$->setRetType($1->getRetType());
        }
	| variable DECOP
        {
            $$= new SymbolInfo($1->getName()+ "--", "NON-TERMINAL");
            fprintf(logout, "Line %d: factor : variable DECOP  \n\n", line_count);
            fprintf(logout, "%s--\n\n", $1->getName().c_str());

            $$->setRetType($1->getRetType());
        }
	;
	
argument_list : arguments
        {
            $$= new SymbolInfo($1->getName(), "NON-TERMINAL");
            fprintf(logout, "Line %d: argument_list : arguments  \n\n", line_count);
            fprintf(logout, "%s\n\n", $1->getName().c_str());
        }
			  |
        {
            $$= new SymbolInfo("", "NON-TERMINAL");
            fprintf(logout, "Line %d: argument_list : epsilon  \n\n", line_count);
            fprintf(logout, "\n\n");
        }
			  ;
	
arguments : arguments COMMA logic_expression
        {
            $$= new SymbolInfo($1->getName()+ ","+ $3->getName(), "NON-TERMINAL");
            fprintf(logout, "Line %d: arguments : arguments COMMA logic_expression  \n\n", line_count);
            fprintf(logout, "%s,%s\n\n", $1->getName().c_str(), $3->getName().c_str());

            if($3->getRetType()== "void"){
                error_typecast_void();

                $3->setRetType("float");
            }

            arg_list.push_back($3->getRetType());
        }
	      | logic_expression
        {
            $$= new SymbolInfo($1->getName(), "NON-TERMINAL");
            fprintf(logout, "Line %d: arguments : logic_expression \n\n", line_count);
            fprintf(logout, "%s\n\n", $1->getName().c_str());

            if($1->getRetType()== "void"){
                error_typecast_void();

                $1->setRetType("float");
            }

            arg_list.push_back($1->getRetType());
        
        }
	      ;
 
%%
int main(int argc,char *argv[])
{
    if(argc!=2){
		printf("Please provide input file name and try again\n");
		return 0;
	}
	
	FILE *fin=fopen(argv[1],"r");
	if(fin==NULL){
		printf("Cannot open specified file\n");
		return 0;
	}
	
	logout= fopen("1805064_log.txt","w");
	errout= fopen("1805064_error.txt","w");
	//assout= fopen("ass.asm","w");

	yyin= fin;
	yyparse();
    st.printAll(logout);
    fprintf(logout, "Total lines: %d\n", line_count);
    fprintf(logout, "Total errors: %d", error);
	fclose(yyin);
	fclose(logout);
	fclose(errout);
	//fclose(assout);
 
}

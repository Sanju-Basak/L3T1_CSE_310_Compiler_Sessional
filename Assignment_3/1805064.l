%option noyywrap

%{
#include<iostream>
#include<cstdlib>
#include<cstring>
#include<algorithm>
#include "1805064_SymbolTable.h"
#include "y.tab.h"

using namespace std;


extern YYSTYPE yylval;
extern SymbolTable st;



string str1;
string str2;

string str_com;

int line_count=1;
int counter= 0;
int error= 0;

extern FILE *logout;
extern FILE *errout;



%}

WHITESPACE [ \t\f\r\v]+ 
LETTER [a-zA-Z]
DIGIT [0-9]
NEWLINE \n

%%
{WHITESPACE} {}
{NEWLINE} {line_count++;}

"if"	{return IF;}

"for"  {return FOR;}

"int"  {return INT;}

"float" {return FLOAT;}

"void"  {return VOID;}

"else"  {return ELSE;}

"while" {return WHILE;}

"return"    {return RETURN;}

"printf"    {return PRINTLN;}

		


"+"		|
"-"		{
			 SymbolInfo *s= new  SymbolInfo(yytext, "ADDOP"); yylval.symbolInfo = s; return ADDOP;
           
		}

"*"     |
"/"     |
"%"     {
            SymbolInfo *s= new  SymbolInfo(yytext, "MULOP"); yylval.symbolInfo = s; return MULOP;
        }

"++"    {
             return INCOP;
        }

"--"    {
             return DECOP;
        }

"<"     |
"<="    |
">"     |
">="    |
"=="    |
"!="    {
            SymbolInfo *s= new  SymbolInfo(yytext, "RELOP"); yylval.symbolInfo = s; return RELOP;
        }

"="     {
            return ASSIGNOP;
        }

"&&"    |
"||"    {
            SymbolInfo *s= new  SymbolInfo(yytext, "LOGICOP"); yylval.symbolInfo = s; return LOGICOP;
        }

"!"     {
            return NOT;
        }

"("     {
            return LPAREN;
        }

")"     {
            return RPAREN;
        }

"{"     {
            return LCURL; //enterScope
        }

"}"     {
            return RCURL; //exitScope
        }

"["     {
            return LTHIRD;
        }

"]"     {
            return RTHIRD;
        }

","     {
            return COMMA;
        }

";"     {
            return SEMICOLON;
        }
		
{DIGIT}+ 	{
		SymbolInfo *s= new  SymbolInfo(yytext, "CONST_INT");
                yylval.symbolInfo = s;
                return CONST_INT;
			}

{DIGIT}*("."{DIGIT}+)?("E"[-]?{DIGIT}+)?    {
                SymbolInfo *s= new  SymbolInfo(yytext, "CONST_FLOAT");
                yylval.symbolInfo = s;
                return CONST_FLOAT;

            }

({LETTER}|_)({LETTER}|{DIGIT}|_)*  {
                SymbolInfo *s= new  SymbolInfo(yytext, "ID");
                yylval.symbolInfo = s;
                return ID;
        }


{DIGIT}*"."{DIGIT}*"."({DIGIT}|".")*  {
        error++;
        fprintf(logout, "Error at line no %d: Too many decimal point error %s\n\n", line_count, yytext); 
        fprintf(errout, "Error at line no %d: Too many decimal point error %s\n\n", line_count, yytext);

}

{DIGIT}*("."{DIGIT}+)?("E"[-]?{DIGIT}*"."{DIGIT}*)    {
        error++;
        fprintf(logout, "Error at line no %d: Ill formed number %s\n\n", line_count, yytext);
        fprintf(errout, "Error at line no %d: Ill formed number %s\n\n", line_count, yytext); 
}

{DIGIT}+({LETTER}|_)({LETTER}|{DIGIT}|_)+   {
        error++;
        fprintf(logout, "Error at line no %d: Invalid prefix on ID or invalid suffix on Number %s\n\n", line_count, yytext);
        fprintf(errout, "Error at line no %d: Invalid prefix on ID or invalid suffix on Number %s\n\n", line_count, yytext);
}



.   {
        error++;
        fprintf(logout, "Error at line no %d: Unrecognized Character %s\n\n", line_count, yytext);
        fprintf(errout, "Error at line no %d: Unrecognized Character %s\n\n", line_count, yytext);    
}


%%

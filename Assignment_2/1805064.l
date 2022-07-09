%option noyywrap

%x string_st
%x COMMENT_SINGLE
%x COMMENT_DOUBLE

%{
#include<iostream>
#include<cstdlib>
#include<cstring>
#include<algorithm>
#include "1805064_SymbolTable.h"
using namespace std;

FILE *logout;
FILE *tokenout;

string str1;
string str2;

string str_com;

int counter= 0;
int error= 0;

SymbolTable st;

int line_count=1;

%}

WHITESPACE [ \t\f\r\v]+ 
LETTER [a-zA-Z]
DIGIT [0-9]
NEWLINE \n

%%
{WHITESPACE} {}
{NEWLINE} {line_count++;}

"if"	|

"for"   |

"do"    |

"int"   |

"float" |

"void"  |

"switch"    |

"default"   |

"else"  |

"while" |

"break" |

"char"  |

"double"    |

"return"    |

"case"  |

"continue"  {
            string strName = string(yytext);
            transform(strName.begin(), strName.end(), strName.begin(), ::toupper);
            const char *s= strName.c_str();
			fprintf(tokenout,"<%s> ", s);
			fprintf(logout,"Line no %d: TOKEN <%s> Lexeme %s found\n\n",line_count,s,yytext);
		}
		


"+"		|

"-"		{
			fprintf(tokenout,"<ADDOP, %s> ",yytext);
			fprintf(logout,"Line no %d: TOKEN <ADDOP> Lexeme %s found\n\n",line_count,yytext);
           
		}

"*"     |
"/"     |
"%"     {
            fprintf(tokenout,"<MULOP, %s> ",yytext);
			fprintf(logout,"Line no %d: TOKEN <MULOP> Lexeme %s found\n\n",line_count,yytext);
        }

"++"    |
"--"    {
            fprintf(tokenout,"<INCOP, %s> ",yytext);
			fprintf(logout,"Line no %d: TOKEN <INCOP> Lexeme %s found\n\n",line_count,yytext);
        }
"<"     |
"<="    |
">"     |
">="    |
"=="    |
"!="    {
            fprintf(tokenout,"<RELOP, %s> ",yytext);
			fprintf(logout,"Line no %d: TOKEN <RELOP> Lexeme %s found\n\n",line_count,yytext);
        }

"="     {
            fprintf(tokenout,"<ASSIGNOP, %s> ",yytext);
			fprintf(logout,"Line no %d: TOKEN <ASSIGNOP> Lexeme %s found\n\n",line_count,yytext);
        }

"&&"    |
"||"    {
            fprintf(tokenout,"<LOGICOP, %s> ",yytext);
			fprintf(logout,"Line no %d: TOKEN <LOGICOP> Lexeme %s found\n\n",line_count,yytext);
        }

"!"     {
            fprintf(tokenout,"<NOT, %s> ",yytext);
			fprintf(logout,"Line no %d: TOKEN <NOT> Lexeme %s found\n\n",line_count,yytext);
        }

"("     {
            fprintf(tokenout,"<LPAREN, %s> ",yytext);
			fprintf(logout,"Line no %d: TOKEN <LPAREN> Lexeme %s found\n\n",line_count,yytext);
        }

")"     {
            fprintf(tokenout,"<RPAREN, %s> ",yytext);
			fprintf(logout,"Line no %d: TOKEN <RPAREN> Lexeme %s found\n\n",line_count,yytext);
        }

"{"     {
            fprintf(tokenout,"<LCURL, %s> ",yytext);
			fprintf(logout,"Line no %d: TOKEN <LCURL> Lexeme %s found\n\n",line_count,yytext);
            st.EnterScope();
        }

"}"     {
            fprintf(tokenout,"<RCURL, %s> ",yytext);
			fprintf(logout,"Line no %d: TOKEN <RCURL> Lexeme %s found\n\n",line_count,yytext);
            st.ExitScope();
        }

"["     {
            fprintf(tokenout,"<LTHIRD, %s> ",yytext);
			fprintf(logout,"Line no %d: TOKEN <LTHRID> Lexeme %s found\n\n",line_count,yytext);
        }

"]"     {
            fprintf(tokenout,"<RTHIRD, %s> ",yytext);
			fprintf(logout,"Line no %d: TOKEN <RTHRID> Lexeme %s found\n\n",line_count,yytext);
        }

","     {
            fprintf(tokenout,"<COMMA, %s> ",yytext);
			fprintf(logout,"Line no %d: TOKEN <COMMA> Lexeme %s found\n\n",line_count,yytext);
        }

";"     {
            fprintf(tokenout,"<SEMICOLON, %s> ",yytext);
			fprintf(logout,"Line no %d: TOKEN <SEMICOLON> Lexeme %s found\n\n",line_count,yytext);
        }
		
{DIGIT}+ 	{
				fprintf(tokenout,"<CONST_INT, %s> ",yytext);
				fprintf(logout,"Line no %d: TOKEN <CONST_INT> Lexeme %s found\n\n",line_count,yytext);
                if(!st.insert(yytext, "CONST_INT")){
                    fprintf(logout, "%s already exists in current ScopeTable\n\n", yytext);
                }
                else{
                    st.printAll(logout);
                }
			}

{DIGIT}*("."{DIGIT}+)?("E"[-]?{DIGIT}+)?    {
                fprintf(tokenout,"<CONST_FLOAT, %s> ",yytext);
				fprintf(logout,"Line no %d: TOKEN <CONST_FLOAT> Lexeme %s found\n\n",line_count,yytext);
                if(!st.insert(yytext, "CONST_FLOAT")){
                    fprintf(logout, "%s already exists in current ScopeTable\n\n", yytext);
                }
                else{
                    st.printAll(logout);
                }

            }

({LETTER}|_)({LETTER}|{DIGIT}|_)*  {
                fprintf(tokenout,"<ID, %s> ",yytext);
				fprintf(logout,"Line no %d: TOKEN <ID> Lexeme %s found\n\n",line_count,yytext);
                if(!st.insert(yytext, "ID")){
                    fprintf(logout, "%s already exists in current ScopeTable\n\n", yytext);
                }
                else{
                    st.printAll(logout);
                }
        }

'{LETTER}'  {
                string str;
                str= str+ yytext[1];
                fprintf(tokenout,"<CONST_CHAR, %s> ",str.c_str());
				fprintf(logout,"Line no %d: TOKEN <CONST_CHAR> Lexeme %s found --> <CHAR_CONST, %s>\n\n",line_count,yytext, str.c_str());
                if(!st.insert(yytext, "CONST_CHAR")){
                    fprintf(logout, "%s already exists in current ScopeTable\n\n", yytext);
                }
                else{
                    st.printAll(logout);
                }
            }

'\\n'        {
                string str= "\n";
                fprintf(tokenout,"<CONST_CHAR, %s> ",str.c_str());
				fprintf(logout,"Line no %d: TOKEN <CONST_CHAR> Lexeme %s found --> <CHAR_CONST, %s>\n\n",line_count,yytext, str.c_str());
                if(!st.insert(yytext, "CONST_CHAR")){
                    fprintf(logout, "%s already exists in current ScopeTable\n\n", yytext);
                }
                else{
                    st.printAll(logout);
                }
            }  

'\\t'        {
                string str= "\t";
                fprintf(tokenout,"<CONST_CHAR, %s> ",str.c_str());
				fprintf(logout,"Line no %d: TOKEN <CONST_CHAR> Lexeme %s found --> <CHAR_CONST, %s>\n\n",line_count,yytext, str.c_str());
                if(!st.insert(yytext, "CONST_CHAR")){
                    fprintf(logout, "%s already exists in current ScopeTable\n\n", yytext);
                }
                else{
                    st.printAll(logout);
                }
            }            

'\\\\'        {
                string str= "\\";
                fprintf(tokenout,"<CONST_CHAR, %s> ",str.c_str());
				fprintf(logout,"Line no %d: TOKEN <CONST_CHAR> Lexeme %s found --> <CHAR_CONST, %s>\n\n",line_count,yytext, str.c_str());
                if(!st.insert(yytext, "CONST_CHAR")){
                    fprintf(logout, "%s already exists in current ScopeTable\n\n", yytext);
                }
                else{
                    st.printAll(logout);
                }
            }

'\\\''        {
                string str= "\'";
                fprintf(tokenout,"<CONST_CHAR, %s> ",str.c_str());
				fprintf(logout,"Line no %d: TOKEN <CONST_CHAR> Lexeme %s found --> <CHAR_CONST, %s>\n\n",line_count,yytext, str.c_str());
                if(!st.insert(yytext, "CONST_CHAR")){
                    fprintf(logout, "%s already exists in current ScopeTable\n\n", yytext);
                }
                else{
                    st.printAll(logout);
                }
            } 

'\\a'        {
                string str= "\a";
                fprintf(tokenout,"<CONST_CHAR, %s> ",str.c_str());
				fprintf(logout,"Line no %d: TOKEN <CONST_CHAR> Lexeme %s found --> <CHAR_CONST, %s>\n\n",line_count,yytext, str.c_str());
                if(!st.insert(yytext, "CONST_CHAR")){
                    fprintf(logout, "%s already exists in current ScopeTable\n\n", yytext);
                }
                else{
                    st.printAll(logout);
                }
            } 

'\\f'        {
                string str= "\f";
                fprintf(tokenout,"<CONST_CHAR, %s> ",str.c_str());
				fprintf(logout,"Line no %d: TOKEN <CONST_CHAR> Lexeme %s found --> <CHAR_CONST, %s>\n\n",line_count,yytext, str.c_str());
                if(!st.insert(yytext, "CONST_CHAR")){
                    fprintf(logout, "%s already exists in current ScopeTable\n\n", yytext);
                }
                else{
                    st.printAll(logout);
                }
            } 

'\\r'        {
                string str= "\r";
                fprintf(tokenout,"<CONST_CHAR, %s> ",str.c_str());
				fprintf(logout,"Line no %d: TOKEN <CONST_CHAR> Lexeme %s found --> <CHAR_CONST, %s>\n\n",line_count,yytext, str.c_str());
                if(!st.insert(yytext, "CONST_CHAR")){
                    fprintf(logout, "%s already exists in current ScopeTable\n\n", yytext);
                }
                else{
                    st.printAll(logout);
                }
            } 

'\\b'        {
                string str= "\b";
                fprintf(tokenout,"<CONST_CHAR, %s> ",str.c_str());
				fprintf(logout,"Line no %d: TOKEN <CONST_CHAR> Lexeme %s found --> <CHAR_CONST, %s>\n\n",line_count,yytext, str.c_str());
                if(!st.insert(yytext, "CONST_CHAR")){
                    fprintf(logout, "%s already exists in current ScopeTable\n\n", yytext);
                }
                else{
                    st.printAll(logout);
                }
            } 

'\\v'        {
                string str= "\v";
                fprintf(tokenout,"<CONST_CHAR, %s> ",str.c_str());
				fprintf(logout,"Line no %d: TOKEN <CONST_CHAR> Lexeme %s found --> <CHAR_CONST, %s>\n\n",line_count,yytext, str.c_str());
                if(!st.insert(yytext, "CONST_CHAR")){
                    fprintf(logout, "%s already exists in current ScopeTable\n\n", yytext);
                }
                else{
                    st.printAll(logout);
                }
            } 

'\\0'        {
                string str= "\0";
                fprintf(tokenout,"<CONST_CHAR, %s> ",str.c_str());
				fprintf(logout,"Line no %d: TOKEN <CONST_CHAR> Lexeme %s found --> <CHAR_CONST, %s>\n\n",line_count,yytext, str.c_str());
                if(!st.insert(yytext, "CONST_CHAR")){
                    fprintf(logout, "%s already exists in current ScopeTable\n\n", yytext);
                }
                else{
                    st.printAll(logout);
                }
            } 
			
\"		{
				str1.clear();
				str2.clear();
				counter= 0;
				str1 += "\"";
				str2 += "\"";
				BEGIN string_st;
		}
<string_st>\\n	{ str1 += "\\n"; str2 += "\n";  }
<string_st>\\t	{ str1 += "\\t"; str2 += "\t" ; }
<string_st>\\\\	{ str1 += "\\\\"; str2 += "\\" ; }
<string_st>\\\'	{ str1 += "\\\'"; str2 += "\'";  }
<string_st>\\\"	{ str1 += "\\\""; str2 += "\"";  }
<string_st>\\a	{ str1 += "\\a"; str2 += "\a";  }
<string_st>\\f	{ str1 += "\\f"; str2 += "\f";  }
<string_st>\\r	{ str1 += "\\r"; str2 += "\r";  }
<string_st>\\b	{ str1 += "\\b"; str2 += "\b";  }
<string_st>\\v	{ str1 += "\\v"; str2 += "\v";  }
<string_st>\\0	{ str1 += "\\0"; str2 += "\0";  }

<string_st>\\\r\n {
					counter++;
					str1 += "\\\r\n"; 
					//str2 += "\r\n";
				}

<string_st>\\\n {
					counter++;
					str1 += "\\\n"; 
					//str2 += "\n";
				}

<string_st>\"   {
					str1 += "\"";
					str2 += "\"";
					fprintf(logout, "Line no %d: Token <STRING> Lexeme %s found --> <STRING, %s> \n\n", line_count, str1.c_str(), str2.c_str());
                    fprintf(tokenout,"<STRING, %s> ",str2.c_str());
                    line_count= line_count+ counter;
                    counter= 0;
					BEGIN INITIAL;	
				}
<string_st>[\r]?\n    {
                                       
                    error++;
                    fprintf(logout, "Error at line no %d: Unterminated String %s\n\n", line_count, str1.c_str());
                    counter++;
                    line_count= line_count+ counter;
                    counter= 0;
                    BEGIN INITIAL;

                }

<string_st>.	{ str1 += yytext[0]; str2 += yytext[0];}

\/\/       {
                str_com.clear();
                counter= 0;
                str_com+= "//";

                BEGIN COMMENT_SINGLE;
            }

<COMMENT_SINGLE>\\\r\n  {
                counter++;
                str_com+= "\\\r\n";

            }

<COMMENT_SINGLE>\\\n  {
                counter++;
                str_com+= "\\\n";

            }

<COMMENT_SINGLE>\\   {
                str_com+= "\\";
                }

<COMMENT_SINGLE>[\r]?\n {
                counter++;
                fprintf(logout, "Line no %d: Token <COMMENT> Lexeme %s found \n\n", line_count, str_com.c_str());
                line_count+= counter;
                counter=0;
                BEGIN INITIAL; 
            }     

<COMMENT_SINGLE><<EOF>> {
                fprintf(logout, "Line no %d: Token <COMMENT> Lexeme %s found \n\n", line_count, str_com.c_str());
                line_count+= counter;
                counter=0;
                BEGIN INITIAL; 
            }


<COMMENT_SINGLE>. { str_com+= yytext[0];}


\/\*    {
            str_com.clear();
            counter= 0;
            str_com+= "/*";
            BEGIN COMMENT_DOUBLE;
}

<COMMENT_DOUBLE>[\r]?\n {
            counter++;
            str_com+= "\n";
}

<COMMENT_DOUBLE>\*\/    {
            str_com+= "*/";
            fprintf(logout, "Line no %d: Token <COMMENT> Lexeme %s found \n\n", line_count, str_com.c_str());
            line_count+= counter;
            counter= 0;
            BEGIN INITIAL;
}

<COMMENT_DOUBLE><<EOF>> {
            error++;
            fprintf(logout, "Error at line no %d: Unterminated Comment %s\n\n", line_count, str_com.c_str());
            line_count+= counter;
            counter= 0;
            BEGIN INITIAL;
}

<COMMENT_DOUBLE>.   {
            str_com+= yytext[0];
}

{DIGIT}*"."{DIGIT}*"."({DIGIT}|".")*  {
        error++;
        fprintf(logout, "Error at line no %d: Too many decimal point error %s\n\n", line_count, yytext); 
}

{DIGIT}*("."{DIGIT}+)?("E"[-]?{DIGIT}*"."{DIGIT}*)    {
        error++;
        fprintf(logout, "Error at line no %d: Ill formed number %s\n\n", line_count, yytext); 
}

{DIGIT}+({LETTER}|_)({LETTER}|{DIGIT}|_)+   {
        error++;
        fprintf(logout, "Error at line no %d: Invalid prefix on ID or invalid suffix on Number %s\n\n", line_count, yytext);
}

'{LETTER}[^\n]+' {
        error++;
        fprintf(logout, "Error at line no %d: Multi character constant error %s\n\n", line_count, yytext);
}

'\\'     {
        error++;
        fprintf(logout, "Error at line no %d: Unterminated character %s\n\n", line_count, yytext);
        }
'\\[nt\\afrbv0] {
        error++;
        fprintf(logout, "Error at line no %d: Unterminated character %s\n\n", line_count, yytext);
}

''      {
        error++;
        fprintf(logout, "Error at line no %d: Empty character constant error %s\n\n", line_count, yytext);
        }

'[^\'\n]+     {
        error++;
        fprintf(logout, "Error at line no %d: Unterminated character %s\n\n", line_count, yytext);
}

.   {
        error++;
        fprintf(logout, "Error at line no %d: Unrecognized Character %s\n\n", line_count, yytext);    
}


%%

int main(int argc,char *argv[]){
	
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
	tokenout= fopen("1805064_token.txt","w");

	yyin= fin;
	yylex();
    st.printAll(logout);
    fprintf(logout, "Total lines: %d\n", line_count);
    fprintf(logout, "Total errors: %d", error);
	fclose(yyin);
	fclose(tokenout);
	fclose(logout);
	return 0;
}

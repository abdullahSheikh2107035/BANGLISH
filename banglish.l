%option noyywrap noinput nounput yylineno
%{
#include <cstdlib>
#include <cstring>
#include <string>
#include "banglish.tab.h"

extern int yylineno;

static std::string unquote_string(const char *text) {
    std::string value(text);
    if (value.size() >= 2 && value.front() == '"' && value.back() == '"') {
        value.erase(value.begin());
        value.pop_back();
    }
    return value;
}

static char unquote_char(const char *text) {
    if (text[0] != '\'' || text[strlen(text)-1] != '\'') {
        return text[0]; // error
    }
    if (strlen(text) == 3 && text[1] != '\\') {
        return text[1];
    }
    if (strlen(text) == 4 && text[1] == '\\') {
        // handle escape
        switch (text[2]) {
            case 'n': return '\n';
            case 't': return '\t';
            case 'r': return '\r';
            case '\\': return '\\';
            case '\'': return '\'';
            default: return text[2];
        }
    }
    return text[1]; // error
}
%}

DIGIT [0-9]
ID [a-zA-Z_][a-zA-Z0-9_]*
FLOAT {DIGIT}+\.{DIGIT}+
STRING \"([^\"\\]|\\.)*\"
CHAR \'[^\']*\'

%%

"//".*                     ;
[ \t\r\n]+                 ;
"=="                       return EQ;
"!="                       return NEQ;
"<="                       return LE;
">="                       return GE;
"&&"                       return ANDAND;
"||"                       return OROR;
"|>"                       return PIPE;
"+="                       return PLUS_ASSIGN;
"-="                       return MINUS_ASSIGN;
"*="                       return STAR_ASSIGN;
"/="                       return SLASH_ASSIGN;
"%="                       return PERCENT_ASSIGN;
"("                        return LPAREN;
")"                        return RPAREN;
"{"                        return LBRACE;
"}"                        return RBRACE;
"["                        return LBRACKET;
"]"                        return RBRACKET;
";"                        return SEMICOLON;
","                        return COMMA;
"="                        return ASSIGN;
"+"                        return PLUS;
"-"                        return MINUS;
"*"                        return STAR;
"/"                        return SLASH;
"%"                        return PERCENT;
"<"                        return LT;
">"                        return GT;
{FLOAT}                     { yylval.floatValue = atof(yytext); return FLOAT_LITERAL; }
{DIGIT}+                    { yylval.intValue = atoi(yytext); return INT_LITERAL; }
{STRING}                    {
                                std::string *value = new std::string(unquote_string(yytext));
                                yylval.stringValue = value;
                                return STRING_LITERAL;
                              }
{CHAR}                      {
                                yylval.charValue = unquote_char(yytext);
                                return CHAR_LITERAL;
                              }
{ID}                        {
                                std::string text(yytext);
                                if (text == "purno") return PURNO;
                                if (text == "dosomik") return DOSOMIK;
                                if (text == "b_dosomik") return BDOSOMIK;
                                if (text == "okkhor") return OKKHOR;
                                if (text == "janina") return JANINA;
                                if (text == "sobdo") return SOBDO;
                                if (text == "drubo") return DRUBO;
                                if (text == "faka") return FAKA;
                                if (text == "jodi") return JODI;
                                if (text == "notuba") return NOTUBA;
                                if (text == "ar_jodi") return AR_JODI;
                                if (text == "jotokkhn") return JOTOKKHN;
                                if (text == "ttokkhn") return TTOKKHN;
                                if (text == "vango") return VANGO;
                                if (text == "calao") return CALAO;
                                if (text == "fero") return FERO;
                                if (text == "thik") return THIK;
                                if (text == "bhul") return BHUL;
                                yylval.stringValue = new std::string(text);
                                return IDENTIFIER;
                              }
.                           { fprintf(stderr, "Unknown character '%s' at line %d\n", yytext, yylineno); }

%%

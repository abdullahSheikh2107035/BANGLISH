
/* A Bison parser, made by GNU Bison 2.4.1.  */

/* Skeleton interface for Bison's Yacc-like parsers in C
   
      Copyright (C) 1984, 1989, 1990, 2000, 2001, 2002, 2003, 2004, 2005, 2006
   Free Software Foundation, Inc.
   
   This program is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.
   
   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.
   
   You should have received a copy of the GNU General Public License
   along with this program.  If not, see <http://www.gnu.org/licenses/>.  */

/* As a special exception, you may create a larger work that contains
   part or all of the Bison parser skeleton and distribute that work
   under terms of your choice, so long as that work isn't itself a
   parser generator using the skeleton or a modified version thereof
   as a parser skeleton.  Alternatively, if you modify or redistribute
   the parser skeleton itself, you may (at your option) remove this
   special exception, which will cause the skeleton and the resulting
   Bison output files to be licensed under the GNU General Public
   License without this special exception.
   
   This special exception was added by the Free Software Foundation in
   version 2.2 of Bison.  */

/* "%code requires" blocks.  */

/* Line 1676 of yacc.c  */
#line 31 "banglish.y"

#include "ast.h"



/* Line 1676 of yacc.c  */
#line 46 "banglish.tab.h"

/* Tokens.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
   /* Put the tokens into the symbol table, so that GDB and other debuggers
      know about them.  */
   enum yytokentype {
     INT_LITERAL = 258,
     FLOAT_LITERAL = 259,
     STRING_LITERAL = 260,
     CHAR_LITERAL = 261,
     IDENTIFIER = 262,
     PURNO = 263,
     DOSOMIK = 264,
     BDOSOMIK = 265,
     OKKHOR = 266,
     JANINA = 267,
     SOBDO = 268,
     DRUBO = 269,
     FAKA = 270,
     JODI = 271,
     NOTUBA = 272,
     AR_JODI = 273,
     JOTOKKHN = 274,
     TTOKKHN = 275,
     VANGO = 276,
     CALAO = 277,
     FERO = 278,
     THIK = 279,
     BHUL = 280,
     PLUS = 281,
     MINUS = 282,
     STAR = 283,
     SLASH = 284,
     PERCENT = 285,
     ASSIGN = 286,
     EQ = 287,
     NEQ = 288,
     LT = 289,
     LE = 290,
     GT = 291,
     GE = 292,
     ANDAND = 293,
     OROR = 294,
     PIPE = 295,
     PLUS_ASSIGN = 296,
     MINUS_ASSIGN = 297,
     STAR_ASSIGN = 298,
     SLASH_ASSIGN = 299,
     PERCENT_ASSIGN = 300,
     LPAREN = 301,
     RPAREN = 302,
     LBRACE = 303,
     RBRACE = 304,
     LBRACKET = 305,
     RBRACKET = 306,
     SEMICOLON = 307,
     COMMA = 308
   };
#endif



#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
typedef union YYSTYPE
{

/* Line 1676 of yacc.c  */
#line 15 "banglish.y"

    int intValue;
    double floatValue;
    std::string *stringValue;
    char charValue;
    banglish::Expr *expr;
    banglish::Stmt *stmt;
    banglish::Program *program;
    banglish::FunctionDecl *function;
    banglish::TypeSpec *type;
    banglish::Param *param;
    std::vector<banglish::Param *> *paramList;
    std::vector<banglish::Stmt *> *stmtList;
    std::vector<banglish::Expr *> *exprList;



/* Line 1676 of yacc.c  */
#line 134 "banglish.tab.h"
} YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define yystype YYSTYPE /* obsolescent; will be withdrawn */
# define YYSTYPE_IS_DECLARED 1
#endif

extern YYSTYPE yylval;



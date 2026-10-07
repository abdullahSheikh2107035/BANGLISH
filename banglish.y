%{
#include <cstdio>
#include <cstdlib>
#include <vector>
#include <string>
#include "ast.h"

extern int yylex();
extern int yylineno;
void yyerror(const char *s);

banglish::Program *rootProgram = nullptr;
%}

%union {
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
}

%code requires {
#include "ast.h"
}

%token <intValue> INT_LITERAL
%token <floatValue> FLOAT_LITERAL
%token <stringValue> STRING_LITERAL
%token <charValue> CHAR_LITERAL
%token <stringValue> IDENTIFIER
%token PURNO DOSOMIK BDOSOMIK OKKHOR JANINA SOBDO DRUBO FAKA
%token JODI NOTUBA AR_JODI JOTOKKHN TTOKKHN VANGO CALAO FERO
%token THIK BHUL
%token PLUS MINUS STAR SLASH PERCENT ASSIGN EQ NEQ LT LE GT GE
%token ANDAND OROR PIPE
%token PLUS_ASSIGN MINUS_ASSIGN STAR_ASSIGN SLASH_ASSIGN PERCENT_ASSIGN
%token LPAREN RPAREN LBRACE RBRACE LBRACKET RBRACKET SEMICOLON COMMA

%type <program> program function_list
%type <function> function
%type <type> type_spec base_type
%type <param> param
%type <paramList> param_list
%type <stmt> block if_stmt while_stmt for_stmt for_init variable_decl_no_semicolon expr_stmt statement return_stmt break_stmt continue_stmt variable_decl else_clause
%type <expr> expression assignment pipe_expression logical_or logical_and equality comparison term factor unary call primary array_spec initializer_opt array_initializer for_condition for_increment
%type <exprList> expr_list arg_list
%type <stmtList> block_contents

%left OROR
%left ANDAND
%left EQ NEQ
%left LT LE GT GE
%left PLUS MINUS
%left STAR SLASH PERCENT
%right ASSIGN PLUS_ASSIGN MINUS_ASSIGN STAR_ASSIGN SLASH_ASSIGN PERCENT_ASSIGN
%left PIPE

%%

program:
      function_list { $$ = $1; rootProgram = $1; }
    ;

function_list:
      function_list function { $1->functions.push_back($2); $$ = $1; }
    | function { $$ = new banglish::Program(); $$->functions.push_back($1); }
    ;

function:
      type_spec IDENTIFIER LPAREN param_list RPAREN block {
          $$ = new banglish::FunctionDecl(*$1, *$2, $6);
          if ($1) delete $1;
          if ($2) delete $2;
      }
    | type_spec IDENTIFIER LPAREN RPAREN block {
          $$ = new banglish::FunctionDecl(*$1, *$2, $5);
          if ($1) delete $1;
          if ($2) delete $2;
      }
    ;

param_list:
      param_list COMMA param { $1->push_back($3); $$ = $1; }
    | param { $$ = new std::vector<banglish::Param *>(); $$->push_back($1); }
    ;

param:
      type_spec IDENTIFIER {
          $$ = new banglish::Param();
          if ($1) {
              $$->type = *$1;
              delete $1;
          }
          $$->name = *$2;
          delete $2;
      }
    ;

block:
      LBRACE RBRACE { $$ = new banglish::BlockStmt(); }
    | LBRACE block_contents RBRACE { 
          banglish::BlockStmt *b = new banglish::BlockStmt(); 
          b->statements = std::move(*$2); 
          delete $2; 
          $$ = b; 
      }
    ;

block_contents:
      block_contents statement { $1->push_back($2); $$ = $1; }
    | statement { $$ = new std::vector<banglish::Stmt *>(); $$->push_back($1); }
    ;

statement:
      variable_decl
    | if_stmt
    | while_stmt
    | for_stmt
    | return_stmt
    | break_stmt
    | continue_stmt
    | expr_stmt
    | block
    ;

variable_decl:
      type_spec IDENTIFIER array_spec initializer_opt SEMICOLON {
          if ($3) {
              $1->isArray = true;
              $1->arraySize = $3;
          }
          $$ = new banglish::VariableDecl(*$1, *$2, $4);
          delete $1;
          delete $2;
      }
    ;

array_spec:
      LBRACKET expression RBRACKET { $$ = $2; }
    | { $$ = nullptr; }
    ;

initializer_opt:
      ASSIGN array_initializer { $$ = $2; }
    | ASSIGN expression { $$ = $2; }
    | { $$ = nullptr; }
    ;

array_initializer:
      LBRACE expr_list RBRACE {
          auto *expr = new banglish::ArrayLiteralExpr();
          expr->elements = std::move(*$2);
          delete $2;
          $$ = expr;
      }
    ;

expr_list:
      expr_list COMMA expression { $1->push_back($3); $$ = $1; }
    | expression { $$ = new std::vector<banglish::Expr *>(); $$->push_back($1); }
    ;

if_stmt:
      JODI LPAREN expression RPAREN block else_clause {
          $$ = new banglish::IfStmt($3, $5, $6);
      }
    ;

else_clause:
      { $$ = nullptr; }
    | NOTUBA block { $$ = $2; }
    | AR_JODI LPAREN expression RPAREN block else_clause {
          $$ = new banglish::IfStmt($3, $5, $6);
      }
    ;

while_stmt:
      JOTOKKHN LPAREN expression RPAREN block {
          $$ = new banglish::WhileStmt($3, $5);
      }
    ;

for_stmt:
      TTOKKHN LPAREN for_init SEMICOLON for_condition SEMICOLON for_increment RPAREN block {
          $$ = new banglish::ForStmt($3, $5, $7, $9);
      }
    ;

for_init:
      variable_decl_no_semicolon { $$ = $1; }
    | expression { $$ = new banglish::ExprStmt($1); }
    | { $$ = nullptr; }
    ;

variable_decl_no_semicolon:
      type_spec IDENTIFIER array_spec initializer_opt {
          if ($3) {
              $1->isArray = true;
              $1->arraySize = $3;
          }
          $$ = new banglish::VariableDecl(*$1, *$2, $4);
          delete $1;
          delete $2;
      }
    ;

for_condition:
      expression { $$ = $1; }
    | { $$ = nullptr; }
    ;

for_increment:
      expression { $$ = $1; }
    | { $$ = nullptr; }
    ;

return_stmt:
      FERO expression SEMICOLON { $$ = new banglish::ReturnStmt($2); }
    | FERO SEMICOLON { $$ = new banglish::ReturnStmt(nullptr); }
    ;

break_stmt:
      VANGO SEMICOLON { $$ = new banglish::BreakStmt(); }
    ;

continue_stmt:
      CALAO SEMICOLON { $$ = new banglish::ContinueStmt(); }
    ;

expr_stmt:
      expression SEMICOLON { $$ = new banglish::ExprStmt($1); }
    ;

expression:
      assignment
    ;

assignment:
      pipe_expression ASSIGN assignment { $$ = new banglish::BinaryExpr($1, banglish::BinaryOp::Assign, $3); }
    | pipe_expression PLUS_ASSIGN assignment { $$ = new banglish::BinaryExpr($1, banglish::BinaryOp::PlusAssign, $3); }
    | pipe_expression MINUS_ASSIGN assignment { $$ = new banglish::BinaryExpr($1, banglish::BinaryOp::MinusAssign, $3); }
    | pipe_expression STAR_ASSIGN assignment { $$ = new banglish::BinaryExpr($1, banglish::BinaryOp::MultiplyAssign, $3); }
    | pipe_expression SLASH_ASSIGN assignment { $$ = new banglish::BinaryExpr($1, banglish::BinaryOp::DivideAssign, $3); }
    | pipe_expression PERCENT_ASSIGN assignment { $$ = new banglish::BinaryExpr($1, banglish::BinaryOp::ModuloAssign, $3); }
    | pipe_expression { $$ = $1; }
    ;

pipe_expression:
      pipe_expression PIPE call { $$ = new banglish::PipeExpr($1, $3); }
    | logical_or { $$ = $1; }
    ;

logical_or:
      logical_or OROR logical_and { $$ = new banglish::BinaryExpr($1, banglish::BinaryOp::LogicalOr, $3); }
    | logical_and { $$ = $1; }
    ;

logical_and:
      logical_and ANDAND equality { $$ = new banglish::BinaryExpr($1, banglish::BinaryOp::LogicalAnd, $3); }
    | equality { $$ = $1; }
    ;

equality:
      equality EQ comparison { $$ = new banglish::BinaryExpr($1, banglish::BinaryOp::Equal, $3); }
    | equality NEQ comparison { $$ = new banglish::BinaryExpr($1, banglish::BinaryOp::NotEqual, $3); }
    | comparison { $$ = $1; }
    ;

comparison:
      comparison LT term { $$ = new banglish::BinaryExpr($1, banglish::BinaryOp::Less, $3); }
    | comparison LE term { $$ = new banglish::BinaryExpr($1, banglish::BinaryOp::LessEqual, $3); }
    | comparison GT term { $$ = new banglish::BinaryExpr($1, banglish::BinaryOp::Greater, $3); }
    | comparison GE term { $$ = new banglish::BinaryExpr($1, banglish::BinaryOp::GreaterEqual, $3); }
    | term { $$ = $1; }
    ;

term:
      term PLUS factor { $$ = new banglish::BinaryExpr($1, banglish::BinaryOp::Add, $3); }
    | term MINUS factor { $$ = new banglish::BinaryExpr($1, banglish::BinaryOp::Subtract, $3); }
    | factor { $$ = $1; }
    ;

factor:
      factor STAR unary { $$ = new banglish::BinaryExpr($1, banglish::BinaryOp::Multiply, $3); }
    | factor SLASH unary { $$ = new banglish::BinaryExpr($1, banglish::BinaryOp::Divide, $3); }
    | factor PERCENT unary { $$ = new banglish::BinaryExpr($1, banglish::BinaryOp::Modulo, $3); }
    | unary { $$ = $1; }
    ;

unary:
      MINUS unary { $$ = new banglish::UnaryExpr(banglish::UnaryOp::Negate, $2); }
    | call { $$ = $1; }
    ;

call:
      primary { $$ = $1; }
    | call LPAREN arg_list RPAREN {
          banglish::CallExpr *callExpr = new banglish::CallExpr($1);
          callExpr->arguments = std::move(*$3);
          delete $3;
          $$ = callExpr;
      }
    | call LPAREN RPAREN {
          banglish::CallExpr *callExpr = new banglish::CallExpr($1);
          $$ = callExpr;
      }
    | call LBRACKET expression RBRACKET { $$ = new banglish::IndexExpr($1, $3); }
    ;

arg_list:
      expr_list { $$ = $1; }
    ;

primary:
      IDENTIFIER { $$ = new banglish::VariableExpr(*$1); delete $1; }
    | INT_LITERAL { $$ = new banglish::LiteralExpr(banglish::LiteralType::Integer, std::to_string($1)); }
    | FLOAT_LITERAL { $$ = new banglish::LiteralExpr(banglish::LiteralType::Float, std::to_string($1)); }
    | STRING_LITERAL { $$ = new banglish::LiteralExpr(banglish::LiteralType::String, *$1); delete $1; }
    | CHAR_LITERAL { std::string tmp(1, $1); $$ = new banglish::LiteralExpr(banglish::LiteralType::Character, tmp); }
    | THIK { $$ = new banglish::LiteralExpr(banglish::LiteralType::Boolean, "thik"); }
    | BHUL { $$ = new banglish::LiteralExpr(banglish::LiteralType::Boolean, "bhul"); }
    | LPAREN expression RPAREN { $$ = $2; }
    ;

type_spec:
      DRUBO base_type { $$ = $2; $$->isConst = true; }
    | base_type { $$ = $1; }
    ;

base_type:
      PURNO { $$ = new banglish::TypeSpec(); $$->base = "int"; }
    | DOSOMIK { $$ = new banglish::TypeSpec(); $$->base = "float"; }
    | BDOSOMIK { $$ = new banglish::TypeSpec(); $$->base = "double"; }
    | OKKHOR { $$ = new banglish::TypeSpec(); $$->base = "char"; }
    | JANINA { $$ = new banglish::TypeSpec(); $$->base = "bool"; }
    | SOBDO { $$ = new banglish::TypeSpec(); $$->base = "char *"; }
    | FAKA { $$ = new banglish::TypeSpec(); $$->base = "void"; }
    ;

%%

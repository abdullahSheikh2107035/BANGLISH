#include <stdio.h>
#include <stdlib.h>
#include "banglish.tab.h"
#include "ast.h"

extern FILE* yyin;
extern int yyparse();
extern int yylineno;
extern banglish::Program *rootProgram;

void yyerror(const char *s) {
    printf("Parse error: %s at line %d\n", s, yylineno);
}

int main(int argc, char *argv[]) {
    if (argc > 1) {
        FILE *file = fopen(argv[1], "r");
        if (!file) {
            perror("Error opening file");
            return 1;
        }
        yyin = file;
    }
    int result = yyparse();
    if (result == 0) {
        printf("Parsed successfully, found %d functions\n", (int)rootProgram->functions.size());
       
    } else {
        printf("Parsing failed.\n");
    }
    if (rootProgram) {
        delete rootProgram;
    }
    return result;
}
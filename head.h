#ifndef HEAD_H
#define HEAD_H

#ifndef YY_TYPEDEF_YY_SIZE_T
#define YY_TYPEDEF_YY_SIZE_T
typedef size_t yy_size_t;
#endif

#include <stdio.h>


//ANALIZADOR LEXICO
extern void initAnalizador(FILE* input_file);
extern int yylexWrapper();

//ANALIZADOR SINTACTICO
extern int yyparseWrapper();

extern void yyerror(const char *s);

#endif
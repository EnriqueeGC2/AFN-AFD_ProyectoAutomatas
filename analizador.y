%{
#include <stdio.h>
#include <sstream>
#include "head.h"

extern int yylexWrapper();
extern FILE* yyin;
extern int yylineno;
%}

%union {
  int num;
  char* str;
}

%token <str> AUTOMATA_AFN
%token <str> AUTOMATA_AFN_FIN
%token <str> ALFABETO
%token <str> ALFABETO_FIN
%token <str> ESTADO
%token <str> ESTADO_FIN
%token <str> INICIAL
%token <str> INICIAL_FIN
%token <str> FINAL
%token <str> FINAL_FIN
%token <str> TRANSICIONES
%token <str> TRANSICIONES_FIN
%token <num> DIGITO
%token <str> LETRA
%token <str> CADENA_VACIA
%token <str> COMA
%token <str> CARACTER

%%

automata_afn : AUTOMATA_AFN
               etiqueta_alfabeto
               etiqueta_estado
               etiqueta_inicial
               etiqueta_final
               etiqueta_transiciones
               AUTOMATA_AFN_FIN {
                std::ostringstream error_message;
                error_message << "Se esperaba un numero positivo dentro de la etiqueta <ESTADOS>. Error en la línea: "<< yylineno;
                yyerror(error_message.str().c_str());
                }       
             ;

etiqueta_alfabeto : ALFABETO
                    elementos_alfabeto
                    ALFABETO_FIN
                  ;

elementos_alfabeto : elementos_alfabeto LETRA
                  | elementos_alfabeto CARACTER
                  | LETRA
                  | CARACTER
                  | CADENA_VACIA {
                      std::ostringstream error_message;
                      error_message << "Error en la línea " << yylineno << ": se esperaba un numero positivo dentro de la etiqueta <ESTADOS>";
                      yyerror(error_message.str().c_str());
                    }
                  ;

etiqueta_estado : ESTADO
                  elementos_estado
                  ESTADO_FIN
               ;

elementos_estado : elementos_estado DIGITO
                | DIGITO {
                      if (yylval.num < 0) {
                          std::ostringstream error_message;
                          error_message << "Error en la línea " << yylineno << ": se esperaba un numero positivo dentro de la etiqueta <ESTADOS>";
                          yyerror(error_message.str().c_str());
                      }
                  }
                ;

etiqueta_inicial : INICIAL
                  DIGITO
                  INICIAL_FIN
                ;

etiqueta_final : FINAL
                elementos_final
                FINAL_FIN
              ;

elementos_final : elementos_final DIGITO
               | DIGITO {
                      if (yylval.num < 0) {
                          std::ostringstream error_message;
                          error_message << "Error en la linea " << yylineno << ": se esperaba un numero positivo dentro de la etiqueta <FINAL>";
                          yyerror(error_message.str().c_str());
                      }
                  }
               ;

etiqueta_transiciones : TRANSICIONES
                      elementos_transiciones
                      TRANSICIONES_FIN
                    ;

elementos_transiciones : elementos_transiciones TRANSICION
                      | TRANSICION
                      ;

TRANSICION : DIGITO COMA LETRA COMA DIGITO
          | DIGITO COMA CADENA_VACIA COMA DIGITO
          ;


%%

void yyerror(const char *s) {
  FILE *logfile = fopen("bitacora_errores.txt", "a");
  if (logfile == NULL) {
    printf("Error abriendo el archivo de bitacora\n");
    return;
  }
  fprintf(logfile, "Error sintactico: %s linea: %d\n", s, yylineno);
  fclose(logfile);
}

void initAnalizador(FILE* input_file) {
    yyin = input_file;
}

int yyparseWrapper(){
    return yyparse();
}

#include <iostream>
#include <cstdio>
#include "lex.yy.c"
#include "analizador.tab.c"
#include "head.h"  // Asegúrate de incluir los archivos de cabecera generados por Flex y Bison
//#include "analizador.tab.h"  // El archivo de cabecera generado por Bison

int main() {
    int option;
    FILE* input_file = nullptr;

     // Abrir el archivo de bitácora de errores en modo de escritura (esto lo limpiará)
    FILE* error_log_file = fopen("bitacora_errores.txt", "w");
    if (error_log_file == nullptr) {
        std::cout << "Error al abrir el archivo de bitácora de errores.\n";
        return 1;
    }
    fclose(error_log_file);

    while (true) {
        std::cout << "Menu:\n";
        std::cout << "1. Ingresar archivo\n";
        std::cout << "2. Salir del programa\n";
        std::cout << "Ingrese la opcion: ";
        std::cin >> option;

        if (option == 1) {
            std::string file_name;
            std::cout << "Ingrese el nombre del archivo: ";
            std::cin >> file_name;

            input_file = fopen(file_name.c_str(), "r");
            if (input_file == nullptr) {
                std::cout << "Error: no se pudo abrir el archivo.\n";
                continue;
            }

            // Llamada a la función para inicializar el analizador léxico y establecer yyin
            initAnalizador(input_file);
            yylexWrapper();

            // Llamada al analizador sintáctico (Bison) para analizar el archivo
            if (yyparseWrapper() == 0) {
                std::cout << "Analisis exitoso.\n";
            } else {
                std::cout << "Error en el analisis sintactico.\n";
            }

            fclose(input_file);
            input_file = nullptr;
        } else if (option == 2) {
            break;
        } else {
            std::cout << "Opcion no valida. Intente de nuevo.\n";
        }
    }

    return 0;
}

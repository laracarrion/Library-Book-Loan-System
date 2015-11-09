UNIT libro;

   (**)INTERFACE

          USES crt;

          CONST
               tope_libros=20;

          TYPE
             tIndiceLibros= 1..tope_libros;
             tNumLibros = 0..tope_libros;
             tSituacion = (Disponible, Prestado, NoDisponible);
             tLibro = record
                     titulo:string;
                     autor: string;
                     anno: 1900..2010;
                     reg: tNumLibros;
                     estado:tSituacion;
                     end;
             tIndiceLibro = 1..tope_libros;

          procedure mostrarLibro(libro: tLibro);
          procedure leerLibro(var libro:tLibro);

     (**)IMPLEMENTATION


    { OBJ: Muestra por pantalla el contenido de un libro.
      ENT: un libro (de tipo tLibro)
      SAL: (por pantalla)
    }

     procedure mostrarLibro (libro: tLibro);

     
       begin

          with libro do begin
           textcolor(lightred);
           writeln('Título: ', titulo);
           textcolor(lightgray);
           writeln('Autor: ', autor);
           writeln('Año de publicaci¢n: ', anno);
           write('Num. Reg: ');
           textcolor(lightgreen);
           writeln(reg);
           textcolor(lightgray);
           write('Estado actual: ');
           case estado of
            Disponible: writeln('Disponible');
            Prestado: writeln('Prestado');
            NoDisponible:writeln('No Disponible');
           end;{case}
          end;{with}
       readln;


     end;{procedure mostrarLibro}


     {OBJ: Leer por teclado el contenido de un libro.
      ENT: - - -
      SAL: un libro (de tipo tLibro)
     }

     procedure leerLibro (var libro : tlibro);
     
          var
               sit: integer;

               begin
                clrscr;
                window(18,10,80,50);
                with libro do begin
                 textcolor(lightred);
                 writeln('    * AÑADIR UN NUEVO LIBRO *    ');
                 writeln('     -----------------------     ');
                 writeln;
                 writeln('Introduzca los siguientes campos: ');
                 writeln('---------------------------------');
                 writeln;
                 textcolor(lightgray);
                 write('* Título: ');
                 readln(titulo); writeln;
                 write('* Autor: ');
                 readln(autor);     writeln;
                 repeat
                 textcolor(lightgray);
                 write('* Año de edición: ');
                 readln(anno);
                 if (anno<1900) or (anno>2010) then begin
                     textcolor(red);
                     writeln;
                     writeln('Año incorrecto');
                 end;
                 writeln;
                 until (anno>=1900) and (anno<=2010);
                 reg:=0;
                 repeat
                 textcolor(lightgray);
                 write('* Situación (1.- Disponible; 2.- No Disponible): ');
                 readln(sit);

                              case sit of
                               1:estado:=Disponible;
                               2:estado:=NoDisponible;
                              else  begin
                              textcolor(red);
                              writeln;
                              writeln('El valor introducido es incorrecto');
                              writeln;
                              end
                              end;
                 until (sit=1) or (sit=2);
                 end; {with libro do}
     end;


               BEGIN

               END.

program Biblioteca;

        USES crt, libro, listaLibros, socio, listaSocios;

        TYPE

             tFichero2= FILE OF tSocio;
             tFichero= FILE OF tLibro;

        VAR

           opcion: integer;
           libros: tlistalibros;
           socios: tListaSocios;


{ OBJ: muestra el rótulo de la biblioteca.
 ENT: ---
 SAL: ---       
}

procedure rotulobiblioteca;


          begin
           textcolor(lightmagenta);
           gotoxy(17,2);
           writeln('***   *  ***   *    *  ****  ***  ****  ****  ****');
           gotoxy(17,3);
           textcolor(yellow);
           writeln('*  *  *  *  *  *    *  *  *   *   *     *     *  *');
           gotoxy(17,4);
           textcolor(lightcyan);
           writeln('***   *  ***   *    *  *  *   *   ***   *     ****');
           gotoxy(17,5);
           textcolor(yellow);
           writeln('*  *  *  *  *  *    *  *  *   *   *     *     *  *');
           gotoxy(17,6);
           textcolor(lightmagenta);
           writeln('***   *  ***   ***  *  ****   *   ****  ****  *  *');
           gotoxy(17,7);
          end;


procedure leerEntero (var i: integer);
        var
        cad: string;
        error: integer;

        begin

                repeat
                readln(cad);
                val(cad, i, error);
                readln;
                until error=0;
        end;


{ OBJ: determinar si el programa ha terminado.
  ENT: un entero.
  SAL: true si es 0 y termina el programa / false en caso contrario
}

function terminado(opcion:integer):boolean;



         begin
         if opcion = 0 then terminado:=true
         else terminado:=false
end;


{ OBJ: cargar 2 ficheros con datos de socios y libros.
  ENT: - - -
  SAL: si se encuentran los ficheros -> dos listas actualizadas con los datos de libros y socios
      si no se encuentran -> dos listas vacías (una para socios y otra para libros)
}

procedure cargarDatos(var libros:tlistalibros; var socios: tListaSocios);


      var
      l: tlibro; s: tSocio;
      fichero: tfichero;
      fichero2: tFichero2;
      i: integer; tamanio, tamanioS: integer;
      begin
      {$I-}
           assign(fichero, 'c:\hlocal\libros.bin');
           reset(fichero);

      {$I+}
      if ioresult=0 then begin
           while not  eof (fichero) do begin
                 for i:=1 to filesize(fichero) do begin
                  read (fichero, l);
                  libros.tabla[i]:=l;
                 end;
           tamanio:=filesize(fichero);
           end;


           close(fichero);
           libros.num:=tamanio;
           libros.ultimoReg:=tamanio;
      end
      else
      inicializarListaLibros(libros);
      {$I-}
           assign(fichero2, 'c:\hlocal\socios.bin');
           reset(fichero2);
      {$I+}
      if ioresult=0 then begin
      while not eof (fichero2) do begin
            for i:=1 to filesize(fichero2) do begin
                read(fichero2, s);
                socios.tabla[i]:=s;
            end;
            tamanioS:=filesize(fichero2);
      end;
      close(fichero2);
      socios.num:= tamanioS;

      end
      else
      inicializarListaSocios(socios);
end;


{ OBJ: Almacenar todos los moviemientos de libros y socios.
  ENT: 2 listas: una de libros y otra de socios.
  SAL: Si no se cargaron ficheros y las listas siguen vacías, no se crea nada.
      Si se cargaron ficheros, se modifican con los cambios que se hayan realizado.
}
procedure guardarDatos(libros: tListaLibros; socios: tListaSocios);


   var
   fichero: tfichero;
   fichero2: tFichero2;
   i: integer;
   begin
        assign(fichero, 'c:\hlocal\libros.bin');
        rewrite(fichero);
        for i:=1 to libros.num do
            write(fichero, libros.tabla[i]);
            writeln;
        close(fichero);

        assign(fichero2, 'c:\hlocal\socios.bin');
        rewrite(fichero2);
        for i:=1 to socios.num do
            write(fichero2, socios.tabla[i]);
            writeln;
        close(fichero2);
   end;



{ OBJ: mostrar un menú al usuario para que escoja una opción.
  ENT: - - -
  SAL: la opción elegida por el usuario.
}

procedure seleccionarOpcion(var opcion:integer);



          begin
          clrscr;
          textcolor(lightcyan);
          writeln('====================================');
          writeln;
          writeln('           MENU PRINCIPAL           ');
          writeln;
          writeln('====================================');
          writeln;
          writeln('1.- Gesti¢n de socios');
          writeln('2.- Gesti¢n de libros');
          writeln('3.- Gesti¢n de la biblioteca');
          writeln('0.- Salir');
          writeln;
          writeln('====================================');
          textcolor(lightgray);
          write('Elige una opci¢n: ');
          repeat

          readln(opcion);
          if ((opcion<0) or (opcion>3)) then begin
          writeln('Esa no es una opci¢n');
          readln;
          end
          until ((opcion>0) or (opcion<3));

         end;



{ OBJ: regresar al menú principal.
 ENT: - - -
 SAL: la opción elegida por el usuario
      * FINAL: true si elige 0 / false en caso contrario.
}

procedure volver(var opcion: integer; var final: boolean);


  begin
   seleccionarOpcion(opcion);
   final:=true
  end;

{============================================================================}
procedure gestionarSocios(var socios: tListaSocios);

     {==================================================}
     procedure mostrarMenuSocios;
          begin
           clrscr;
           textcolor(lightgreen);
           writeln('====================================');
           writeln;
           writeln('             MENU SOCIOS            ');
           writeln;
           writeln('====================================');
           writeln;
           writeln('1.- Añadir socio');
           writeln('2.- Eliminar socio');
           writeln('3.- Mostrar socio');
           writeln('4.- Listado de socios');
           writeln('0.- Volver');
           writeln('====================================');
           textcolor(lightgray);
           write('Elige una opción: ');
         end;
     {==================================================}
     procedure gestionAnadirSocio(var socios:tListaSocios);
               var
               s:tSocio;
               begin
               if not listaSociosLlena(socios) then begin
                leerSocio(s);
                annadirsocio(socios, s);
               end
               else begin
                textcolor(red);
                writeln('La lista de socios está llena');
                readln;
               end;
         end;
     {======================================================}
     procedure gestionEliminarSocio(var socios:tListaSocios);
          
          var
          buscado: tCodigo;
          posS:tIndiceSocios;
          s:tSocio;
          
          begin
           writeln('Introduce código de socio: ');
           readln(buscado);
           if codigovalido(buscado) then begin
            buscarSocioPorCodigo(socios, buscado, existe, posS, s);
            if (existe=true) and (librosPrestados(s)=0) then begin
              borrarSocio(socios, posS);
              textcolor(lightred);
              writeln;
              writeln('El socio ha sido eliminado con éxito');
              textcolor(red);
              writeln('Pulsa <ENTER> para continuar');
              readln;
            end
            else begin
              textcolor(red);
              if not existe then writeln('Ese socio no existe')
              else
               if (librosPrestados (s)<> 0) then
               writeln('El socio no puede borrarse porque tiene libros prestados');
               readln;
              end
            end
            else begin
              writeln('Ese código no es válido');
              readln;
            end
          end;
     {======================================================}
     procedure gestionMostrarSocio(var socios: tListaSocios);
            
            var
            buscado: tCodigo;
            posS: tIndiceSocios;
            s: tSocio;
            begin
                 writeln('Introduce codigo de socio: ');
                 readln(buscado);
                 if codigovalido(buscado) then begin
                    buscarSocioPorCodigo(socios, buscado, existe, posS, s);
                    if existe = true then begin
                       writeln;
                       mostrarsocio(s)
                    end
                    else begin
                      textcolor(lightred);
                      writeln;
                      writeln('No hay ning£n socio con ese código en el registro');
                      readln;
                    end;
                 end
                 else begin
                   textcolor(red);
                   writeln('Ese código no es válido');
                   readln;
                 end;
            end;
     {===========================================================}
     procedure gestionMostrarListaSocios(var socios: tListaSocios);

             begin
                
                if socios.num = 0 then  begin
	                textcolor(lightred);
	                writeln;
	                writeln('La base de datos de socios está vacía');
	                readln;
                end:

                else
                  mostrarListaSocios(socios);

             end;


  {=============================================================}
          
          var
          final: boolean;
          entero: integer;
          begin
          final:=false;

          repeat
            mostrarMenuSocios;
            leerEntero(entero);
            readln(opcion);
            if (opcion>4) or (opcion<0) then begin
               textcolor(red);
               writeln('Esa no es una opción');
               readkey
               end;
            case opcion of
                 0: volver(opcion, final);
                 1: gestionAnadirSocio(socios);
                 2: gestionEliminarSocio(socios);
                 3: gestionMostrarSocio(socios);
                 4: gestionMostrarListaSocios(socios);
            end;
          until final;

     end;
{============================================================================}

procedure gestionarLibros (var libros: tListaLibros);

     procedure mostrarMenuLibros;
            begin
             clrscr;
             textcolor(yellow);
             writeln('====================================');
             writeln;
             writeln('             MENÚ LIBROS            ');
             writeln;
             writeln('====================================');
             writeln;
             writeln('1.- Añadir libro');
             writeln('2.- Borrar libro');
             writeln('3.- Mostrar libro');
             writeln('4.- Listado de libros');
             writeln('0.- Volver');
             writeln('====================================');
             textcolor(lightgray);
             write('Elige una opción: ');
     end;

    procedure gestionAnadirLibro (var libros: tListaLibros);
      var
      l:tLibro;
      begin
          if not listaLibrosLlena(libros) then begin
           leerLibro(l);
           annadirLibro(libros, L);
          end
          else begin
           textcolor(red);
           writeln;
           writeln('La lista está llena. No se pueden añadir más libros. ');
          readln;
          end;
      end;

    procedure gestionBorrarLibro(var libros: tListaLibros);
      var
      pos: tIndiceLibros;
      l: tLibro;
      begin
      clrscr;
      writeln('Introduce un registro para el libro: ');
      readln(regBuscado);
      buscarLibroPorRegistro(libros, regBuscado, existe, pos, l);
      if existe then
       borrarLibro(libros, pos)
      else begin
       textcolor(red);
       writeln('No hay ningún libro con ese número de registro');
       readln;
      end
    end;

    procedure gestionMostrarLibro(var libros: tListaLibros);
      var
      pos: tIndiceLibros;
      l: tLibro;
      begin
                clrscr;
                writeln('Introduce un registro para el libro: ');
                readln(regBuscado);
                    buscarLibroPorRegistro(libros, regBuscado, existe,
                                                           pos, l);
                    if existe then
                    mostrarLibro(l)
                    else begin
                    textcolor(red);
                    writeln('El libro no se encuentra en la base de datos');
                    readln
                    end

                end;

  procedure gestionMostrarListaLibros(var libros: tListaLibros);
            begin
            if libros.num = 0 then begin
               textcolor(lightred);
               writeln;
               writeln('La base de datos de libros está vacía');
               readln
            end
               else
                mostrarBiblioteca(libros);
   end;


         var
         final: boolean;
         begin
          final:=false;
          repeat
          mostrarMenuLibros;
          {readln(opcion);}
          repeat
          leerEntero(opcion);
          until (opcion<=4) or (opcion>=0);

          case opcion of
             0: volver(opcion, final);
             1: gestionAnadirLibro(libros);
             2: gestionBorrarLibro(libros);
             3: gestionMostrarLibro(libros);
             4: gestionMostrarListaLibros(libros);

          end;
          until final;
     end  ;

procedure gestionarBiblioteca(var libros: tListaLibros; var socios: tListaSocios);

         procedure mostrarMenuBiblioteca;
          begin
          clrscr;
          textcolor(lightred);
          writeln('====================================');
          writeln;
          writeln('           MENÚ BIBLIOTECA           ');
          writeln;
          writeln('====================================');
          writeln;
          writeln('1.- Nuevo préstamo');
          writeln('2.- Devolución');
          writeln('3.- Lista de préstamos');
          writeln('0.- Volver');
          writeln;
          writeln('====================================');
          textcolor(lightgray);
          write('Elige una opción: ');
    end;

    procedure gestionPrestamos (var libros: tListaLibros; var socios: tListaSocios);
              
              var
              buscado: tCodigo;
              rBuscado: integer;
              posL: tIndiceLibros;
              existeS, existeL, exito: boolean;
              posS: tIndiceSocios;
              s: tSocio; l: tLibro; p: tPrestamo;
              

              begin
              
                clrscr;
                repeat
                  writeln('Introduce el código del socio: ');
                  readln(buscado);
                  if not codigovalido(buscado) then begin
                    writeln('El código introducido no es válido');
                    readln;  
                  end;
                until codigovalido(buscado);
                buscarSocioPorCodigo (socios, buscado, existeS, posS, s);
                writeln('Introduce el número de registro del libro: ');
                readln(rBuscado);
                buscarLibroPorRegistro(libros, rBuscado, existeL, posL, l);
                if ((existeS) and (existeL) and (l.estado=disponible)) then begin
                  pedirDatosPrestamo(p);
                  p.registro:=l.reg;
                  annadirPrestamo(s, p, exito);
                  if exito then begin
                    l.estado:=prestado;
                    actualizarLibro(libros, posL, l);
                    actualizarSocio(socios, posS, s);
                  end;
                end;
                else
                  if not (existeS) and not (existeL) then
                    writeln('El socio y el libro solicitados no existen')
                  else
                    if not existeS then writeln('El socio no existe')
                    else if not existeL then writeln('El libro no existe');

              end;

    procedure gestionDevoluciones(var libros: tListaLibros; var socios:  tListaSocios);
              var
              buscado: tCodigo;
              existeS: boolean;
              posS: tIndiceSocios;
              posL: tIndiceLibros;
              l:tLibro;
              s: tSocio;
              posicion:tIndiceLibros;
                         begin
                         writeln('Introduce el código del socio: ');
                         readln(buscado);
                         buscarsocioporCodigo(socios, buscado, existeS, posS, s);
                         if (existeS) and (s.prestamos.num<>0) then begin
                                    mostrarListaPrestamos(s);
                                    writeln('¨Qué libro quieres devolver? (introduce posición)');
                                    readln(posicion);
                                    buscarLibroPorRegistro(libros, s.prestamos.tabla[posicion].registro,existe, posL,l);
                                    if (existe) then begin
                                    l.estado:=disponible;
                                    actualizarLibro(libros, posL, l);
                                    quitarPrestamo(s, posicion);
                                    actualizarSocio(socios,posS, s);
                                    end
                         end
                         else
                           IF not existeS then begin
                           writeln('Ese socio no existe');
                           readln
                           end
                           else begin
                              textcolor(red);
                              writeln('Este socio no tiene libros prestados');
                              readln;
                         end;

                         end;

    procedure gestionMostrarPrestamos (var libros: tListaLibros; var copia: tListaLibros;var socios: tListaSocios);
    var

    pos: tIndiceLibros;
    l: tlibro;s: tSocio;
    posS: tIndiceSocios;
    begin
                         obtenerCopiaLista(libros, copia);
                         ordenarlista(copia);
                         for pos:=1 to copia.num do begin
                            pedirLibro(copia, pos, l);
                            if l.estado=prestado then begin
                               mostrarLibro(l);

                               buscarSocioPorPrestamo(socios, l.reg, existe,
                                                      posS, s);
                               if existe then begin
                               writeln('Socio que tiene prestado el libro: ');
                               mostrarSocio(s);
                               end;
                             end  ;
    end;
    end;

          var
           final: boolean;
           copia: tListaLibros;
          begin
           final:=false;
          repeat
           mostrarMenuBiblioteca;
           readln(opcion);
           if (opcion>3) or (opcion<0) then begin
               textcolor(red);
               writeln('Esa no es una opción');
               readkey
               end;

                         case opcion of
                         0: volver(opcion, final);
                         1: gestionPrestamos(libros, socios);
                         2: gestionDevoluciones(libros, socios);
                         3: gestionMostrarPrestamos(libros, copia, socios);
                         end;
             until final;
    end;

BEGIN
     clrscr;
     rotulobiblioteca;
     window(25, 10, 80, 50);
     cargarDatos(libros,socios);
     seleccionarOpcion(opcion);
     repeat


           case opcion of
                1: gestionarSocios(socios);
                2: gestionarLibros(libros);
                3: gestionarBiblioteca(libros, socios);
           end;
     until terminado(opcion);
     guardarDatos(libros, socios);
end.

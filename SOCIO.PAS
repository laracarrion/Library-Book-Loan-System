UNIT socio;
     

     (**) INTERFACE
     uses crt;

     const
     tope_prestamos = 10;

     type
     tTipoSocio = (Alumno, Becario, Profesor);
     TCodigo= string[5];
     tFecha = record
              dia: 1..31;
              mes: 1..12;
              anno: 1990..2010;
              end;
     tPrestamo = record
                 fecha: tFecha;
                 registro: integer;
                 end;
     tNumPrestamos = 0..tope_prestamos;
     tIndicePrestamos = 1.. tope_prestamos;
     tTablaPrestamos = array[tIndicePrestamos] of tPrestamo;
     tListaPrestamos = record
                       tabla: tTablaPrestamos;
                       num: tNumPrestamos;
                       end;
     TSocio = record
               nombre: string[10];
               apellidos: string[30];
               codigo: tCodigo;
               prestamos: tListaPrestamos;
               tipo: tTipoSocio;
            end;

        {/// CABECERAS ///}

            procedure mostrarSocio(s: tSocio);
            procedure leerSocio(var s:tSocio);
            procedure annadirPrestamo(var s: tSocio; p:tPrestamo; var EXITo: boolean);
            procedure quitarPrestamo(var s: tSocio; pos: tIndicePrestamos);
            procedure mostrarListaPrestamos(s: tSocio);
            function librosPrestados(s:tSocio): TNumPrestamos;
            procedure pedirDatosPrestamo(var nuevoPrestamo: tPrestamo);
            function codigoValido(codigo: string): boolean;
            function listaPrestamosLlena(s:tSocio):boolean;
        
        {/// FIN ///}

  (**) IMPLEMENTATION

  {
    OBJ: Determinar si un cÛdigo de socio introducido es o no v·lido.
    ENT: Un cÛdigo de socio.
    SAL: true si es v·lido / false en caso contrario.
  }

  function codigoValido (codigo:string):boolean;
  
    var
    i, cont: integer;

    begin
      
      cont:=0;
      codigo[1]:=upcase(codigo[1]);
      if ((ord(codigo[1])>=65) and (ord(codigo[1])<=90)) then begin
        for i:=2 to 5 do begin
          if (ord(codigo[i])>=48) and (ord(codigo[i])<=57) then
            cont:=cont + 1;
        end;
      end;
      if cont=4 then codigoValido:=true;
      else codigoValido:=false;

    end;


  {
    OBJ: Mostrar por pantalla un socio.
    ENT: un socio con todos sus datos.
    SAL: (por pantalla)
  }

  procedure mostrarSocio (s:tSocio);

    begin

      with s do begin
        textcolor(lightgray);
        write('* Nombre: ');
        textcolor(lightgreen);
        writeln(nombre);
        textcolor(lightgray);
        write('* Apellidos: ');
        textcolor(lightgreen);
        writeln(apellidos);
        textcolor(lightgray);
        write('* CÛdigo: ') ;
        textcolor(yellow);
        writeln(codigo);
        textcolor(lightgray);
        write('* Tipo de socio: ');
        case tipo of
          alumno: writeln('ALUMNO');
          becario: writeln('BECARIO');
          profesor: writeln('PROFESOR');
          else
            writeln('SIN CATEGORÕA')
        end;
        readln;
      end;
    end;
    

    {
       OBJ: obtener los datos de un prÈstamo.
       ENT: (por teclado)
       SAL: los datos del prÈstamo.
     }

     procedure pedirDatosPrestamo(var nuevoPrestamo: tPrestamo);
    
       begin
       
         clrscr;
         writeln('Introduce la fecha de devoluciÛn');
         write('* DÌa: '); readln(nuevoPrestamo.fecha.dia);
         write('* Mes: '); readln(nuevoPrestamo.fecha.mes);
         write('* AÒo: '); readln(nuevoPrestamo.fecha.anno);
         
       end;


     
    {
       OBJ: Leer los datos de un socio.
       ENT: - - -
       SAL: los datos del socio.
     }

     procedure leerSocio(var s: tSocio);
    
       var
       t: integer;
       aux, code: integer;
       
       begin
       
         clrscr;
         window(18, 10, 80, 50);
         with s do begin
          textcolor(lightred);
          writeln('         * A—ADIR UN NUEVO SOCIO *          ');
          writeln('          -----------------------');
          writeln;
          writeln('      Introduzca los siguientes campos:     ');
          writeln('      --------------------------------- ');
          textcolor(lightgray);
          write('* Nombre: '); readln(nombre); writeln;
          write('* Apellidos: '); readln(apellidos);  writeln;
          repeat
            write('* CÛdigo: '); readln(codigo); writeln;
            if not codigoValido(codigo) then writeln('El cÛdigo no es v·lido');
            until codigoValido(codigo);
            repeat
              textcolor(lightgray);
              write('* Tipo de socio: (1.- Alumno; 2.- Becario; 3.- Profesor): '); 
              readln(t); 
              writeln;
              case t of
                1: tipo:=alumno;
                2: tipo:=becario;
                3: tipo:=profesor;
              else begin
                textcolor(red);
                writeln;
                writeln('El valor introducido es incorrecto');
                writeln;
              end;
            end;
            until ((t=1) or (t=2) or (t=3));
         end;
         s.prestamos.num:=0;
      end;



    {
       OBJ: Determinar si una lista de prÈstamos est† llena.
       ENT: un socio.
       SAL: true si est† llena / false en caos contrario
     }

     function listaPrestamosLlena(s: tSocio):boolean;
       
       begin
       
         if (s.prestamos.num=tope_prestamos) then
           listaPrestamosLlena:=true
         else listaPrestamosLlena:=false;
         
       end;

  

      {
         OBJ: A§adir un prÇstamo a la lista de prÇstamos de un socio.
         ENT: un socio y un prÇstamo.
         SAL: *EXITO: true si se ha aÒadido el prÈstamo / false en caso contrario.
              *SOCIO: el socio con la lista de prÈstamos actualizada sÛlo si exito=true
       }

      procedure annadirPrestamo (var s: tSocio; p: tPrestamo; var EXITO: boolean);
        
        begin
        
          EXITO:=false;
          if not listaPrestamosLlena(s) then begin
            s.prestamos.tabla[s.prestamos.num+1]:=p;
            s.prestamos.num:=s.prestamos.num+1;
            EXITO:=true
          end;
          else begin
            writeln('PRê…STAMO INCORRECTO POR LISTA LLENA');
            readln;
            EXITO:=false;
          end;
          writeln(s.prestamos.NUM);
          readln;

        end;


       {
         OBJ: Eliminar un prÇstamo de la lista de prÈstamos de un socio.
         ENT: un socio y la posiciÛn del prÈstamo.
         SAL: El socio con su lista de prÈstamos modificada (sin el libro)
       }

       procedure quitarPrestamo (var s:tSocio; pos: tIndicePrestamos);

         var 
         i: integer;
         
         begin

           if pos=s.prestamos.num then
             s.prestamos.num:=s.prestamos.num-1
           else
             if (pos>s.prestamos.num) and (pos<1) then
               writeln('La posiciÛn introducida no es v·lida')
             else begin
               s.prestamos.num:=s.prestamos.num-1;
               for i:=pos to s.prestamos.num do
                 s.prestamos.tabla[i]:=s.prestamos.tabla[i+1];
             end;
             textcolor(lightred);
             writeln('PrÈstamo eliminado.');
             textcolor(red);
             writeln('Pulsa <ENTER> para continuar');
             readln;
        
         end;

       
       {
         OBJ: mostrar todos los prÈstamos de un socio.
         ENT: un socio.
         SAL: todos los prÈstamos de un socio (por pantalla)
       }

       procedure mostrarListaPrestamos (s: tSocio);

         var 
         i: integer;
         
         begin
           
           clrscr;
           textcolor(yellow);
           writeln('        * LISTA DE PR…êSTAMOS *      ');
           writeln('       ------------------------     ');
           writeln;
           for i:=1 to s.prestamos.num do
             with s.prestamos.tabla[i] do begin
               textcolor(lightgray);
               write('N˙m. Reg: ');
               writeln(registro);
               write('Fecha de devoluciÛn: ');
               write(fecha.dia); write(' / ');
               write(fecha.mes); write(' / ');
               write(fecha.anno);
               readln;
             end;
         
         end;


       {
          OBJ: conocer el n£mero de libros prestados que tiene un socio.
          ENT: un socio.
          SAL: el n˙mero de prÈstamos del socio.
       }

       function librosPrestados (s: tSocio): TNumPrestamos;
      
         begin
         
           librosPrestados:=s.prestamos.num;
               
         end;


begin
end.

UNIT ListaLibros;

     (**) INTERFACE

          USES crt, Libro;

          CONST
          tope_libros= 10;

          TYPE

              tNumLibros = 0..tope_libros;
              tTablaLibros = array [1..tope_libros] of tLibro;
              tListaLibros = record
                             tabla: tTablaLibros;
                             num: tNumLibros;
                             ultimoReg: integer;
                             end;


          VAR
               lista: tListaLibros;
               nuevoLibro, libact:tLibro;
               regBuscado:integer;
               existe:boolean;

          procedure inicializarListaLibros(var lista: tListaLibros);
          function listaLibrosLlena(lista:tListaLibros):boolean;
          procedure annadirLibro(var lista: tListaLibros; nuevoLibro: tLibro);
          procedure pedirLibro(lista:tListaLibros; pos: tIndiceLibros; var libro:tlibro);
          procedure actualizarLibro(var lista:tListaLibros; pos: tIndiceLibros; libAct:tLibro);
          procedure ordenarLista(var lista: tlistalibros);
          procedure obtenerCopiaLista(lista: tlistalibros; var LCopia: tlistaLibros);
          procedure borrarLibro(var lista: tListaLibros; pos:TIndiceLibros);
          procedure buscarLibroPorRegistro(lista: tListaLibros; regBuscado:integer;
                                        var existe:boolean; var pos:tIndiceLibros;
                                        var libro:tLibro);
          procedure mostrarBiblioteca(lista:tlistalibros);



     (**) IMPLEMENTATION


      { 
        OBJ: Inicializar una lista de libros a vacía.
        ENT: - - -
        SAL: la lista con 0 elementos.
      }

      procedure inicializarListaLibros(var lista:tListaLibros);

            begin
              lista.num:=0;
            end;

      { 
        OBJ: Comprobar si una lista está llena.
        ENT: una lista con elementos del tipo tLibro
        SAL: true si est  llena / false en caso contrario
      }

      function listaLibrosLlena(lista:tListaLibros): boolean;

             begin
              if (lista.num = tope_libros) then
                 listaLibrosLlena := true;
              else listaLibrosLlena := false;
           end;


      {
        OBJ: Añadir un libro al final de la lista.
        ENT: El libro que se quiere añadir (con todos sus datos) y la lista.
        SAL: La lista con el libro a¤adido
      }

      procedure annadirLibro (var lista: tListaLibros; nuevoLibro: tLibro);

             begin
               with lista.tabla[(lista.num)+1] do begin
                titulo:=nuevoLibro.titulo;
                autor:=nuevoLibro.autor;
                anno:=nuevoLibro.anno;
                estado:=nuevoLibro.estado;
                reg:=lista.ultimoReg+1;
                textcolor(lightgreen);
                writeln('Libro a¤adido con ‚xito');
                textcolor(green);
                writeln('Pulsa <ENTER> para volver');
                readln;
               end;
               lista.num:= (lista.num)+1;
               lista.ultimoReg:=lista.tabla[lista.num].reg;
            end;


      {
        OBJ: Obtener una copia del libro que hay en la posición pedida.
        ENT: La lista de libros y la posición.
        SAL: Una copia del libo (de tipo tLibro)
      }


      procedure pedirLibro (lista:tListaLibros; pos:tIndiceLibros; var libro:tLibro);

          begin
            libro:=lista.tabla[pos];
          end;



      {
        OBJ: Actualizar un libro contenido en la lista con nuevos valores.
        ENT: La lista, la posición deseada y el libro con los valores nuevos.
        SAL: La lista actualizada con el libro nuevo.
      }

      procedure actualizarLibro(var lista: tListaLibros; pos: TIndiceLibros;
                                        libAct: tLibro);
              
              begin

                with lista.tabla[pos] do begin
                        titulo:=libact.titulo;
                        autor:=libact.autor;
                        anno:=libact.anno;
                        reg:=pos;
                        estado:=libact.estado;
                end;
              
              end;


     {
       OBJ: Generar una copia ordenada alfabéticamente (por títulos de libros) de una lista.
       ENT: una lista con libros.
       SAL: una copia ordenada de la lista.
     }

     procedure ordenarLista (var lista: tListalibros);

               var
                i,j: integer;
                aux: tLibro;

               begin

                for i:=1 to lista.num do
                    for j:=lista.num downto i do
                        if lista.tabla[j-1].titulo>lista.tabla[j].titulo then begin
                          aux:=lista.tabla[j-1];
                          lista.tabla[j-1]:=lista.tabla[j];
                          lista.tabla[j]:=aux;
                        end;

                   { for i:=1 to lista.num do begin
                        writeln(lista.tabla[i].titulo);
                        readln;
                        end;}
                   end;


     
     {
       OBJ: Obtener una copia de una lista de libros.
       ENT: una lista de libros.
       SAL: una copia de la lista.
      }

     procedure obtenerCopiaLista(lista: tListaLibros; var lCopia: tListaLibros);


               var i: integer;
               begin
               for i:=1 to lista.num do
                   LCopia.tabla[i]:=lista.tabla[i];
                LCopia.num:=lista.num;
               end;

      
      {
        OBJ: Borrar un libro de la lista.
        ENT: La posición del libro que se desea eliminar.
        SAL: La lista sin el libro.
      }

      procedure borrarLibro(var lista: tListaLibros; pos:TIndiceLibros);

                var
                i:integer;
                
                begin
                
                 if pos=lista.num then
                  lista.num:=lista.num-1
                 else
                    if(pos>lista.num) or (pos<1) then writeln('ERROR!!')
                    else begin
                     lista.num:=lista.num-1;
                     for i:=pos to lista.num do
                         lista.tabla[i]:=lista.tabla[i+1];
                         lista.ultimoReg:=lista.tabla[lista.num].reg;
                     end;
                end;


      {
        OBJ: Buscar un libro a partir de un número de registro.
        ENT: La lista y el registro a buscar.
        SAL: *EXISTE: true si encuentra el libro en la lista / false en caso contrario.
            *POS: si existe-> devuelve la posición
            *LIBRO: si existe->devuelve el libro
       }

      procedure buscarLibroPorRegistro(lista: tListaLibros; regBuscado: integer;
                                                 
              var existe:boolean; 
              var pos: tIndiceLibros;
              var libro: tLibro);
              var mitad, i, j: integer; b:boolean;
                           
              begin

                existe:=false;
                b:=false;
                i:=1;
                j:=lista.num;
                while (not existe) and (regBuscado<=lista.tabla[lista.num].reg) and (not b) do begin
                  mitad:=(i+j) div 2;
                  if (i=j) and (regBuscado <> lista.tabla[mitad].reg) then
                    b:=true;
                    if regBuscado=lista.tabla[mitad].reg then begin
                      existe:=true;
                      pos:=mitad;
                      libro:=lista.tabla[mitad];
                    end
                    else
                      if regBuscado>lista.tabla[mitad].reg then
                        i:=mitad+1
                      else
                        j:=mitad-1;
                end;
              
              end;

 
      {
        OBJ: Mostrar los datos de todos los libros contenidos en la lista.
        ENT: una lista de libros.
        SAL: (por pantalla).
       }

       procedure mostrarBiblioteca(lista: tListaLibros);
      
         var
         i: integer;
              
         begin
          clrscr;
          textcolor(lightcyan);
          writeln('        * LISTA DE LIBROS *      ');
          writeln('       ---------------------     ');
          writeln;
          for i:=1 to lista.num do
           mostrarlibro(lista.tabla[i]);
          end;

     BEGIN

     END.

UNIT ListaSocios;

     (**) INTERFACE

            USES crt, socio;
            const
            tope_socios = 15;
            type
                tIndiceSocios = 1..tope_socios;
                tNumSocios = 0..tope_socios;
                tTablaSocios = array[1..tope_socios] of tSocio;
                tListaSocios = record
                                tabla: tTablaSocios;
                                num: tNumSocios;
                               end;
              procedure inicializarListaSocios(var lista: tListaSocios);
              function listaSociosLlena (lista: tListaSocios): boolean;
              procedure annadirSocio (var lista: tListaSocios; socio: tSocio);
              procedure borrarSocio (var lista: tListaSocios; pos: tIndiceSocios);
              procedure pedirSocio (lista: tListaSocios; pos: tIndiceSocios; var socio: tSocio);
              procedure buscarSocioPorCodigo(lista: tListaSocios;buscado: tCodigo; var existe:boolean;
                                                    var pos: tIndiceSocios; var socio: tSocio);
              procedure mostrarListaSocios(lista: tListaSocios);
              procedure actualizarSocio(var socios: tListaSocios; pos: tIndiceSocios; sAct: tSocio);
              procedure buscarSocioPorPrestamo(lista: tListaSocios; buscado: integer; var existe: boolean;
                                                      var pos: tIndiceSocios; var socio: tSocio);


      (**) IMPLEMENTATION
         
              {
                OBJ: Inicializar una lista de socios a 0.
                ENT: - - -
                SAL: una lista inicializada a 0.
              }
              

              procedure inicializarListaSocios(var lista: tListaSocios);

             
                        begin
                        lista.num:=0;
              end;


              {
                OBJ: Comprobar si la lista de socios está llena.
                ENT: una lista de socios.
                SAL. true si llena / false en caso contrario
              }
              
              function listaSociosLlena(lista: tListaSocios):boolean;
  
                begin
                
                   if (lista.num = tope_socios) then
                    listaSociosLlena:=true
                   else
                    listaSociosLlena:=false;
                
                 end;



              {
                OBJ: A¤adir un socio a la lista de socios siguiendo un criterio (por orden de c¢digo de socio)
                ENT: el socio
                SAL: la lista con el socio a¤adido en la posici¢n correcta
              }
                 
              procedure annadirSocio (var lista: tListaSocios; socio: tSocio);

              

              var i,j: integer;
                  encontrado:boolean;
                  pos: integer;
              
              begin
              
                encontrado:=false;
                if lista.num= 0 then lista.tabla[lista.num+1]:=socio
                else begin
                  if socio.codigo>lista.tabla[lista.num].codigo then begin
                    lista.tabla[lista.num+1]:=socio
                  end
                  else begin
                    if socio.codigo<lista.tabla[1].codigo then begin
                      for j:=lista.num downto 1 do
                        lista.tabla[j+1]:=lista.tabla[j];
                        lista.tabla[1]:=socio
                    end
                    else
                      i:=1;
        
                    while (i<=lista.num) and not encontrado do
                      if((socio.codigo>lista.tabla[i].codigo) and (socio.codigo<lista.tabla[i+1].codigo)) then begin
                        pos:=(i+1);
                        for j:=lista.num downto pos do
                          lista.tabla[j+1]:=lista.tabla[j];
                        lista.tabla[pos]:=socio;
                        encontrado:=true;
                      end {if}
                      else i:=i+1;
                  end;
                end; {else}
                lista.num:=lista.num+1;
                textcolor(lightgreen);
                writeln('Socio añadido con éxito');
                textcolor(green);
                writeln('Pulsa <ENTER> para volver');
                readln;
              
              end;


              {
                OBJ: eliminar un socio de la lista de socios.
                ENT: Una lista de socios y la posición del socio a borrar.
                SAL: La lista con el socio eliminado.
              }

              procedure borrarSocio (var lista: tListaSocios; pos: tIndiceSocios);
                
                var
                i: integer;

                begin
        
                  if pos=lista.num then lista.num:=lista.num-1;
                  else
                    if (pos>lista.num) or (pos<1) then writeln('ERROR');
                    else begin
                      lista.num:=lista.num-1;
                      for i:=pos to lista.num do
                        lista.tabla[i]:=lista.tabla[i+1];
                    end
                  
                end;


              
              {
                OBJ: obtener los datos de un socio a partir de una posición.
                ENT: una lista y la posición del socio.
                SAL: los datos del socio
              }

              procedure pedirSocio (lista: tListaSocios; pos: tIndiceSocios; var socio: tSocio);
 
                var
                cod: tCodigo;
                
                begin
                
                  clrscr;
                  writeln('Introduce el código de un socio: ');
                  readln(cod);
                  socio.codigo:=cod;

                end;

              
              {
                OBJ: averiguar qué socio tiene un libro determinado.
                ENT: el préstamo y la lista de socios.
                SAL: *EXISTE: true si el socio tiene el libro / false en caso contrario
                     *POS: si existe -> la posición en la que se encuentra el socio
                     *SOCIO: si existe -> los datos del socio que tiene el préstamo
              }

              procedure buscarSocioPorPrestamo (lista:tListaSocios; buscado: integer; var existe: boolean; var pos: tIndiceSocios; var socio: tSocio);

                var
                i, j: integer;
                
                begin
             
                  for i:=1 to lista.num do
                    if lista.tabla[i].prestamos.num <>0 then
                      for j:=1 to lista.tabla[i].prestamos.num do
                        if lista.tabla[i].prestamos.tabla[j].registro=buscado then begin
                          existe:=true;
                          socio:=lista.tabla[i];
                          pos:=i;
                        end;
              
                end;


              {
                OBJ: encontrar un socio por un código de socio dado.
                ENT: un código de socio y la lista de socios.
                SAL: *EXISTE: true si existe el socio / false en caso contrario
                     *POS: si existe -> la posici¢n qe ocupa el socio en la lista de socios.
                     *SOCIO: si existe -> los datos del socio con ese código.
              }

              procedure buscarSocioPorCodigo(lista: tListaSocios;buscado: tCodigo; var existe:boolean; var pos: tIndiceSocios; var socio: tSocio);
                
                var
                mitad, i, j: integer;
                b: boolean;

                
                begin

                  existe:=false; b:=false;
                  i:=1;
                  j:=lista.num;
                  while (not existe) and (buscado<=lista.tabla[lista.num].codigo) and (not b) do begin
                    mitad:=(i+j) div 2;
                    if (i=j) and (buscado<>lista.tabla[mitad].codigo) then
                      b:=true;
                    if buscado = lista.tabla[mitad].codigo then begin
                      existe:=true;
                      pos:=mitad;
                      socio:=lista.tabla[mitad];
                    end
                    else
                      if buscado>lista.tabla[mitad].codigo then
                        i:= mitad+1
                      else
                        j:=mitad-1;
                  end;
                
                end;

              

              {
                OBJ: actualizar un socio con nuevos datos.
                ENT: la posición del socio y un socio con nuevos valores.
                SAL: la lista de socios actualizada con los nuevos valores para ese socio.
              }

              procedure actualizarSocio(var socios: tListaSocios; pos: tIndiceSocios; sAct: tSocio);

                begin
                
                  with socios.tabla[pos] do begin
                    nombre:=sAct.nombre;
                    apellidos:=sAct.apellidos;
                    codigo:=sAct.codigo;
                    tipo:=sAct.tipo;
                    prestamos:=sAct.prestamos;
                  end;
                
                end;
       
               
              {
                OBJ: mostrar el contenido de la lista de socios (todos los socios)
                ENT: una lista de socios.
                SAL: los datos de todos los socios de la lista (por pantalla)
              } 
              procedure mostrarListaSocios(lista: tListaSocios);
                var
                i: integer;  existe:boolean;
                
                begin
                
                  clrscr;
                  textcolor(lightred);
                  writeln('      ú LISTA DE SOCIOS ú      ');
                  writeln('     ---------------------     ');
                  writeln;
                  for i:=1 to lista.num do
                     mostrarSocio(lista.tabla[i]);
                end;

begin
end.

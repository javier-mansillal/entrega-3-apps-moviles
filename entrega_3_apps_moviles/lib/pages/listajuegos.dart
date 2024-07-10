
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:entrega_3_apps_moviles/pages/agregarjuegos.dart';
import 'package:entrega_3_apps_moviles/pages/detallejuegos.dart';
import 'package:entrega_3_apps_moviles/services/firestore_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class ListaJuegos extends StatelessWidget {
  const ListaJuegos({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        title: const Text("Lista de juegos", style:TextStyle(fontWeight: FontWeight.bold)),
        leading: const Icon(Icons.sports_esports, size: 40),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: StreamBuilder(
          stream: FirestoreService().juegos(), 
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot){
            if(!snapshot.hasData || snapshot.connectionState==ConnectionState.waiting){
              return const Center(child:CircularProgressIndicator());
            }else{
              return ListView.separated(
                separatorBuilder: (context,index)=>const Divider(),
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context,index){
                  var juego = snapshot.data!.docs[index];
                  return Slidable(
                    endActionPane: ActionPane(
                      motion: const ScrollMotion(),
                      children:[
                        SlidableAction(
                          icon: Icons.delete,
                          label:"Borrar",
                          backgroundColor: Colors.red,
                          onPressed: (context){
                            showDialog(
                              context: context,
                              builder:(BuildContext context){
                                return AlertDialog(
                                  title: const Text("Borrar Juego"),
                                  content: const Text("¿Estás seguro que quieres eliminar este juego?"),
                                  actions: [
                                    TextButton(
                                      child: const Text("Cancelar"),
                                      onPressed: (){
                                        Navigator.of(context).pop();
                                      }
                                    ),
                                    TextButton(
                                      child: const Text("Eliminar"),
                                      onPressed: (){
                                        FirestoreService().borrarJuego(juego.id);
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ]
                                );
                              }
                            );
                            
                          }
                        ),
                      ]
                    ),
                    child: ListTile(
                      leading: const Icon(Icons.gamepad),
                      title: Text('${juego['nombre']}'),
                      subtitle:Text('${juego["estado"]}'),
                      onTap: (){
                        MaterialPageRoute route = MaterialPageRoute(builder: (context) => DetalleJuego(nombre: juego["nombre"], horasJugadas: juego["horas_jugadas"], fecha: juego["fecha"], estado: juego["estado"]));
                        Navigator.push(context,route);
                      }
                    ),
                  );
                }
              );
            }
          },
          ),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.blueGrey,
          child: const Icon(Icons.add),
          onPressed: () {
            // Dirigir a la vista de agregar un nuevo juego.
            MaterialPageRoute route = MaterialPageRoute(builder: (context) => const JuegoAgregarPage());
            Navigator.push(context, route);
          },
        ),
    );
  }
}
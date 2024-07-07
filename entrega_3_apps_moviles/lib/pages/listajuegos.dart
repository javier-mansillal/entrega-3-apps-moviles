
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:entrega_3_apps_moviles/services/firestore_service.dart';
import 'package:flutter/material.dart';

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
                  return ListTile(
                    leading: const Icon(Icons.gamepad),
                    title: Text('${juego['nombre']}'),
                    subtitle:Text('${juego["estado"]}'),
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
          },
        ),
    );
  }
}
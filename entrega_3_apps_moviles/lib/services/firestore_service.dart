import 'package:cloud_firestore/cloud_firestore.dart';


class FirestoreService{
  // Obtener la lista de juegos
  Stream<QuerySnapshot> juegos(){
    return FirebaseFirestore.instance.collection("juegos").orderBy("fecha", descending: true).snapshots();
  }
  // Insertar un juego en la base de datos.
  Future<void> agregarJuego(String nombre, String estado, int horasJugadas, DateTime fecha){
    return FirebaseFirestore.instance.collection('juegos').doc().set({
      'estado': estado,
      'fecha': fecha,
      'horas_jugadas': horasJugadas,
      'nombre': nombre,
    });
  }
  // Borrar un juego de la base de datos
  Future<void> borrarJuego(String docId){
    return FirebaseFirestore.instance.collection('juegos').doc(docId).delete();
  }
  
  // Obtener detalle juegos en base a nombre.
  Future<QuerySnapshot> obtenerDetalleJuego(String nombre){
    return FirebaseFirestore.instance.collection('detalle_juegos').where('nombre', isEqualTo: nombre).get();
  }

}
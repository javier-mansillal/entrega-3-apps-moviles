import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService{
  //Obtener la lista de juegos
  Stream<QuerySnapshot> juegos(){
    return FirebaseFirestore.instance.collection("juegos").snapshots();
  }
}
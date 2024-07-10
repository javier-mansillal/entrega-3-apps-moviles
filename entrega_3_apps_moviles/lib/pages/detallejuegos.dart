import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:entrega_3_apps_moviles/services/firestore_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DetalleJuego extends StatefulWidget {
   final String nombre;
  final String estado;
  final Timestamp fecha;
  final int horasJugadas;

  const DetalleJuego({
  super.key, 
  required this.nombre,
  required this.estado,
  required this.fecha,
  required this.horasJugadas});
  

  @override
  State<DetalleJuego> createState() => _DetalleJuegoState();
}

String _formatearFecha(Timestamp timestamp){
  DateTime fecha = timestamp.toDate();
  final DateFormat formateador = DateFormat('dd/MM/yy');
  return formateador.format(fecha);
}

class _DetalleJuegoState extends State<DetalleJuego> {
  late String fechaFormatJuego;
  late String fechaFormatDetalle;

  @override
  void initState(){
    super.initState();
    fechaFormatJuego = _formatearFecha(widget.fecha);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:Text(widget.nombre)
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text("Estado del juego", style: TextStyle(fontWeight: FontWeight.bold)),
              Text(widget.estado),
              const Text("Horas Jugadas", style: TextStyle(fontWeight: FontWeight.bold)),
              Text("${widget.horasJugadas}"),
              const Text("Fecha de creación", style: TextStyle(fontWeight: FontWeight.bold)),
              Text(fechaFormatJuego),
              FutureBuilder(
                future: FirestoreService().obtenerDetalleJuego(widget.nombre),
                builder: (context, AsyncSnapshot snapshot){
                  if(!snapshot.hasData || snapshot.connectionState == ConnectionState.waiting){
                    return const Text("Cargando detalles del juego.");
                  }
                  else{
                    var detalles = snapshot.data!.docs;
                    if(detalles.isEmpty){
                      return const Column(
                        children:[Text("Información extra del juego", style: TextStyle(fontWeight: FontWeight.w900)), Text("No hay información de este juego.")],
                        
                        );
                    }
                    else{
                    return Column(
            children: detalles.map<Widget>((detalle) {
              var fechaLanzamiento = detalle['fecha_lanzamiento'];
              var horasPromedio = detalle['horas_promedio'];
              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text("Información extra del juego", style: TextStyle(fontWeight: FontWeight.w900)),
                  const Text("Fecha de lanzamiento", style: TextStyle(fontWeight: FontWeight.bold)),
                  Text(_formatearFecha(fechaLanzamiento)),
                  const Text("Horas promedio para terminarlo", style: TextStyle(fontWeight: FontWeight.bold)),
                  Text("$horasPromedio"),
                ],
              );
            }).toList(),
                    );
                  }
                }}
              ),
            ],
          ),
      ),
    );
  }
}
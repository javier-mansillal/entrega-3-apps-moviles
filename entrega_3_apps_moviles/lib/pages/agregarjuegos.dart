import 'package:entrega_3_apps_moviles/services/firestore_service.dart';
import 'package:flutter/material.dart';

class JuegoAgregarPage extends StatefulWidget {
  const JuegoAgregarPage({super.key});

  @override
  State<JuegoAgregarPage> createState() => _JuegoAgregarPageState();
}

class _JuegoAgregarPageState extends State<JuegoAgregarPage> {
  TextEditingController nombreCtrl = TextEditingController();
  TextEditingController horasJugadasCtrl = TextEditingController();
  TextEditingController estadoCtrl = TextEditingController();
  String estado = "";
  final formKey = GlobalKey<FormState>();
  DateTime fecha = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        title: const Text("Agregar juego", style:TextStyle(fontWeight: FontWeight.bold)),
      ),
      body:
        Form(
          key: formKey,
          child: Padding(
            padding:const EdgeInsets.all(10),
            child: ListView(
              children: [
                // Nombre del Juego
                TextFormField(
                controller: nombreCtrl,
                decoration: const InputDecoration(
                  label: Text('Nombre'),
                ),
                validator: (nombre) {
                  if(nombre!.isEmpty){
                    return 'Indique el nombre del juego.';
                  }
                  return null;
                },
                ),
                // Estado del Juego
                Builder(
                  builder: (context){
                  var estados = ["Pendiente", "En curso", "Terminado"];
                  return DropdownButtonFormField<String>(
                    decoration: const InputDecoration(labelText: 'Estado'),
                    items: estados.map<DropdownMenuItem<String>>((estado){
                      return DropdownMenuItem<String>(
                        value: estado,
                        child: Text(estado),
                      );
                    }).toList(),
                    onChanged: (estadoSeleccionado){
                      setState((){
                        estado = estadoSeleccionado!;
                      });
                    },
                    validator:(estado){
                      if(estado == null){
                        return "Indique en que estado está el juego.";
                      }
                    return null;
                    }
                  );
                }
                ),
                // Horas jugadas
                TextFormField(
                  controller: horasJugadasCtrl,
                  decoration: const InputDecoration(
                    label: Text('Horas jugadas hasta ahora.'),
                  ),
                  validator:(horas){
                    if(horas == null || horas.isEmpty){
                      return "Indica las horas jugadas que llevas en el juego.";
                    }
                    int? horasInt = int.tryParse(horas);
                    if(horasInt == null){
                      return "Ingresa un número valido para las horas jugadas";
                    }
                    if (horasInt < 0) {
                      return "Las horas jugadas tienen que ser mayor o igual a 0.";
                    }
                    return null;
                  }
                ),
                // Botón para agregar juego.
                Container(
                  margin: const EdgeInsets.only(top:10),
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.blueGrey),
                    child: const Text('Agregar juego', style: TextStyle(color: Colors.white)),
                    onPressed:(){
                      if(formKey.currentState!.validate()){
                        // Agregar un juego a la base de datos de Firestore.
                        FirestoreService().agregarJuego(
                          nombreCtrl.text.trim(), 
                          estado, 
                          int.parse(horasJugadasCtrl.text.trim()), 
                          fecha,
                        );
                        //Devolverse a la página principal.
                        Navigator.pop(context);
                      }
                    },
                  ),
                ),
            ],
            ),
          ),
        ),
    );
  }
}
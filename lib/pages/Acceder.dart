import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart'; // Importa flutter_svg
import 'package:get/get.dart';
import 'package:tienda_login/pages/Estadisticas2.dart';
import 'package:page_transition/page_transition.dart';
import 'package:tienda_login/pages/Inicio.dart';
import 'package:tienda_login/pages/RegisterPage.dart';
import 'package:tienda_login/pages/Tareas.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

class Acceder extends StatefulWidget {
  @override
  _AccederState createState() => _AccederState();
}

class _AccederState extends State<Acceder> {
  FirebaseFirestore db = FirebaseFirestore.instance;

  Future<Map<String, dynamic>?> verifyUser(
      String nombre, String contrasena, BuildContext context) async {
    QuerySnapshot querySnapshot = await db
        .collection("Emprendedor")
        .where("Nombre", isEqualTo: nombre)
        .where("Contraseña", isEqualTo: contrasena)
        .get();

    //Encontramos al usuario
    if (querySnapshot.docs.isNotEmpty) {
      // Inicializar un mapa vacío para almacenar los datos del usuario
      Map<String, dynamic> userData = {};
      // Iterar sobre los documentos devueltos por la consulta
      for (var doc in querySnapshot.docs) {
        // Asignar los datos de cada documento al mapa userData
        userData = doc.data() as Map<String, dynamic>;
        userData["EmprendedorId"] = doc.id;
      }
      // Devolver los datos del usuario

      return userData;
    } else {
      // Mostrar alerta en caso de que no se encuentre el usuario
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Error de autenticación"),
            content: Text("El usuario o la contraseña no son válidos."),
            actions: <Widget>[
              TextButton(
                child: Text("Cerrar"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  TextEditingController nameController = TextEditingController(text: "");
  TextEditingController passController = TextEditingController(text: "");

  final _formKey =
      GlobalKey<FormState>(); // Agrega un GlobalKey para el formulario
  @override
  Widget build(BuildContext context) {
    final query = MediaQuery.of(context);

    //Lista de todas las rutas

    return MediaQuery(
        data: query.copyWith(textScaleFactor: 1.0),
        child: Scaffold(
          resizeToAvoidBottomInset: true,

          appBar: AppBar(
            elevation: 0, // Esta línea eliminará la sombra del AppBar
            backgroundColor: Color.fromARGB(255, 255, 255, 255),
          ),
          // La siguiente línea deshabilita la redimensión automática del contenido cuando aparece el teclado en la pantalla.
          // Configura el contenido principal de la pantalla dentro de un widget Form.
          body: SingleChildScrollView(
              child: Form(
            key: _formKey,
            child: Container(
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 255, 255, 255),
              ),
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(padding: EdgeInsets.only(top: 10)),
                  Container(
                      //margin: EdgeInsets.only(bottom: 10),
                      child: Text(
                    "Iniciar Sesión",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 30,
                        fontFamily: 'Noto Sans',
                        color: Color(0xff313A56)),
                  )),
                  Padding(
                    padding: const EdgeInsets.only(top: 50.0),
                  ),
                  SizedBox(height: 10),
                  //Container para el usuario
                  Container(
                    width: 290,
                    height: 35,
                    child: Text(
                      "Nombre de usuario",
                      style: TextStyle(
                          color: Color(0xff313A56),
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Noto Sans'),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 20.0),
                    child: Container(
                      width: 305,
                      //// Márgenes horizontales de 20 puntos
                      margin: EdgeInsets.symmetric(horizontal: 20.0),
                      padding: EdgeInsets.all(
                          4.0), // // Relleno interno de 10 puntos
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 255, 255,
                            255), // Color de fondo del TextFormField
                        borderRadius:
                            BorderRadius.circular(10.0), // Bordes redondeados
                      ),
                      child: Container(
                        height: 60,
                        width: 200,
                        child: Column(
                          children: [
                            Container(
                              width: 290,
                              height: 40,
                              child: TextFormField(
                                controller: nameController,
                                style: TextStyle(
                                    fontSize: 15,
                                    color: Color(
                                        0xff313A56)), // Establece el color del texto.
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                      borderSide: BorderSide(
                                    width: 100,
                                    color: Color(0xFF1D1B45),
                                  )), // Elimina el borde del TextFormField
                                ),
                                onSaved: (String? value) {
                                  // This optional block of code can be used to run
                                  // code when the user saves the form.
                                },
                                /*   validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Por favor ingrese su nombre de usuario';
                                  }
                                  return null;
                                },*/
                              ),
                            ),
                            SizedBox(
                                height:
                                    8), // Ajusta esta altura según tus necesidades
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 2),

                  Container(
                    width: 290,
                    height: 35,
                    child: Text(
                      "Contraseña",
                      style: TextStyle(
                          color: Color(0xff313A56),
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Noto Sans'),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 20.0),
                    child: Container(
                      width: 315,
                      //// Márgenes horizontales de 20 puntos
                      margin: EdgeInsets.symmetric(horizontal: 20.0),
                      padding: EdgeInsets.all(
                          4.0), // // Relleno interno de 10 puntos
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 255, 255,
                            255), // Color de fondo del TextFormField
                        borderRadius:
                            BorderRadius.circular(10.0), // Bordes redondeados
                      ),
                      child: Container(
                        height: 60,
                        width: 290,
                        child: Column(
                          children: [
                            Container(
                              width: 290,
                              height: 40,
                              child: TextFormField(
                                controller: passController,
                                obscureText: true,

                                style: TextStyle(
                                    fontSize: 15,
                                    color: Color(
                                        0xff313A56)), // Establece el color del texto.
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                      borderSide: BorderSide(
                                    width: 5,
                                    color: Color(0xFF1D1B45),
                                  )), // Elimina el borde del TextFormField
                                ),
                                onSaved: (String? value) {
                                  // This optional block of code can be used to run
                                  // code when the user saves the form.
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 45),
                  Container(
                    width: 310,
                    height: 40,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 20.0),
                      child: ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            //Guardamos lo que devolvio la función verifyUser, que contiene los datoa del usuario
                            Map<String, dynamic>? userData = await verifyUser(
                              nameController.text,
                              passController.text,
                              context,
                            );
                            //Verificamos que no este vacío
                            if (userData != null) {
                              Navigator.push(
                                context,
                                PageTransition(
                                  type: PageTransitionType
                                      .fade, // Otra transición si prefieres
                                  child: Inicio(data: userData),
                                ),
                              );
                            }
                          }
                        },
                        child: Text(
                          "Continuar",
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.normal,
                              fontFamily: 'Noto Sans',
                              color: Colors.white),
                        ),
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              Color(0xff313A56)), // Establece el color de fondo
                          foregroundColor: MaterialStateProperty.all<Color>(
                              Color(0xFFF313A56)),
                          minimumSize: MaterialStateProperty.all<Size>(
                              Size(200, 50)), // Establece el color del texto}
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                          elevation: MaterialStateProperty.all(0),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 260,
                  ),
                ],
              ),
            ),
          )),
        ));
  }
}

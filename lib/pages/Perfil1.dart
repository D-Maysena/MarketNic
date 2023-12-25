import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_svg/flutter_svg.dart'; // Importa flutter_svg
import 'package:get/get.dart';
import 'package:tienda_login/pages/Inicio.dart';
import 'package:tienda_login/pages/Estadisticas2.dart';
import 'package:page_transition/page_transition.dart';
import 'package:tienda_login/pages/Inicio.dart';
import 'package:tienda_login/pages/Inventario1.dart';
import 'package:tienda_login/pages/Tareas.dart';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

class AgregarProductos1 extends StatefulWidget {
  @override
  _AgregarProductos1State createState() => _AgregarProductos1State();
}

class _AgregarProductos1State extends State<AgregarProductos1> {
  File? _imageFile;
  FirebaseFirestore db = FirebaseFirestore.instance;

  Future<void> addProduct(String codigoProducto, String nombre, String precio,
      String cantidad, String descripcion) async {
    Map<String, dynamic> data = {
      "Codigo": codigoProducto,
      "Nombre": nombre,
      "Precio": precio,
      "Cantidad": cantidad,
      "Descripcion": descripcion,
    };
    await db.collection("Productos").add(data);
  }

  TextEditingController codeController = TextEditingController(text: "");
  TextEditingController nameController = TextEditingController(text: "");
  TextEditingController priceController = TextEditingController(text: "");
  TextEditingController countController = TextEditingController(text: "");
  TextEditingController descController = TextEditingController(text: "");

  Future<void> _selectImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final query = MediaQuery.of(context);

    //Lista de todas las rutas
    final List<Widget> screens = [
      Inicio(),
      Estadisticas(),
      Tareas(),
      Inventario1()
    ];

    return MediaQuery(
      data: query.copyWith(textScaleFactor: 1.0),
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(60.0),
          child: AppBar(
            iconTheme: IconThemeData(color: Colors.black),
            backgroundColor: Color.fromARGB(255, 255, 255, 255),
            elevation: 0.0,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                ),
              ],
            ),
            actions: [
              Container(
                margin: EdgeInsets.fromLTRB(0, 0, 30, 0),
                padding: EdgeInsets.only(left: 20.0),
                child: IconButton(
                  onPressed: () {
                    // Acción a realizar cuando se presiona el segundo IconButton
                    print('Presionado el segundo IconButton');
                  },
                  icon: Icon(
                    Icons.notifications_none,
                    size: 30,
                  ),
                  color: Color(0xFF1D1B45),
                ),
              ),
            ],
            bottom: PreferredSize(
              preferredSize: Size.fromHeight(40.0),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 30.0),
                child: Divider(
                  height: 1,
                  color: Colors.black,
                  thickness: 3,
                ),
              ),
            ),
          ),
        ),
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 20, left: 20),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20.0),
                      child: Text(
                        'Editar Perfil',
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1D1B45),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      _selectImage();
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 15.0),
                        child: Container(
                          width: 350,
                          height: 110,
                          decoration: BoxDecoration(
                            color: Colors.grey,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Stack(
                            children: [
                              if (_imageFile != null)
                                Positioned.fill(
                                  child: Image.file(
                                    _imageFile!,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              Center(
                                child: Icon(
                                  Icons.add_a_photo,
                                  size: 40,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 0, left: 40),
                    child: Text(
                      'Nombre',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1D1B45),
                      ),
                    ),
                  ),
                ],
              ),

              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(30, 5, 5, 15),
                    child: Container(
                      width: 350,
                      height: 50,
                      child: TextFormField(
                        controller: codeController,
                        decoration: InputDecoration(
                          hintText: 'Ingrese su nombre',
                          border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.blue),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.blue),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 0, left: 40),
                    child: Text(
                      'Correo Electronico',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1D1B45),
                      ),
                    ),
                  ),
                ],
              ),

              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(30, 5, 5, 15),
                    child: Container(
                      width: 350,
                      height: 50,
                      child: TextFormField(
                        controller: nameController,
                        decoration: InputDecoration(
                          hintText: 'Ingrese su correo electronico',
                          border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.blue),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.blue),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 0, left: 40),
                    child: Text(
                      'Contraseña',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1D1B45),
                      ),
                    ),
                  ),
                ],
              ),

              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(30, 5, 5, 15),
                    child: Container(
                      width: 350,
                      height: 50,
                      child: TextFormField(
                        controller: priceController,
                        decoration: InputDecoration(
                          hintText: 'Ingrese su contraseña',
                          border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.blue),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.blue),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 0, left: 40),
                    child: Text(
                      'Confirmar Contraseña',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1D1B45),
                      ),
                    ),
                  ),
                ],
              ),

              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(30, 5, 5, 15),
                    child: Container(
                      width: 350,
                      height: 50,
                      child: TextFormField(
                        controller: countController,
                        decoration: InputDecoration(
                          hintText: ' ',
                          border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.blue),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.blue),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),

             

             

              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(15, 5, 5, 15),
                    child: ElevatedButton(
                      onPressed: () {
                        // Acción a realizar cuando se presiona el botón
                        Navigator.push(
                          context,
                          PageTransition(
                            type: PageTransitionType.fade,
                            child: screens[3],
                          ),
                        );
                      //   addProduct(
                      //       codeController.text,
                      //       nameController.text,
                      //       priceController.text,
                      //       countController.text,
                      //       descController.text);
                      // 
                      },
                      style: ButtonStyle(
                        fixedSize: MaterialStateProperty.all<Size>(
                          Size(380, 50),
                        ),
                        backgroundColor: MaterialStateProperty.all<Color>(
                            const Color(
                                0xFF1D1B45)), // Cambia el color de fondo del botón a azul
                      ),
                      child: Text('Guardar Cambios',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 230, 230, 230),
                          )),
                    ),
                  ),
                ],
              ),

              // ... el resto de tu código ...
            ],
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          unselectedItemColor: Colors.grey,
          iconSize: 46,
          currentIndex: 0,
          onTap: (index) {
            // Cambia la pantalla según el índice seleccionado
            if (index == 3) {
              Navigator.push(
                context,
                PageTransition(
                  type: PageTransitionType.fade,
                  child: screens[index],
                ),
              );
            }
          },
          items: [
            BottomNavigationBarItem(
              icon: Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Icon(Icons.home, color: Colors.grey),
              ),
              label: ' Inicio',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.add_circle_outline),
              label: ' Productos',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.list_outlined),   
              label: 'Tareas',
            ),
            BottomNavigationBarItem(
              icon:
                  Icon(Icons.account_circle_outlined, color: Color(0xFF1D1B45)),
              label: 'Perfil',
            ),
          ],
        ),
      ),
    );
  }
}

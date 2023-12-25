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
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';

class Perfil extends StatefulWidget {
  final Map<String, dynamic>? data;

  Perfil({Key? key, this.data}) : super(key: key);
  @override
  _PerfilState createState() => _PerfilState();
}

class _PerfilState extends State<Perfil> {
  File? _imageFile;
  final storageRef = FirebaseStorage.instance.ref();

  FirebaseFirestore db = FirebaseFirestore.instance;

  Future<String> nombreTienda() async {
    //Hacemos una consulta, filtrando, eso nos devuelve varios resultados
    QuerySnapshot docRef = await db
        .collection("Emprendimiento")
        .where("EmprendedorId", isEqualTo: widget.data?["EmprendedorId"])
        .get();

    if (docRef.docs.isNotEmpty) {
      //Accedemos al primer elemento de la consulta, luego accedemos a su campo "Titulo"
      String titulo = docRef.docs[0]["Titulo"];
      return titulo;
    } else {
      return "";
    }
  }

  Future<String> correoTienda() async {
    //Hacemos una consulta, filtrando, eso nos devuelve varios resultados
    QuerySnapshot docRef = await db
        .collection("Emprendimiento")
        .where("EmprendedorId", isEqualTo: widget.data?["EmprendedorId"])
        .get();

    print("Hola");
    print(widget.data);
    if (docRef.docs.isNotEmpty) {
      //Accedemos al primer elemento de la consulta, luego accedemos a su campo "Titulo"
      String titulo = docRef.docs[0]["Correo"];
      return titulo;
    } else {
      return "";
    }
  }

  Future<void> updateDocument(
      String nombre, String correo, String contrasena, String imageUrl) async {
    try {
      String documentId = widget.data?["EmprendedorId"];
      DocumentReference documentReference =
          FirebaseFirestore.instance.collection('Emprendedor').doc(documentId);

      await documentReference.update({
        'Nombre': nombre,
        'Correo': correo,
        'Contraseña': contrasena,
        'Imagen': imageUrl
      });

      print("Documento actualizado correctamente");
    } catch (error) {
      print("Error al actualizar el documento: $error");
    }
  }

  TextEditingController nameController = TextEditingController(text: "");
  TextEditingController gmailController = TextEditingController(text: "");
  TextEditingController passControlles = TextEditingController(text: "");
  TextEditingController confirController = TextEditingController(text: "");

  String imageUrl = "";
  Future<String> _selectImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }

    String nombre = widget.data?["Nombre"];

    if (_imageFile != null) {
      imageUrl = await _uploadImageToFirebase(_imageFile!, nombre, imageUrl);
    } else {
      print("El archivo de imagen es nulo");
    }

    print("Seleccion de imagen");
    print(imageUrl);
    print("Nombre");
    print(nombre);
    return imageUrl;
  }

  Future<String> _uploadImageToFirebase(
      File image, String nombreEmprendimiento, String currentImageUrl) async {
    String newImageUrl = currentImageUrl;

    try {
      var reference = storageRef.child(
          'Emprendedores/$nombreEmprendimiento/${DateTime.now().toString()}');
      UploadTask uploadTask = reference.putFile(image);
      TaskSnapshot storageSnapshot = await uploadTask;
      newImageUrl = await storageSnapshot.ref.getDownloadURL();

      print('File Uploaded');
    } catch (e) {
      print("Error");
    }
    print("Subir imagen");
    print(newImageUrl);
    return newImageUrl;
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
            automaticallyImplyLeading: false,
            iconTheme: IconThemeData(color: Colors.black),
            backgroundColor: Color.fromARGB(255, 255, 255, 255),
            elevation: 0.0,
            title: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.only(left: 17),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 0.0),
                    child: FutureBuilder<String>(
                      future: nombreTienda(),
                      builder: (BuildContext context,
                          AsyncSnapshot<String> snapshot) {
                        if (snapshot.hasData) {
                          return Text(
                            snapshot.data!,
                            style: TextStyle(
                              fontFamily: 'Inter',
                              color: Color(0xFF1D1B45),
                              fontSize: 20,
                            ),
                          );
                        } else {
                          return Text(
                            '',
                            style: TextStyle(
                              fontFamily: 'Bebas Neue',
                              color: Color(0xFF1D1B45),
                              fontSize: 25,
                            ),
                          );
                        }
                      },
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(left: 17),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 0.0),
                    child: FutureBuilder<String>(
                      future: correoTienda(),
                      builder: (BuildContext context,
                          AsyncSnapshot<String> snapshot) {
                        if (snapshot.hasData) {
                          return Text(
                            snapshot.data!,
                            style: TextStyle(
                              fontFamily: 'Noto Sans',
                              color: Color(0xff858585),
                              fontWeight: FontWeight.normal,
                              fontSize: 13,
                            ),
                          );
                        } else {
                          return Text(
                            'Correo no especificado',
                            style: TextStyle(
                              fontFamily: 'Bebas Neue',
                              color: Color(0xFF1D1B45),
                              fontSize: 13,
                            ),
                          );
                        }
                      },
                    ),
                  ),
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
                    onTap: () async {
                      String imageUrl = await _selectImage();
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 90.0),
                        child: Container(
                          width: 200,
                          height: 200,
                          decoration: BoxDecoration(
                            color: Colors.grey,
                            shape: BoxShape.circle,
                          ),
                          child: ClipOval(
                            child: Container(
                              width: 200,
                              height: 170,
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
                    ),
                  ),
                ],
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 0, left: 65),
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
                      width: 300,
                      margin: EdgeInsets.only(left: 20),
                      height: 50,
                      child: TextFormField(
                        controller: nameController,
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
                    margin: EdgeInsets.only(top: 0, left: 60),
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
                      width: 300,
                      margin: EdgeInsets.only(left: 20),
                      height: 50,
                      child: TextFormField(
                        controller: gmailController,
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
                    margin: EdgeInsets.only(top: 0, left: 65),
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
                      width: 300,
                      margin: EdgeInsets.only(left: 20),
                      height: 50,
                      child: TextFormField(
                        controller: passControlles,
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
                    margin: EdgeInsets.only(top: 0, left: 65),
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
                      width: 300,
                      margin: EdgeInsets.only(left: 20),
                      height: 50,
                      child: TextFormField(
                        controller: confirController,
                        decoration: InputDecoration(
                          hintText: 'Confirmar contraseña',
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
                    padding: const EdgeInsets.fromLTRB(0, 5, 5, 15),
                    child: Container(
                      width: 300,
                      margin: EdgeInsets.only(left: 50),
                      child: ElevatedButton(
                        onPressed: () {
                          if (nameController.text.isNotEmpty &&
                              gmailController.text.isNotEmpty &&
                              passControlles.text.isNotEmpty &&
                              confirController.text.isNotEmpty) {
                            print(imageUrl);
                            updateDocument(
                                nameController.text,
                                gmailController.text,
                                passControlles.text,
                                imageUrl);

                            Navigator.push(
                              context,
                              PageTransition(
                                type: PageTransitionType.fade,
                                child: Inicio(data: widget.data),
                              ),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                    'Por favor, completa todos los campos.'),
                              ),
                            );
                          }
                        },
                        style: ButtonStyle(
                          fixedSize: MaterialStateProperty.all<Size>(
                            Size(350, 50),
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
                  ),
                ],
              ),

              // ... el resto de tu código ...
            ],
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
            unselectedItemColor: Colors.grey,
            selectedItemColor: Color(0xFF1D1B45),
            iconSize: 40,
            currentIndex: 0,
            onTap: (index) {
              // Cambia la pantalla según el índice seleccionado
              if (index == 0) {
                Navigator.push(
                  context,
                  PageTransition(
                    type: PageTransitionType.fade,
                    child: Inicio(data: widget.data),
                  ),
                );
              } else if (index == 1) {
                Navigator.push(
                  context,
                  PageTransition(
                    type: PageTransitionType.fade,
                    child: Inventario1(emprendedor_Id: widget.data),
                  ),
                );
              } else if (index == 2) {
                Navigator.push(
                  context,
                  PageTransition(
                    type: PageTransitionType.fade,
                    child: Tareas(data: widget.data),
                  ),
                );
              }
            },
            items: [
              BottomNavigationBarItem(
                icon: Icon(Icons.home, color: Colors.grey),
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
                icon: Icon(Icons.account_circle_outlined,
                    color: Color(0xFF1D1B45)),
                label: 'Perfil',
              ),
            ],
            showUnselectedLabels: true),
      ),
    );
  }
}

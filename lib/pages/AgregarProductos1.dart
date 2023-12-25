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

class AgregarProductos1 extends StatefulWidget {
  final Map<String, dynamic>? data;

  AgregarProductos1({Key? key, this.data}) : super(key: key);
  @override
  _AgregarProductos1State createState() => _AgregarProductos1State();
}

class _AgregarProductos1State extends State<AgregarProductos1> {
  int contador = 1;
  String imageUrl = "";
  File? _imageFile;
  //Instancia para subir imagenes
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

    if (docRef.docs.isNotEmpty) {
      //Accedemos al primer elemento de la consulta, luego accedemos a su campo "Titulo"
      String titulo = docRef.docs[0]["Correo"];
      return titulo;
    } else {
      return "";
    }
  }

  Future<String> EmprendimientoId() async {
    //DocumentReference es una referencia a un documento específico en una base de datos Firestore.
    //Guardamos la referencia al documento "Emprendeddor"
    QuerySnapshot querySnapshot = await db
        .collection("Emprendimiento")
        .where("EmprendedorId", isEqualTo: widget.data?["EmprendedorId"])
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      String emprendimientoId = querySnapshot.docs[0].id;
      print("Emprendimiento id: ");
      print(emprendimientoId);
      return emprendimientoId;
    } else {
      return 'Ha ocurrido un eror';
    }
  }

  Future<void> addProduct(String codigoProducto, String nombre, String precio,
      String cantidad, String descripcion, String imageUrl) async {
    String emprendimientoId = await EmprendimientoId();

    Map<String, dynamic> data = {
      "Codigo": codigoProducto,
      "Nombre": nombre,
      "Precio": precio,
      "Cantidad": cantidad,
      "Descripcion": descripcion,
      "ProductoUrl": imageUrl,
      "EmprendimientoId": emprendimientoId
    };
    await db.collection("Productos").add(data);
  }

  TextEditingController codeController = TextEditingController(text: "");
  TextEditingController nameController = TextEditingController(text: "");
  TextEditingController priceController = TextEditingController(text: "");
  TextEditingController countController = TextEditingController(text: "");
  TextEditingController descController = TextEditingController(text: "");

  Future<String> _selectImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
    QuerySnapshot querySnapshot = await db
        .collection("Emprendimiento")
        .where("EmprendedorId", isEqualTo: widget.data?["EmprendedorId"])
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      String titulo = querySnapshot.docs[0]["Titulo"];

      if (_imageFile != null) {
        imageUrl = await _uploadImageToFirebase(_imageFile!, titulo, imageUrl);
      } else {
        print("El archivo de imagen es nulo");
      }
    } else {
      print("error");
    }
    print("Seleccion de imagen");
    print(imageUrl);
    return imageUrl;
  }

  Future<String> _uploadImageToFirebase(
      File image, String emprendimiento, String currentImageUrl) async {
    String newImageUrl = currentImageUrl;

    try {
      var reference = storageRef
          .child('Productos/$emprendimiento/${DateTime.now().toString()}');
      UploadTask uploadTask = reference.putFile(image);
      TaskSnapshot storageSnapshot = await uploadTask;
      newImageUrl = await storageSnapshot.ref.getDownloadURL();

      print('File Uploaded');
      contador++;
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
            title: Row(
              children: [
                Container(
                  margin: EdgeInsets.only(left: 0),
                  child: IconButton(
                    onPressed: () {
                      // Agrega aquí la acción para regresar a la pantalla anterior
                      Navigator.pop(context);
                    },
                    icon: Icon(Icons.arrow_back_ios, color: Colors.black),
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.only(left: 0),
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
                      padding: EdgeInsets.only(left: 0),
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
                        'Añadir Productos',
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
              Column(
                children: [
                  Container(
                    margin: EdgeInsets.only(right: 35),
                    child: GestureDetector(
                      onTap: () async {
                        String imageUrl = await _selectImage();
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(
                            top: 15.0, left: 15, bottom: 19),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 15.0),
                          child: Container(
                            width: 345,
                            height: 100,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: const Color.fromARGB(255, 120, 129,
                                    136), // Color del borde punteado
                                style:
                                    BorderStyle.solid, // Tipo de borde punteado
                              ),
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
                                  child: Text("Agregar foto del producto",
                                      style: TextStyle(
                                          fontSize: 13,
                                          fontFamily: 'Noto Sans')),
                                ),
                              ],
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
                    margin: EdgeInsets.only(top: 0, left: 50),
                    child: Text(
                      'Código',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1D1B45),
                      ),
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(30, 5, 5, 15),
                    child: Container(
                      margin: EdgeInsets.only(right: 35),
                      width: 345,
                      height: 50,
                      child: TextFormField(
                        controller: codeController,
                        decoration: InputDecoration(
                          hintText: 'Ingrese su código de producto',
                          hintStyle:
                              TextStyle(fontFamily: 'Noto Sans', fontSize: 13),
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 15.0,
                              horizontal: 20.0), // Ajusta según tus necesidades
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(13),
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
                    margin: EdgeInsets.only(top: 0, left: 50),
                    child: Text(
                      'Nombre del producto',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1D1B45),
                      ),
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(30, 5, 5, 15),
                    child: Container(
                      margin: EdgeInsets.only(right: 35),
                      width: 345,
                      height: 50,
                      child: TextFormField(
                        controller: nameController,
                        decoration: InputDecoration(
                          hintText: 'Ingrese el nombre del producto',
                          hintStyle:
                              TextStyle(fontFamily: 'Noto Sans', fontSize: 13),
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 15.0, horizontal: 20.0),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(13),
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
                    margin: EdgeInsets.only(top: 0, left: 50),
                    child: Text(
                      'Precio',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1D1B45),
                      ),
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(30, 5, 0, 15),
                    child: Container(
                      margin: EdgeInsets.only(right: 35),
                      width: 350,
                      height: 50,
                      child: TextFormField(
                        controller: priceController,
                        decoration: InputDecoration(
                          hintText: 'Ingrese el precio del producto',
                          hintStyle:
                              TextStyle(fontFamily: 'Noto Sans', fontSize: 13),
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 15.0, horizontal: 20.0),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(13),
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
                    margin: EdgeInsets.only(top: 0, left: 50),
                    child: Text(
                      'Cantidad',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1D1B45),
                      ),
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(30, 5, 0, 15),
                    child: Container(
                      margin: EdgeInsets.only(right: 35),
                      width: 350,
                      height: 50,
                      child: TextFormField(
                        controller: countController,
                        decoration: InputDecoration(
                          hintText: ' Ingrese la cantidad del producto',
                          hintStyle:
                              TextStyle(fontFamily: 'Noto Sans', fontSize: 13),
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 15.0, horizontal: 18.0),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(13),
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
                    margin: EdgeInsets.only(top: 0, left: 50),
                    child: Text(
                      'Descripcion',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1D1B45),
                      ),
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(30, 5, 0, 15),
                    child: Column(
                      children: [
                        Container(
                          margin: EdgeInsets.only(right: 35),
                          width: 350,
                          height: 50,
                          child: TextFormField(
                            controller: descController,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 15.0, horizontal: 18.0),
                              hintText: 'Ingrese una descripcion del producto',
                              hintStyle: TextStyle(
                                  fontFamily: 'Noto Sans', fontSize: 13),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(13),
                                borderSide: BorderSide(color: Colors.grey),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(30, 5, 0, 15),
                    child: Container(
                      margin: EdgeInsets.only(right: 35),
                      height: 60,
                      width: 348,
                      child: ElevatedButton(
                        onPressed: () {
                          // Acción a realizar cuando se presiona el botón

                          if (codeController.text.isNotEmpty &&
                              nameController.text.isNotEmpty &&
                              priceController.text.isNotEmpty &
                                  countController.text.isNotEmpty &&
                              descController.text.isNotEmpty) {
                            print(imageUrl);
                            addProduct(
                                codeController.text,
                                nameController.text,
                                priceController.text,
                                countController.text,
                                descController.text,
                                imageUrl);

                            Navigator.push(
                              context,
                              PageTransition(
                                type: PageTransitionType.fade,
                                child: Inventario1(emprendedor_Id: widget.data),
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
                            Size(380, 50),
                          ),
                          backgroundColor: MaterialStateProperty.all<Color>(
                            const Color(0xFF1D1B45),
                          ),
                          shape: MaterialStateProperty.all<OutlinedBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  10.0), // Ajusta el valor según lo que desees
                            ),
                          ),
                        ),
                        child: Text('Añadir Producto',
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
                icon: Icon(
                  Icons.home,
                  color: Colors.grey,
                ),
                label: ' Inicio',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.add_circle_outline, color: Color(0xFF1D1B45)),
                label: ' Productos',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.list_outlined),
                label: 'Tareas',
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.account_circle_outlined,
                ),
                label: 'Perfil',
              ),
            ],
            showUnselectedLabels: true),
      ),
    );
  }
}

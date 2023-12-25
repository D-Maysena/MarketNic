import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:tienda_login/pages/Inicio.dart';
import 'package:image_picker/image_picker.dart';
import 'package:page_transition/page_transition.dart';
import 'package:tienda_login/pages/Registro2.dart';
import 'package:tienda_login/pages/RegistroEm2.dart';

class RegistroEm extends StatefulWidget {
  final Map<String, dynamic>? emprendedor_id;

  RegistroEm({Key? key, this.emprendedor_id}) : super(key: key);

  @override
  _RegistroEmState createState() => _RegistroEmState();
}

class _RegistroEmState extends State<RegistroEm> {
  FirebaseFirestore db = FirebaseFirestore.instance;

  Future<Map<String, dynamic>> addBusiness(
      String titulo,
      String tipo,
      String numeroTel,
      String correo,
      String nombreEmprendimiento,
      String emprendedor_id) async {
    Map<String, dynamic> data = {
      "EmprendedorId": emprendedor_id,
      "Titulo": titulo,
      "Tipo": tipo,
      "Numero": numeroTel,
      "Correo": correo
    };

    await db.collection("Emprendimiento").add(data);

    return data;
  }

  TextEditingController titleController = TextEditingController(text: "");
  TextEditingController typeController = TextEditingController(text: "");
  TextEditingController numberController = TextEditingController(text: "");
  TextEditingController emailController = TextEditingController(text: "");

  final List<Widget> screens = [RegistroEm2()];
  final List<String> tipoEmp = [
    'Ninguno',
    'Accesorios',
    'Ropa',
    'Zapatos',
    'Farmacia',
    'Bisuteria',
    'Bebidas',
    'Otro'
  ];
  String dropdownValue = 'Ninguno'; // Valor seleccionado por defecto

  @override
  Widget build(BuildContext context) {
    final query = MediaQuery.of(context);
    return MediaQuery(
      data: query.copyWith(textScaleFactor: 1.0),
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: Text(" "),
          backgroundColor: Color.fromARGB(255, 255, 255, 255),
        ),
        body: ListView.builder(
          itemCount: 1,
          itemBuilder: (context, index) {
            return Center(
              child: Container(
                padding: EdgeInsets.only(top: 20.0),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 255, 255, 255),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(height: 0),
                    Container(
                      child: Container(
                        margin: EdgeInsets.fromLTRB(15, 0, 0, 0),
                        width: 296,
                        height: 80,
                        child: Stack(
                          children: [
                            Positioned(
                              width: 296,
                              height: 79,
                              top: -0,
                              child: Container(
                                child: Text(
                                  "Registro de Emprendimiento",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Color(0xFF1D1B45),
                                    fontSize: 31,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Noto Sans',
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 40),
                    Container(
                      width: 300,
                      height: 35,
                      child: Text(
                        "Nombre del Emprendimiento",
                        style: TextStyle(
                            color: Color(0xFF1D1B45),
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
                          height: 46,
                          width: 290,
                          child: TextFormField(
                            controller: titleController,
                            style: TextStyle(
                                color: Color(
                                    0xff313A56)), // Establece el color del texto.
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                width: 10,
                                color: Color(0xFF1D1B45),
                              )), // Elimina el borde del TextFormField
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Container(
                      width: 300,
                      height: 35,
                      child: Text(
                        "Tipo de Emprendimiento",
                        style: TextStyle(
                            color: Color(0xFF1D1B45),
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Noto Sans'),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 15.0),
                      child: Container(
                        width: 320,
                        margin: EdgeInsets.symmetric(horizontal: 20.0),
                        padding: EdgeInsets.all(4.0),
                        decoration: BoxDecoration(
                          color: Color.fromARGB(255, 255, 255, 255),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(right: 4.0),
                            ),
                            Container(
                              height: 46,
                              width: 290,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Color(
                                      0xFF1D1B45), // Aquí puedes ajustar el color del borde
                                  width:
                                      1.0, // Puedes ajustar el ancho del borde según tus necesidades
                                ),
                              ),
                              child: DropdownButton<String>(
                                value: dropdownValue,
                                icon: Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left:
                                              60), // Ajusta el espacio entre los iconos
                                      child: Icon(Icons.arrow_downward_sharp,
                                          color: Color(0xFF1D1B45)),
                                    ),
                                  ],
                                ),
                                iconEnabledColor: Colors.white,
                                elevation: 16,
                                padding: EdgeInsets.only(left: 80),
                                style: const TextStyle(
                                  color: Color(
                                      0xff313A56), // Ajusta el color del texto del menú desplegable
                                  fontSize: 18,
                                ),
                                dropdownColor: Color.fromARGB(255, 255, 255,
                                    255), // Ajusta el color de fondo del menú desplegable
                                underline: Container(
                                  height: 0,
                                  color: Colors.white,
                                ),
                                onChanged: (String? value) {
                                  if (value != null) {
                                    setState(() {
                                      dropdownValue = value;
                                      typeController.text = value;
                                    });
                                  }
                                },
                                items: tipoEmp.map<DropdownMenuItem<String>>(
                                    (String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Container(
                      width: 300,
                      height: 35,
                      child: Text(
                        "Número de teléfono",
                        style: TextStyle(
                            color: Color(0xFF1D1B45),
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
                          height: 46,
                          width: 290,
                          child: TextFormField(
                            controller: numberController,
                            style: TextStyle(
                                color: Color(
                                    0xff313A56)), // Establece el color del texto.
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                width: 10,
                                color: Color(0xFF1D1B45),
                              )), // Elimina el borde del TextFormField
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Container(
                      width: 300,
                      height: 35,
                      child: Text(
                        "Correo electrónico",
                        style: TextStyle(
                            color: Color(0xFF1D1B45),
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
                          height: 46,
                          width: 290,
                          child: TextFormField(
                            controller: emailController,
                            style: TextStyle(
                                color: Color(
                                    0xff313A56)), // Establece el color del texto.
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                width: 10,
                                color: Color(0xFF1D1B45),
                              )), // Elimina el borde del TextFormField
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 0),
                    Container(
                      width: 300,
                      height: 75,
                      child: Padding(
                        padding: EdgeInsets.only(top: 30.0, right: 12),
                        child: ElevatedButton(
                          onPressed: () async {
                            Map<String, dynamic>? data = await addBusiness(
                                titleController.text,
                                typeController.text,
                                numberController.text,
                                emailController.text,
                                titleController.text,
                                widget.emprendedor_id?["EmprendedorId"]);
                            Navigator.push(
                              context,
                              PageTransition(
                                type: PageTransitionType.fade,
                                child: RegistroEm2(
                                  data: data,
                                ),
                              ),
                            );
                          },
                          child: Text(
                            "Registrarse",
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Noto Sans'),
                          ),
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                                Color(0xff313A56)),
                            foregroundColor: MaterialStateProperty.all<Color>(
                                Color.fromARGB(255, 255, 255, 255)),
                            minimumSize:
                                MaterialStateProperty.all<Size>(Size(200, 50)),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

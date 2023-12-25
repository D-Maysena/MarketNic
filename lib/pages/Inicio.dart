import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart'; // Importa flutter_svg
import 'package:get/get.dart';
import 'package:tienda_login/pages/AgregarProductos1.dart';
import 'package:tienda_login/pages/Estadisticas2.dart';
import 'package:page_transition/page_transition.dart';
import 'package:tienda_login/pages/Inicio.dart';
import 'package:tienda_login/pages/Tareas.dart';
import 'package:tienda_login/pages/Inventario1.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';
import 'package:tienda_login/pages/Perfil.dart';

class Inicio extends StatelessWidget {
  final Map<String, dynamic>? data;

  Inicio({Key? key, this.data}) : super(key: key);

  final FirebaseFirestore db = FirebaseFirestore.instance;

  Future<String> nombreTienda() async {
    //Hacemos una consulta, filtrando, eso nos devuelve varios resultados
    QuerySnapshot docRef = await db
        .collection("Emprendimiento")
        .where("EmprendedorId", isEqualTo: data?["EmprendedorId"])
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
        .where("EmprendedorId", isEqualTo: data?["EmprendedorId"])
        .get();

    print(data?["EmprendedorId"]);

    if (docRef.docs.isNotEmpty) {
      //Accedemos al primer elemento de la consulta, luego accedemos a su campo "Titulo"
      String titulo = docRef.docs[0]["Correo"];
      return titulo;
    } else {
      return "";
    }
  }

  Future<bool> _onPop(BuildContext context) async {
    return (await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: new Text('¿Estás seguro?'),
            content: new Text('¿Deseas salir de la aplicación?'),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: new Text('No'),
              ),
              TextButton(
                onPressed: () => exit(0),
                child: new Text('Sí'),
              ),
            ],
          ),
        )) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    final query = MediaQuery.of(context);

    // Lista de todas las rutas
    final List<Widget> screens = [Inventario1(), Tareas(), AgregarProductos1()];

    return WillPopScope(
      onWillPop: () => _onPop(context),
      child: MediaQuery(
        data: query.copyWith(textScaleFactor: 1.0),
        child: Scaffold(
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(60.0),
            child: AppBar(
              automaticallyImplyLeading: false, // Oculta el botón de retroceso
              iconTheme:
                  IconThemeData(color: const Color.fromARGB(255, 32, 32, 32)),
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
                  padding: EdgeInsets.only(left: 0.0),
                  child: IconButton(
                    onPressed: () {
                      // Acción a realizar cuando se presiona el segundo IconButton
                      Navigator.push(
                        context,
                        PageTransition(
                          type: PageTransitionType.fade,
                          child: screens[0],
                        ),
                      );
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
                  padding: EdgeInsets.symmetric(
                      horizontal: 30.0), // Ajusté los márgenes horizontalmente
                  child: Divider(
                    height: 1,
                    color: Colors.black, // Cambié el color a azul
                    thickness: 3, // Hice la línea más gruesa
                  ),
                ),
              ),
            ),
          ),
          body: Column(children: [
            SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              scrollDirection: Axis.vertical,
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.only(right: 116, top: 0),
                    child: Text(
                      "Bienvenido a  la pantalla principal",
                      style: TextStyle(
                          fontFamily: 'Noto Sans', color: Color(0xff2B9E52)),
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          width: 100,
                          height: 170,
                          margin: EdgeInsets.fromLTRB(0, 16, 10, 0),
                          child: ElevatedButton(
                            onPressed: () => {
                              // Agrega aquí la acción que te regrese a la pestaña anterior
                              Navigator.push(
                                  context,
                                  PageTransition(
                                    type: PageTransitionType.fade,
                                    child: Inventario1(emprendedor_Id: data),
                                  ))
                            },
                            style: ElevatedButton.styleFrom(
                              primary: Color.fromARGB(255, 255, 255, 255),
                              side: BorderSide(
                                width: 2,
                                color: Color(0xFFFFFFFF),
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 20),
                              shadowColor: Color(0xFFF8F8F8),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  width: 50,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color:
                                        Color(0xff313A56), // Color del círculo
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons
                                        .shopping_bag_outlined, // Icono deseado
                                    color: Colors.white, // Color del icono
                                    size: 25, // Tamaño del icono
                                  ),
                                ),
                                SizedBox(height: 5),
                                Text(
                                  'Inventario',
                                  style: TextStyle(
                                    color: Color(0xFF1D1B45),
                                    fontFamily: 'Noto Sans',
                                    fontSize: 11,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          width: 180,
                          height: 170,
                          margin: EdgeInsets.fromLTRB(0, 16, 10, 0),
                          child: ElevatedButton(
                            onPressed: () => {},
                            style: ElevatedButton.styleFrom(
                              primary: Color.fromARGB(255, 255, 255, 255),
                              side: BorderSide(
                                width: 2,
                                color: Colors.white,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 20),
                              shadowColor: Color(0xFFF8F8F8),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  width: 50,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color:
                                        Color(0xff313A56), // Color del círculo
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.add_circle_outline, // Icono deseado
                                    color: Colors.white, // Color del icono
                                    size: 25, // Tamaño del icono
                                  ),
                                ),
                                SizedBox(height: 5),
                                Text(
                                  'Mis tareas',
                                  style: TextStyle(
                                    color: Color(0xFF1D1B45),
                                    fontFamily: 'Noto Sans',
                                    fontSize: 11,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          width: 180,
                          height: 170,
                          margin: EdgeInsets.fromLTRB(0, 16, 10, 0),
                          child: ElevatedButton(
                            onPressed: () => {},
                            style: ElevatedButton.styleFrom(
                              primary: Color.fromARGB(255, 255, 255, 255),
                              side: BorderSide(
                                width: 2,
                                color: Colors.white,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 20),
                              shadowColor: Color(0xFFF8F8F8),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  width: 50,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color:
                                        Color(0xff313A56), // Color del círculo
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.person_2_outlined, // Icono deseado
                                    color: Colors.white, // Color del icono
                                    size: 25, // Tamaño del icono
                                  ),
                                ),
                                SizedBox(height: 5),
                                Text(
                                  'Colaboradores',
                                  style: TextStyle(
                                    color: Color(0xFF1D1B45),
                                    fontFamily: 'Noto Sans',
                                    fontSize: 11,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          width: 180,
                          height: 170,
                          margin: EdgeInsets.fromLTRB(0, 16, 10, 0),
                          child: ElevatedButton(
                            onPressed: () => {},
                            style: ElevatedButton.styleFrom(
                              primary: Color.fromARGB(255, 255, 255, 255),
                              side: BorderSide(
                                width: 2,
                                color: Colors.white,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 20),
                              shadowColor: Color(0xFFF8F8F8),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  width: 50,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color:
                                        Color(0xff313A56), // Color del círculo
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons
                                        .stacked_line_chart_sharp, // Icono deseado
                                    color: Colors.white, // Color del icono
                                    size: 25, // Tamaño del icono
                                  ),
                                ),
                                SizedBox(height: 5),
                                Text(
                                  'Estadisticas',
                                  style: TextStyle(
                                    color: Color(0xFF1D1B45),
                                    fontFamily: 'Noto Sans',
                                    fontSize: 11,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          width: 147,
                          height: 166,
                          margin: EdgeInsets.fromLTRB(0, 16, 10, 0),
                          child: ElevatedButton(
                            onPressed: () => {},
                            style: ElevatedButton.styleFrom(
                              primary: Color.fromARGB(255, 255, 255, 255),
                              side: BorderSide(
                                width: 2,
                                color: Colors.white,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 20),
                              shadowColor: Color(0xFFF8F8F8),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  width: 50,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color:
                                        Color(0xff313A56), // Color del círculo
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.newspaper_outlined, // Icono deseado
                                    color: Colors.white, // Color del icono
                                    size: 30, // Tamaño del icono
                                  ),
                                ),
                                SizedBox(height: 5),
                                Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(left: 0.0),
                                      child: Container(
                                        width: 90,
                                        child: Text(
                                          'Catálogo de emprendedores',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: Color(0xFF1D1B45),
                                            fontFamily: 'Noto Sans',
                                            fontSize: 11,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ]),
          bottomNavigationBar: BottomNavigationBar(
              unselectedItemColor: Colors.grey,
              selectedItemColor:
                  Color(0xFF1D1B45), // Color para los íconos no seleccionados
              iconSize: 40,
              currentIndex: 0, // Índice inicial
              onTap: (index) {
                // Cambia la pantalla según el índice seleccionado
                //El index pasado a este método indica qué ícono se tocó. Luego, se utiliza este index para seleccionar la pantalla correspondiente de la lista screens y mostrarla en el área de contenido principal de la aplicación.
                //Por ejemplo, si el usuario toca el segundo ícono en el BottomNavigationBar, el
                //index será 1 y se cambiara a la ruta que esta en la posicion 1 de mi screens

                if (index == 2) {
                  Navigator.push(
                    context,
                    PageTransition(
                      type: PageTransitionType
                          .fade, // Cambia el tipo de transición según tu preferencia
                      child: Tareas(data: data),
                    ),
                  );
                } else if (index == 1) {
                  Navigator.push(
                    context,
                    PageTransition(
                      type: PageTransitionType
                          .fade, // Cambia el tipo de transición según tu preferencia
                      child: Inventario1(emprendedor_Id: data),
                    ),
                  );
                } else if (index == 3) {
                  Navigator.push(
                    context,
                    PageTransition(
                      type: PageTransitionType
                          .fade, // Cambia el tipo de transición según tu preferencia
                      child: Perfil(data: data),
                    ),
                  );
                }
              },
              items: [
                BottomNavigationBarItem(
                  icon: Icon(Icons.home),

                  label:
                      'Inicio', // Coloca la etiqueta aquí en el mismo nivel que el icono
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
                  icon: Icon(
                    Icons.account_circle_outlined,
                  ),
                  label: 'Perfil',
                ),
              ],
              showUnselectedLabels: true),
        ),
      ),
    );
  }
}

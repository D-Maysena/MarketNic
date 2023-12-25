import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart'; // Importa flutter_svg
import 'package:get/get.dart';
import 'package:tienda_login/pages/Estadisticas2.dart';
import 'package:page_transition/page_transition.dart';
import 'package:tienda_login/pages/Inicio.dart';
import 'package:tienda_login/pages/Tareas.dart';

class miCuenta extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final query = MediaQuery.of(context);

//Lista de todas las rutas
    final List<Widget> screens = [
      Inicio(),
      Estadisticas(),
      Tareas(),
    ];

    return MaterialApp(
        home: MediaQuery(
      data: query.copyWith(textScaleFactor: 1.0),
      child: Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          backgroundColor: Colors.white,
          title: Text(
            "Mi cuenta",
            style: TextStyle(
              fontFamily: 'Bebas Neue',
              color: Color(0xFF1D1B45),
              fontSize: 38,
            ),
          ),
          actions: [
            Container(
              margin: EdgeInsets.fromLTRB(0, 0, 30, 0),
              padding: EdgeInsets.only(bottom: 20.0),
              child: IconButton(
                onPressed: () {
                  // Acción a realizar cuando se presiona el segundo IconButton
                },
                icon: Icon(
                  Icons.notifications_none,
                  size: 46,
                ),
                color: Color(0xFF1D1B45),
              ),
            ),
          ],
        ),
        body: Center(
          child: Column(
            children: [
              SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  children: [
                    //SizedBox(height: 0),
                    Row(
                      children: [
                        SizedBox(width: 45),
                        Container(
                          decoration: BoxDecoration(
                              shape: BoxShape.circle, color: Colors.grey),
                          width: 50,
                          height: 80,
                        ),
                        SizedBox(width: 10),
                        Container(
                          padding: EdgeInsets.only(
                              left:
                                  10), // Ajusta el padding izquierdo del texto
                          child: Text(
                            "Nombre del empleado",
                            style: TextStyle(
                                fontFamily: 'Noto Sans', fontSize: 20),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      width: 350,
                      height: 500,
                      margin: EdgeInsets.fromLTRB(0, 16, 10, 0),
                      child: ElevatedButton(
                        onPressed: () => {
                          // Acción a realizar cuando se presione el botón
                        },
                        style: ElevatedButton.styleFrom(
                          primary: Color(0xFFEBEBEB),
                          side: BorderSide(
                            width: 2,
                            color: Colors.white,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          padding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          shadowColor: Colors.transparent,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircleAvatar(
                              radius: 50,
                              // backgroundImage:
                              //  AssetImage('assets/generic_profile.jpg'),
                            ), // Agregar un CircleAvatar como icono de foto de perfil
                            SizedBox(
                                height:
                                    10), // Espacio entre el icono y el texto
                            Text(
                              "Presiona aquí",
                              style: TextStyle(fontSize: 18),
                            ), // Añadir texto al botón
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          unselectedItemColor:
              Colors.grey, // Color para los íconos no seleccionados
          iconSize: 46,
          currentIndex: 0, // Índice inicial
          onTap: (index) {
            // Cambia la pantalla según el índice seleccionado
            //El index pasado a este método indica qué ícono se tocó. Luego, se utiliza este index para seleccionar la pantalla correspondiente de la lista screens y mostrarla en el área de contenido principal de la aplicación.
            //Por ejemplo, si el usuario toca el segundo ícono en el BottomNavigationBar, el
            //index será 1 y se cambiara a la ruta que esta en la posicion 1 de mi screens
            if (index == 1 || index == 0) {
              // Cambia la pantalla solo si el índice es 1
              Navigator.push(
                context,
                PageTransition(
                  type: PageTransitionType
                      .fade, // Cambia el tipo de transición según tu preferencia
                  child: screens[index],
                ),
              );
            } else if (index == 3) {
              Navigator.push(
                context,
                PageTransition(
                  type: PageTransitionType
                      .fade, // Cambia el tipo de transición según tu preferencia
                  child: screens[2],
                ),
              );
            }
          },
          items: [
            BottomNavigationBarItem(
              icon: Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Icon(Icons.home_filled, color: Colors.grey),
              ),
              label: ' ',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.leaderboard),
              label: ' ',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.inventory),
              label: 'Favoritos',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.list),
              label: 'Carrito',
            ),
            BottomNavigationBarItem(
              icon:
                  Icon(Icons.account_circle_outlined, color: Color(0xFF1D1B45)),
              label: 'Perfil',
            ),
          ],
        ),
      ),
    ));
  }
}

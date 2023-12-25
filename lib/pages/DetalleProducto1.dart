import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:tienda_login/pages/Estadisticas2.dart';
import 'package:page_transition/page_transition.dart';
import 'package:tienda_login/pages/Inicio.dart';
import 'package:tienda_login/pages/Tareas.dart';
import 'package:tienda_login/pages/AgregarProductos1.dart';

class DetalleProducto1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final query = MediaQuery.of(context);

    // Lista de todas las rutas
    final List<Widget> screens = [
      Inicio(),
      Estadisticas(),
      Tareas(),
    ];

    // Controlador para el TextField
    final TextEditingController cantidadController = TextEditingController();

    return MediaQuery(
      data: query.copyWith(textScaleFactor: 1.0),
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(60.0),
          child: AppBar(
            iconTheme: IconThemeData(color: Colors.black),
            backgroundColor: Color.fromARGB(255, 255, 255, 255),
            elevation: 0.0,
            title: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Luna Store",
                  style: TextStyle(
                    fontFamily: 'Bebas Neue',
                    color: Color(0xFF1D1B45),
                    fontSize: 25,
                  ),
                ),
                Text(
                  "correo@example.com",
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.black,
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
        body: ListView(
children: [
            Row(
              children: [
                Container(
                  margin: EdgeInsets.all(20.0),
                  width: 360,
                  height: 200,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(
                          'https://cdn2.actitudfem.com/660x625/filters:format(webp):quality(75)/media/files/images/2021/08/tipos-de-anillos-y-su-significado.jpg'),
                      fit: BoxFit.cover,
                    ),
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                ),
              ],
            ),
                        SizedBox(height: 10),
                        Row(
  mainAxisAlignment: MainAxisAlignment.spaceBetween,
  children: [
    Row(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
          child: Text(
            "Nombre del producto",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1D1B45),
            ),
          ),
        ),
        // Puedes agregar más propiedades al Text si es necesario
      ],
    ),
    Text(
      'Codigo', // Asegúrate de reemplazar 'Precio' con la variable o valor real del precio
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: Color(0xFF1D1B45),
      ),
    ),
  ],
),

Container(
  padding: EdgeInsets.all(20),
  margin: EdgeInsets.all(20),
  decoration: BoxDecoration(
    border: Border.all(color: Colors.grey),
    borderRadius: BorderRadius.circular(15),
  ),
  child: Column(
    children: [
      SizedBox(height: 20),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Precio de Compra',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1D1B45),
            ),
          ),
          Text('PRECIO'),
        ],
      ),
      SizedBox(height: 10),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Precio de Venta',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Color(0xFF1D1B45),
              fontSize: 20,
            ),
          ),
          Text('PRECIOV'),
        ],
      ),
      SizedBox(height: 10),
      Text(
        'Cantidad disponible',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Color(0xFF1D1B45),
          fontSize: 20,
        ),
      ),
      Container(
        padding: EdgeInsets.only(top: 10),
        child: TextField(
          controller: cantidadController,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            isDense: true,
          ),
        ),
      ),
      SizedBox(height: 20),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: () {
              // Acción a realizar al presionar el botón
            },
            child: Text('Actualizar Cantidad'),
          ),
        ],
      ),
      SizedBox(height: 20),
      Text(
        'Descripción del producto',
        style: TextStyle(
          color: Color(0xFF1D1B45),
        ),
      ),
    ],
  ),
),


],

        ),
        bottomNavigationBar: BottomNavigationBar(
          unselectedItemColor: Colors.grey,
          iconSize: 46,
          currentIndex: 0,
          onTap: (index) {
            if (index == 1 || index == 0) {
              Navigator.push(
                context,
                PageTransition(
                  type: PageTransitionType.fade,
                  child: screens[index],
                ),
              );
            } else if (index == 3) {
              Navigator.push(
                context,
                PageTransition(
                  type: PageTransitionType.fade,
                  child: screens[2],
                ),
              );
            } else if (index == 4) {
              Navigator.push(
                context,
                PageTransition(
                  type: PageTransitionType.fade,
                  child: screens[2],
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
              icon: Icon(Icons.account_circle_outlined, color: Color(0xFF1D1B45)),
              label: 'Perfil',
            ),
          ],
        ),
      ),
    );
  }
}

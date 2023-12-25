import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tienda_login/pages/AgregarProductos1.dart';
import 'package:tienda_login/pages/Estadisticas2.dart';
import 'package:tienda_login/pages/Inicio.dart';
import 'package:tienda_login/pages/Perfil.dart';
import 'package:tienda_login/pages/Tareas.dart';
import 'package:page_transition/page_transition.dart';

class Product {
  String codigo;
  String nombre;
  String cantidad;
  String precio;
  String descripcion;
  String imageUrl;

  Product(this.codigo, this.nombre, this.cantidad, this.precio,
      this.descripcion, this.imageUrl);
}

class Inventario1 extends StatelessWidget {
  final Map<String, dynamic>? emprendedor_Id;

  Inventario1({Key? key, this.emprendedor_Id}) : super(key: key);
  FirebaseFirestore db = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    final FirebaseFirestore db = FirebaseFirestore.instance;
    Future<String> nombreTienda() async {
      //Hacemos una consulta, filtrando, eso nos devuelve varios resultados
      QuerySnapshot docRef = await db
          .collection("Emprendimiento")
          .where("EmprendedorId", isEqualTo: emprendedor_Id?["EmprendedorId"])
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
          .where("EmprendedorId", isEqualTo: emprendedor_Id?["EmprendedorId"])
          .get();

      if (docRef.docs.isNotEmpty) {
        //Accedemos al primer elemento de la consulta, luego accedemos a su campo "Titulo"
        String titulo = docRef.docs[0]["Correo"];
        return titulo;
      } else {
        return "";
      }
    }

    final query = MediaQuery.of(context);
    Future<List<Product>> getProducts() async {
      List<Product> products = [];

      QuerySnapshot emprendimientoSnapshot = await db
          .collection("Emprendimiento")
          .where("EmprendedorId", isEqualTo: emprendedor_Id?["EmprendedorId"])
          .get();

      if (emprendimientoSnapshot.docs.isNotEmpty) {
        String emprendimientoId = emprendimientoSnapshot.docs[0].id;

        QuerySnapshot productSnapshot = await db
            .collection("Productos")
            .where("EmprendimientoId", isEqualTo: emprendimientoId)
            .get();

        productSnapshot.docs.forEach((doc)
         {
          products.add(Product(
            doc["Codigo"],
            doc["Nombre"],
            doc["Cantidad"],
            doc["Precio"],
            doc["Descripcion"],
            doc["ProductoUrl"],
          ));
        });
      }

      return products;
    }

    final List<Widget> screens = [Inicio(), Tareas(), AgregarProductos1()];

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
                Column(
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
              ],
            ),
            actions: [
              Container(
                margin: EdgeInsets.fromLTRB(0, 0, 30, 0),
                padding: EdgeInsets.only(left: 20.0),
                child: IconButton(
                  onPressed: () {
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
                  horizontal: 30.0,
                ),
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
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 20, left: 20),
                    child: Text(
                      'Productos',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1D1B45),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        PageTransition(
                          type: PageTransitionType.fade,
                          child: AgregarProductos1(data: emprendedor_Id),
                        ),
                      );
                    },
                    child: Container(
                      margin: EdgeInsets.only(top: 20, right: 20),
                      child: Text(
                        'Añadir Productos',
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xFF1D1B45),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(
                  right: 25.0,
                ),
                child: Container(
                  width: 480,
                  height: 600,
                  child: FutureBuilder<List<Product>>(
                    future: getProducts(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Error fetching data'));
                      } else if (snapshot.data == null ||
                          snapshot.data!.isEmpty) {
                        return Padding(
                          padding: const EdgeInsets.only(left: 10.0),
                          child: Center(child: Text('Sin registros')),
                        );
                      } else {
                        return ListView.builder(
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) {
                            Product product = snapshot.data![index];
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                width: double.infinity,
                                height: 200,
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Color.fromARGB(0, 228, 175, 175)),
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 130,
                                      height: 220,
                                      child: ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(9.0),
                                        child: Image.network(
                                          product.imageUrl,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 10),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          product.nombre,
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: 'Noto Sans'),
                                        ),
                                        SizedBox(height: 5),
                                        Text(
                                          'Disponibles: ${product.cantidad}',
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.grey,
                                              fontFamily: 'Noto Sans'),
                                        ),
                                        SizedBox(height: 5),
                                        Text(
                                          '\$${product.precio}',
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontFamily: 'Noto Sans'),
                                        ),
                                        SizedBox(height: 5),
                                        Container(
                                          width: 110,
                                          height: 80,
                                          child: Text(
                                            product.descripcion,
                                            style: TextStyle(
                                                fontSize: 12,
                                                fontFamily: 'Noto Sans'),
                                            maxLines: 5,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      }
                    },
                  ),
                ),
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
            if (index == 0) {
              Navigator.push(
                context,
                PageTransition(
                  type: PageTransitionType.fade,
                  child: Inicio(data: emprendedor_Id),
                ),
              );
            } else if (index == 2) {
              Navigator.push(
                context,
                PageTransition(
                  type: PageTransitionType.fade,
                  child: Tareas(data: emprendedor_Id),
                ),
              );
            } else if (index == 3) {
              Navigator.push(
                context,
                PageTransition(
                  type: PageTransitionType.fade,
                  child: Perfil(data: emprendedor_Id),
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
              label: 'Inicio',
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
              icon: Icon(Icons.account_circle_outlined),
              label: 'Perfil',
            ),
          ],
          showUnselectedLabels: true,
        ),
      ),
    );
  }
}

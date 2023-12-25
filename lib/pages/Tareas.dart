import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:tienda_login/pages/AgregarProductos1.dart';
import 'package:tienda_login/pages/AnadirTarea.dart';
import 'package:tienda_login/pages/Estadisticas2.dart';
import 'package:page_transition/page_transition.dart';
import 'package:tienda_login/pages/Inicio.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:tienda_login/pages/Inventario1.dart';
import 'package:tienda_login/pages/Perfil.dart';

class Tareas extends StatefulWidget {
  final Map<String, dynamic>? data;
  Tareas({Key? key, this.data}) : super(key: key);
  @override
  _TareasState createState() => _TareasState();
}

class _TareasState extends State<Tareas> {
  String? filtroSeleccionado; // Variable para almacenar el filtro seleccionado
  List<String> filtros = [
    "En proceso",
    "Pendiente",
    "Cerradas",
    "Ninguna"
  ]; // Opciones de filtro
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

  final FirebaseFirestore db = FirebaseFirestore.instance;
  Future<String> nombreTienda() async {
    //Hacemos una consulta, filtrando, eso nos devuelve varios resultados
    QuerySnapshot docRef = await db
        .collection("Emprendimiento")
        .where("EmprendedorId", isEqualTo: widget.data?["EmprendedorId"])
        .get();

    print(widget.data);
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

  String _selectedDate = '';
  TextEditingController _eventController = TextEditingController();
  bool _isVisible = false;

  @override
  void initState() {
    super.initState();
  }

  Widget build(BuildContext context) {
    final query = MediaQuery.of(context);

    // Inicializa el idioma español para el calendario
    const Locale('es', 'ES');

    //Lista de todas las rutas
    final List<Widget> screens = [Inicio(), Inventario1()];

    return MediaQuery(
      data: query.copyWith(textScaleFactor: 1.0),
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(60.0),
          child: AppBar(
            automaticallyImplyLeading: false,
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
        body: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start, // Alinea los widgets a la izquierda
          children: <Widget>[
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    left: 30.0,
                  ),
                ),
                Container(
                  width: 152,
                  child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          PageTransition(
                            type: PageTransitionType.fade,
                            child: AnadirTarea(data: widget.data),
                          ),
                        );
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.add_circle_outline,
                              color: Color(0xff313A56), size: 19),
                          SizedBox(width: 5),
                          Text("Añadir tareas",
                              style: TextStyle(
                                  color: Color(0xff313A56),
                                  fontFamily: 'Noto Sans',
                                  fontSize: 14))
                        ],
                      ),
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            Color.fromARGB(255, 255, 255, 255)),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                      )),
                ),
                SizedBox(width: 35),
                Container(
                  width: 159,
                  child: ElevatedButton(
                      onPressed: () {},
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.perm_identity,
                            color: Color(0xff313A56),
                            size: 19,
                          ),
                          SizedBox(width: 5),
                          Text("Colaboradores",
                              style: TextStyle(
                                  color: Color(0xff313A56),
                                  fontFamily: 'Noto Sans',
                                  fontSize: 14))
                        ],
                      ),
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            Color.fromARGB(255, 255, 255, 255)),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                      )),
                )
              ],
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.only(left: 30.0),
              child: Row(
                children: [
                  Text("Mis tareas",
                      style: TextStyle(
                          fontFamily: 'Noto Sans',
                          fontSize: 22,
                          color: Color(0xff313A56))),
                  SizedBox(width: 100),
                  DropdownButton<String>(
                    hint: Text(
                      "Filtrar por",
                      style: TextStyle(
                        fontFamily: 'Noto Sans',
                        fontSize: 18,
                        color: Color(0xff313A56),
                      ),
                    ),
                    value: filtroSeleccionado,
                    onChanged: (String? newValue) {
                      setState(() {
                        filtroSeleccionado = newValue;
                        // Aquí puedes realizar alguna acción cuando se selecciona un filtro
                      });
                    },
                    items:
                        filtros.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
            FutureBuilder<String>(
              future: EmprendimientoId(),
              builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else if (snapshot.hasData) {
                  String emprendimientoId = snapshot.data!;
                  return Expanded(
                    child: StreamBuilder<QuerySnapshot>(
                      stream: db
                          .collection('Tareas')
                          .where('EmprendimientoId',
                              isEqualTo: emprendimientoId)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        } else if (!snapshot.hasData ||
                            snapshot.data!.docs.isEmpty) {
                          return Text('No hay tareas disponibles.');
                        } else {
                          List<Map<String, dynamic>> tareas = [];
                          snapshot.data!.docs.forEach((doc) {
                            tareas.add(doc.data() as Map<String, dynamic>);
                          });
                          return Container(
                              margin: EdgeInsets.only(left: 22, top: 20),
                              child: ListaTareas(tareas: tareas));
                        }
                      },
                    ),
                  );
                } else {
                  return Text('Ha ocurrido un error.');
                }
              },
            )
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          unselectedItemColor: Colors.grey,
          selectedItemColor:
              Color(0xFF1D1B45), // Color para los íconos no seleccionados
          iconSize: 40,
          currentIndex: 0, // Índice inicial
          onTap: (index) {
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
            } else if (index == 3) {
              Navigator.push(
                context,
                PageTransition(
                  type: PageTransitionType.fade,
                  child: Perfil(data: widget.data),
                ),
              );
            }
          },
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home, color: Colors.grey),
              label:
                  'Inicio', // Coloca la etiqueta aquí en el mismo nivel que el icono
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.add_circle_outline),
              label: ' Productos',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.list_outlined, color: Color(0xFF1D1B45)),
              label: 'Tareas',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.account_circle_outlined,
              ),
              label: 'Perfil',
            ),
          ],
          showUnselectedLabels: true,
        ),
      ),
    );
  }

  _showEventDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Añadir Evento'),
        content: TextField(
          controller: _eventController,
          decoration: InputDecoration(hintText: 'Ingrese el evento'),
        ),
        actions: <Widget>[
          TextButton(
            child: Text('Añadir'),
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}

class ListaTareas extends StatefulWidget {
  final List<Map<String, dynamic>> tareas;

  ListaTareas({required this.tareas});

  @override
  _ListaTareasState createState() => _ListaTareasState();
}

class _ListaTareasState extends State<ListaTareas> {
  List<String?> estadosSeleccionados = List.generate(
      10, (index) => null); // Ajusta el tamaño de acuerdo a tus necesidades

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.tareas.length,
      itemBuilder: (context, index) {
        String nombreTarea = widget.tareas[index]['Nombre Tarea'];

        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    nombreTarea,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(right: 20),
                    child: ElevatedButton(
                      onPressed: () {
                        // Acción a realizar cuando se presiona el botón
                      },
                      child: DropdownButton<String>(
                        value: estadosSeleccionados[index],
                        hint: Text(
                          "Estado",
                          style: TextStyle(
                            fontSize: 14,
                          ),
                        ),
                        onChanged: (String? newValue) {
                          setState(() {
                            estadosSeleccionados[index] = newValue;
                            if (newValue == "En proceso") {
                              // Acción específica para "En proceso"
                              print("Tarea en proceso");
                            } else if (newValue == "Pendiente") {
                              // Acción específica para "Pendiente"
                              print("Tarea pendiente");
                            }
                          });
                        },
                        items: [
                          DropdownMenuItem<String>(
                            value: "En proceso",
                            child: Text(
                              "En proceso",
                              style: TextStyle(fontFamily: 'Noto Sans'),
                            ),
                          ),
                          DropdownMenuItem<String>(
                            value: "Pendiente",
                            child: Text(
                              "Pendiente",
                              style: TextStyle(
                                  color: Colors.black, fontFamily: 'Noto Sans'),
                            ),
                          ),
                          DropdownMenuItem<String>(
                            value: "Cerradas",
                            child: Text(
                              "Cerradas",
                              style: TextStyle(
                                  color: Colors.black, fontFamily: 'Noto Sans'),
                            ),
                          ),
                        ],
                      ),
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                          estadosSeleccionados[index] == "En proceso"
                              ? Color(0xffFCF7DD)
                              : estadosSeleccionados[index] == "Pendiente"
                                  ? Color(0xffFCDDDD)
                                  : estadosSeleccionados[index] == "Cerradas"
                                      ? Color(0xffB5F8CC)
                                      : const Color.fromARGB(255, 255, 255,
                                          255), // Color por defecto
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Divider(),
            ],
          ),
        );
      },
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:tienda_login/pages/AgregarProductos1.dart';
import 'package:tienda_login/pages/Estadisticas2.dart';
import 'package:page_transition/page_transition.dart';
import 'package:tienda_login/pages/Inicio.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:tienda_login/pages/Inventario1.dart';
import 'package:flutter/cupertino.dart';
import 'package:tienda_login/pages/Tareas.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class AnadirTarea extends StatefulWidget {
  final Map<String, dynamic>? data;

  AnadirTarea({Key? key, this.data}) : super(key: key);
  @override
  _AnadirTareasState createState() => _AnadirTareasState();
}

class _AnadirTareasState extends State<AnadirTarea> {
  String?
      EncargadoSeleccionado; // Variable para almacenar el encargado seleccionado
  List<String> filtros = [
    "Admin",
    "Susana",
    "Horia",
    "Yasser"
  ]; // Opciones de encargado
  List<Appointment> _appointments = [];

  final FirebaseFirestore db = FirebaseFirestore.instance;
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

  Future<DateTime> _selectDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null) {
      String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
      dateController.text = formattedDate;
      print("Fecha");
      print(formattedDate);

      // Analizar la cadena de fecha formateada a un objeto DateTime
      DateTime parsedDate = DateTime.parse(formattedDate);
      return parsedDate;
    } else {
      print("Selección de fecha cancelada");
      // Puedes devolver null o alguna otra indicación de que la fecha no fue seleccionada
      return DateTime.now(); // O puedes devolver un valor por defecto
    }
  }

//Buscar apl emprendimienton segun el emprendedor
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

  //Agregar tarea
  Future<void> addTask(String nombreTarea, String descripcion, DateTime? fecha,
      String? encargado) async {
    String emprendimientoId = await EmprendimientoId();
    DateTime fechaLocal = fecha!.toLocal();
    Map<String, dynamic> data = {
      "EmprendimientoId": emprendimientoId,
      "Nombre Tarea": nombreTarea,
      "Descripcion": descripcion,
      "Fecha de entrega": fechaLocal,
      "Encargado": encargado,
    };
    await db.collection("Tareas").add(data);
    print("Enviado");
  }

  String _selectedDate = '';
  TextEditingController _eventController = TextEditingController();
  bool _isVisible = false;

  TextEditingController dateController = TextEditingController();
  //Controladores principales
  TextEditingController nameController = TextEditingController();
  TextEditingController DescripController = TextEditingController();
  TextEditingController DateController = TextEditingController();
  TextEditingController EncargadoController = TextEditingController();

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
                      Container(
                        //padding: EdgeInsets.only(left: 17),
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
                    ])
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
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start, // Alinea los widgets a la izquierda
            children: <Widget>[
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 10.0, top: 100),
                  ),
                  Column(
                    children: [
                      Container(
                        margin: EdgeInsets.only(top: 30),
                        child: Center(
                          child: Text("Añadir tareas",
                              style: TextStyle(
                                  fontFamily: 'Noto Sans',
                                  fontSize: 25,
                                  color: Color(0xff313A56))),
                        ),
                      ),
                      SizedBox(height: 20),
                      Center(
                        child: Container(
                          margin: EdgeInsets.only(right: 50),
                          child: Text(
                            "Nombre de la tarea",
                            style: TextStyle(
                              fontFamily: 'Noto Sans',
                              fontSize: 18,
                              color: Color(0xff313A56),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      Container(
                        width: 350, // ajusta el ancho según tus necesidades
                        child: Container(
                          margin: EdgeInsets.only(
                            left: 30,
                          ),
                          child: Column(
                            children: [
                              Container(
                                child: TextField(
                                  controller: nameController,
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.symmetric(
                                        vertical: 15.0, horizontal: 18.0),
                                    hintText: 'Ingrese el nombre de la tarea',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(15.0),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      Container(
                        margin: EdgeInsets.only(right: 25),
                        child: Text(
                          "Descripción de la tarea",
                          style: TextStyle(
                            fontFamily: 'Noto Sans',
                            fontSize: 18,
                            color: Color(0xff313A56),
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      Container(
                        width: 350, // ajusta el ancho según tus necesidades
                        child: Container(
                          margin: EdgeInsets.only(left: 30),
                          child: TextField(
                            controller: DescripController,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 15.0, horizontal: 18.0),
                              hintText: 'Ingrese una descripción',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      Container(
                        margin: EdgeInsets.only(right: 80),
                        child: Text(
                          "Fecha de entrega",
                          style: TextStyle(
                            fontFamily: 'Noto Sans',
                            fontSize: 18,
                            color: Color(0xff313A56),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        width: 328,
                        margin: EdgeInsets.only(left: 30),
                        child: DateTimeField(
                          controller: dateController,
                          format: DateFormat('yyyy-MM-dd HH:mm'),
                          decoration: InputDecoration(
                            hintText: 'Seleccione la fecha y hora',
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 15.0, horizontal: 20.0),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            prefixIcon: Icon(Icons.calendar_today,
                                color: Color(0xff313A56)),
                          ),
                          onShowPicker: (context, currentValue) async {
                            DateTime? date = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime.now(),
                              lastDate: DateTime(2101),
                            );

                            if (date != null) {
                              TimeOfDay? time = await showTimePicker(
                                context: context,
                                initialTime: TimeOfDay.now(),
                              );

                              if (time != null) {
                                date = DateTime(
                                  date.year,
                                  date.month,
                                  date.day,
                                  time.hour,
                                  time.minute,
                                );
                              }
                            }

                            return date;
                          },
                          onChanged: (selectedDate) {
                            // Puedes realizar alguna acción cuando cambia la fecha y hora
                            print("Fecha y hora seleccionadas: $selectedDate");
                            print(dateController);
                          },
                        ),
                      ),
                      SizedBox(height: 20),
                      Container(
                        margin: EdgeInsets.only(right: 25),
                        child: Text(
                          "Nombre del encargado",
                          style: TextStyle(
                            fontFamily: 'Noto Sans',
                            fontSize: 18,
                            color: Color(0xff313A56),
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      Container(
                        width: 350,
                        child: Container(
                          margin: EdgeInsets.only(left: 30),
                          child: DropdownButtonFormField<String>(
                            value: EncargadoSeleccionado,
                            hint: Text('Seleccione el encargado'),
                            onChanged: (String? newValue) {
                              setState(() {
                                EncargadoSeleccionado = newValue;
                              });
                            },
                            items: filtros
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 15.0, horizontal: 18.0),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 50),
                      Container(
                        child: Container(
                          margin: EdgeInsets.only(left: 19),
                          height: 60,
                          width: 303,
                          child: ElevatedButton(
                              onPressed: () async {
                                if (nameController.text.isNotEmpty &&
                                    DescripController.text.isNotEmpty &&
                                    dateController.text.isNotEmpty &&
                                    EncargadoSeleccionado != null) {
                                  DateTime? selectedDateTime =
                                      dateController.text.isNotEmpty
                                          ? DateFormat('yyyy-MM-dd HH:mm')
                                              .parse(dateController.text)
                                          : null;

                                  // Obtén la zona horaria para América/Managua (Nicaragua)
                                  final String timeZoneName =
                                      'America/Argentina/Buenos_Aires';
                                  final tz.Location timeZone =
                                      tz.getLocation(timeZoneName);

                                  // Ajusta la fecha y la hora a la zona horaria correspondiente
                                  selectedDateTime = tz.TZDateTime.from(
                                      selectedDateTime!, timeZone);
                                  addTask(
                                      nameController.text,
                                      DescripController.text,
                                      selectedDateTime,
                                      EncargadoSeleccionado);

                                  Navigator.push(
                                    context,
                                    PageTransition(
                                      type: PageTransitionType.fade,
                                      child: Tareas(data: widget.data),
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
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                  const Color(0xFF1D1B45),
                                ),
                                shape:
                                    MaterialStateProperty.all<OutlinedBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                        10.0), // Ajusta el valor según lo que desees
                                  ),
                                ),
                              ),
                              child: Text("Crear tarea",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Color.fromARGB(255, 230, 230, 230),
                                  ))),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ],
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          unselectedItemColor: Colors.grey,
          selectedItemColor:
              Color(0xFF1D1B45), // Color para los íconos no seleccionados
          iconSize: 40,
          currentIndex: 0, // Índice inicial
          onTap: (index) {
            if (index == 0) {
              /*Navigator.push(
                context,
                PageTransition(
                  type: PageTransitionType.fade,
                  child: screens[0],
                ),
              );*/
            } else if (index == 1) {
              /*Navigator.push(
                context,
                PageTransition(
                  type: PageTransitionType.fade,
                  child: screens[1],
                ),
              );*/
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

class MeetingDataSource extends CalendarDataSource {
  MeetingDataSource(List<Appointment> source) {
    appointments = source;
  }
}

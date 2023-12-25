import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:tienda_login/pages/Acceder.dart';
import 'package:tienda_login/pages/Inicio.dart';
import 'package:tienda_login/pages/RegisterPage.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_svg_provider/flutter_svg_provider.dart';
import 'package:page_transition/page_transition.dart';
import 'package:timezone/data/latest.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;

void main() async {
  tzdata.initializeTimeZones();
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp().then((value) {
    initializeDateFormatting().then((_) => runApp(LoginApp()));
  });
}

class LoginApp extends StatelessWidget {
  const LoginApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter',
      home: LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  void initState() {
    super.initState();
    getUsers();
  }

  void getUsers() async {
    CollectionReference collectionReference =
        FirebaseFirestore.instance.collection("users");

    QuerySnapshot users = await collectionReference.get();
    if (users.docs.length != 0) {
      for (var doc in users.docs) {
        print(doc.data());
      }
    }
  }

  TextEditingController controllerUser = new TextEditingController();
  TextEditingController controllerPass = new TextEditingController();
  final List<Widget> screens = [Acceder(), RegisterPage()];

  @override
  Widget build(BuildContext context) {
    final query = MediaQuery.of(context);
    return MediaQuery(
      data: query.copyWith(textScaleFactor: 1.0),
      child: MaterialApp(
        home: Scaffold(
          resizeToAvoidBottomInset: false,
          body: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.only(top: 220),
              decoration: BoxDecoration(
                color: Color(0xFFFFFFFF),
              ),
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(padding: EdgeInsets.only(top: 10)),
                  Container(
                    child: Image.asset('assets/MarN.png'),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 50.0),
                    child: Container(
                      margin: EdgeInsets.fromLTRB(15, 0, 0, 0),
                      width: 260,
                      height: 48,
                      child: Center(
                        child: Text(
                          "¡Bienvenido!",
                          style: TextStyle(
                            color: Color(0xfff313A56),
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Noto Sans',
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 25),
                  Container(
                    width: 299,
                    height: 40,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          PageTransition(
                            type: PageTransitionType.fade,
                            child: screens[0],
                          ),
                        );
                      },
                      child: Text(
                        "Iniciar sesión",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontFamily: 'Noto Sans',
                        ),
                      ),
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                          Color(0xff313A56),
                        ),
                        minimumSize: MaterialStateProperty.all<Size>(
                          Size(900, 600),
                        ),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        shadowColor: MaterialStateProperty.all<Color>(
                          Color.fromARGB(0, 255, 255, 255).withOpacity(0.5),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 32),
                  Container(
                    width: 299,
                    height: 40,
                    child: ElevatedButton(
                      onPressed: () => {
                        Navigator.push(
                          context,
                          PageTransition(
                            type: PageTransitionType.fade,
                            child: screens[1],
                          ),
                        )
                      },
                      child: Text(
                        "Registrarse",
                        style: TextStyle(
                          color: Color(0xff313A56),
                          fontSize: 16,
                          fontFamily: 'Noto Sans',
                        ),
                      ),
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                          Color.fromARGB(255, 255, 255, 255),
                        ),
                        minimumSize: MaterialStateProperty.all<Size>(
                          Size(900, 600),
                        ),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            side: BorderSide(color: Color(0xffF9DE5B)),
                          ),
                        ),
                        shadowColor: MaterialStateProperty.all<Color>(
                          Color.fromARGB(0, 255, 255, 255).withOpacity(0.5),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 140,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

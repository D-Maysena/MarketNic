import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:tienda_login/pages/Estadisticas2.dart';
import 'package:page_transition/page_transition.dart';
import 'package:tienda_login/pages/Inicio.dart';
import 'package:tienda_login/pages/RegisterPage.dart';
import 'package:tienda_login/pages/RegistroEm.dart';
import 'package:tienda_login/pages/Tareas.dart';
import 'dart:io';

class Registro2 extends StatefulWidget {
  final Map<String, dynamic>? data;

  Registro2({Key? key, this.data}) : super(key: key);

  @override
  _Registro2State createState() => _Registro2State();
}

class _Registro2State extends State<Registro2> {
  @override
  Widget build(BuildContext context) {
    print(widget.data?["EmprendedorId"]);
    return WillPopScope(
        onWillPop: () => _onPop(context),
        child: Scaffold(
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Color.fromARGB(255, 255, 255, 255),
          ),
          resizeToAvoidBottomInset: false,
          body: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              return SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: IntrinsicHeight(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 255, 255, 255),
                      ),
                      width: double.infinity,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            child: Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 10.0, top: 180),
                                  child: Text(
                                    "¡Gracias por registrarte!",
                                    style: TextStyle(
                                        color: Color(0xff313A56),
                                        fontSize: 28,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'Noto Sans'),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 20.0),
                          ),
                          Text(
                            "Ahora, debes registrar tu emprendimiento",
                            style: TextStyle(
                                color: Color(0xff313A56),
                                fontSize: 15,
                                fontFamily: 'Noto Sans'),
                          ),
                          SizedBox(height: constraints.maxHeight * 0.05),
                          Container(
                            width: constraints.maxWidth * 0.8,
                            height: 40,
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    PageTransition(
                                        type: PageTransitionType.fade,
                                        child: RegistroEm(
                                            emprendedor_id: widget.data)));
                              },
                              child: Text(
                                "Registrar Emprendimiento",
                                style: TextStyle(
                                    color: Color(0xff313A56),
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Noto Sans'),
                              ),
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Color.fromARGB(255, 255, 255, 255)),
                                shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                    side: BorderSide(
                                      color: Color(0xffF9DE5B),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: constraints.maxHeight * 0.1),
                          Expanded(
                              child: Container()), // To push content to the top
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ));
  }
}

Future<bool> _onPop(BuildContext context) async {
  // No permitir que el usuario regrese
  return false;
}

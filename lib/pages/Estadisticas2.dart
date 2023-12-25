import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:tienda_login/pages/Inicio.dart';
import 'package:page_transition/page_transition.dart';
import 'package:tienda_login/pages/Tareas.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_charts/sparkcharts.dart';

class Estadisticas extends StatelessWidget {
  final List<Widget> screens = [Inicio(), Tareas()];

  List<_SalesData> data1 = [
    _SalesData('Ene', 35),
    _SalesData('Feb', 28),
    _SalesData('Mar', 27),
    _SalesData('Abr', 32),
    _SalesData('May', 21),
    _SalesData('Jun', 18),
    _SalesData('Jul', 39),
    _SalesData('Ago', 26),
    _SalesData('Sept', 40)
  ];

  List<_SalesData2> data2 = [
    _SalesData2('Lun', 14),
    _SalesData2('Mar', 20),
    _SalesData2('Mier', 12),
    _SalesData2('Jue', 29),
    _SalesData2('Vier', 14),
    _SalesData2('Sab', 40),
    _SalesData2('Dom', 9)
  ];

  @override
  Widget build(BuildContext context) {
    final query = MediaQuery.of(context);

    return MaterialApp(
      home: MediaQuery(
        data: query.copyWith(textScaleFactor: 1.0),
        child: Scaffold(
          appBar: AppBar(
            elevation: 0.0,
            backgroundColor: Colors.white,
            title: Container(
              padding: EdgeInsets.only(left: 75.0, top: 12.0),
              child: Text(
                "Estadisticas",
                style: TextStyle(
                  fontFamily: 'Bebas Neue',
                  color: Color(0xFF1D1B45),
                  fontSize: 38,
                ),
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
          body: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Center(
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
                    child: Text(
                      "Este mes",
                      style: TextStyle(
                          fontFamily: 'Bebas Neue',
                          fontSize: 31,
                          color: Color(0xFF1D1B45)),
                    ),
                  ),
                  SizedBox(height: 5),
                  // Agregar el gráfico de barras aquí
                  Padding(
                    padding: const EdgeInsets.only(left: 15.0),
                    child: Container(
                      height: 270,
                      width: 430,
                      child: SfCartesianChart(
                          primaryXAxis: CategoryAxis(),
                          // Chart title
                          title: ChartTitle(text: ''),
                          // Enable legend
                          legend: Legend(
                              isVisible: true,
                              height: '9%',
                              isResponsive: true),
                          // Enable tooltip
                          tooltipBehavior: TooltipBehavior(enable: true),
                          palette: <Color>[
                            Color(0xff41C16D)
                          ],
                          series: <ChartSeries<_SalesData, String>>[
                            ColumnSeries<_SalesData, String>(
                                dataSource: data1,
                                xValueMapper: (_SalesData sales, _) =>
                                    sales.year,
                                yValueMapper: (_SalesData sales, _) =>
                                    sales.sales,
                                name: 'Ventas',
                                // Enable data label
                                dataLabelSettings:
                                    DataLabelSettings(isVisible: true))
                          ]),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
                    child: Text(
                      "Esta semana",
                      style: TextStyle(
                          fontFamily: 'Bebas Neue',
                          fontSize: 31,
                          color: Color(0xFF1D1B45)),
                    ),
                  ),
                  Container(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 15.0),
                      child: Container(
                        height: 270,
                        width: 455,
                        child: SfCartesianChart(
                            primaryXAxis: CategoryAxis(),
                            // Chart title
                            title: ChartTitle(text: ''),
                            // Enable legend
                            legend: Legend(
                                isVisible: true,
                                height: '9%',
                                isResponsive: true),
                            // Enable tooltip
                            tooltipBehavior: TooltipBehavior(enable: true),
                            palette: <Color>[
                              Color(0xffF9DE5B)
                            ],
                            series: <ChartSeries<_SalesData2, String>>[
                              ColumnSeries<_SalesData2, String>(
                                  dataSource: data2,
                                  xValueMapper: (_SalesData2 sales, _) =>
                                      sales.day,
                                  yValueMapper: (_SalesData2 sales, _) =>
                                      sales.sales,
                                  name: 'Ventas',
                                  // Enable data label
                                  dataLabelSettings:
                                      DataLabelSettings(isVisible: true))
                            ]),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          bottomNavigationBar: BottomNavigationBar(
            unselectedItemColor: Colors.grey,
            iconSize: 36,
            currentIndex: 0,
            onTap: (index) {
              if (index == 0) {
                Navigator.push(
                  context,
                  PageTransition(
                    type: PageTransitionType.fade,
                    child: screens[0],
                  ),
                );
              } else if (index == 2) {
                Navigator.push(
                  context,
                  PageTransition(
                    type: PageTransitionType.fade,
                    child: screens[1],
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
              }
            },
            items: [
              BottomNavigationBarItem(
                icon: Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: Icon(
                    Icons.home_filled,
                    color: Colors.grey,
                  ),
                ),
                label: ' ',
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.leaderboard,
                  color: Color(0xFF1D1B45),
                ),
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
                icon: Icon(Icons.account_circle_outlined),
                label: 'Perfil',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SalesData {
  _SalesData(this.year, this.sales);

  final String year;
  final double sales;
}

class _SalesData2 {
  _SalesData2(this.day, this.sales);

  final String day;
  final double sales;
}

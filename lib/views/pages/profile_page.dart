// import 'package:flutter/material.dart';
// import 'package:pie_chart/pie_chart.dart';

// class PieChartScreen extends StatelessWidget {
//   final Map<String, double> dataMap = {
//     "Flutter": 40,
//     "React Native": 30,
//     "Xamarin": 15,
//     "Ionic": 15,
//   };

//   final List<Color> colorList = [
//     Colors.blue,
//     Colors.green,
//     Colors.orange,
//     Colors.red,
//   ];

//   PieChartScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("Pie Chart Example")),
//       body: Center(
//         child: PieChart(
//           dataMap: dataMap,
//           animationDuration: const Duration(milliseconds: 800),
//           chartType: ChartType.ring,
//           colorList: colorList,
//           chartRadius: MediaQuery.of(context).size.width / 2.5,
//           legendOptions: const LegendOptions(showLegends: true),
//           chartValuesOptions: const ChartValuesOptions(
//             showChartValuesInPercentage: true,
//           ),
//         ),
//       ),
//     );
//   }
// }

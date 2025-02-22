// import 'package:dropdown_button2/dropdown_button2.dart';
// import 'package:flutter/material.dart';
// import 'package:machine_hour_rate/core/theme/colors.dart';
// import 'package:machine_hour_rate/providers/auth_provider.dart';
// import 'package:machine_hour_rate/views/calculation/mhr_calculation.dart';
// import 'package:provider/provider.dart';

// class CalculationSheet extends StatefulWidget {
//   const CalculationSheet({super.key});

//   @override
//   State<CalculationSheet> createState() => _CalculationSheetState();
// }

// class _CalculationSheetState extends State<CalculationSheet> {
//   final _formKey = GlobalKey<FormState>();
//   String? selectedCurrency;
//   String? selectedMachineName;
//   String? selectedMachineWaysCategory;

//   final TextEditingController _powerConsumptionController =
//       TextEditingController();
//   final TextEditingController _laborCostController = TextEditingController();
//   final TextEditingController _maintenanceExpensesController =
//       TextEditingController();

//   String? _validateInput(String? value) {
//     if (value == null || value.isEmpty) {
//       return 'This field is required';
//     }
//     if (double.tryParse(value) == null) {
//       return 'Enter a valid number';
//     }
//     return null;
//   }

//   @override
//   void initState() {
//     super.initState();
//     Future.delayed(Duration.zero, () async {
//       final provider = Provider.of<AuthProvider>(context, listen: false);
//       await provider.fetchCurrency();
//       await provider.fetchMainMachine();
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: Column(
//         children: [
//           Expanded(
//             child: Padding(
//               padding: EdgeInsets.only(
//                 bottom: MediaQuery.of(context).viewInsets.bottom,
//                 left: 16,
//                 right: 16,
//               ),
//               child: SingleChildScrollView(
//                 child: Form(
//                   key: _formKey,
//                   child: Column(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       const SizedBox(height: 10),
//                       _buildCurrencyDropdown(),
//                       _buildMachineTypeDropdown(),
//                       _buildMachineDropdowns(),
//                       _buildMachineWaysCategoryDropdown(),
//                       _buildTextField('Machine Purchase Price (MP) (Rs)',
//                           _powerConsumptionController),
//                       _buildTextField('Machine Life in Years (L) (Yrs)',
//                           _laborCostController),
//                       _buildTextField('Salvage Value (S) (Rs)',
//                           _maintenanceExpensesController),
//                       _buildTextField('Power Consumption per Hour (PC) (Kw)',
//                           _maintenanceExpensesController),
//                       _buildTextField('Power Cost per Unit (PU) (Rs)',
//                           _maintenanceExpensesController),
//                       _buildTextField('Operator Wage per Hour (OW) (Rs)',
//                           _maintenanceExpensesController),
//                       _buildTextField('Maintenance Cost per Year (MC) (Rs)',
//                           _maintenanceExpensesController),
//                       _buildTextField('Consumables Cost per Year (CC) (Rs)',
//                           _maintenanceExpensesController),
//                       _buildTextField(
//                           'Factory Rent/Overheads per Year (RA) (Rs)',
//                           _maintenanceExpensesController),
//                       _buildTextField('Operating Hours per Day (H) (Hr)',
//                           _maintenanceExpensesController),
//                       _buildTextField('Working Days per Year (D) (Days))',
//                           _maintenanceExpensesController),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ),
//           Container(
//             width: double.infinity,
//             padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 16),
//             color: Colors.white,
//             child: ElevatedButton(
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: kButtonColor,
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 padding:
//                     const EdgeInsets.symmetric(horizontal: 100, vertical: 15),
//               ),
//               onPressed: _calculateMHR,
//               child: const Row(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   Icon(Icons.calculate, color: Colors.white),
//                   SizedBox(width: 10),
//                   Text('CALCULATE', style: TextStyle(color: Colors.white)),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildCurrencyDropdown() {
//     return Consumer<AuthProvider>(
//       builder: (context, provider, child) {
//         if (provider.isLoading) {
//           return const Center(child: CircularProgressIndicator());
//         }

//         print("Currency Data: ${provider.currencies}");

//         if (provider.currencies.isEmpty) {
//           return const Text("No currency data available");
//         }

//         List<String> currencyOptions = provider.currencies
//             .map((currency) =>
//                 "${currency['name'] ?? 'Unknown'} (${currency['amount'] ?? 0})")
//             .toList();

//         return _buildStyledDropdown(
//           'Select your currency',
//           currencyOptions,
//           selectedCurrency,
//           (value) => setState(() => selectedCurrency = value),
//         );
//       },
//     );
//   }

//   Widget _buildMachineTypeDropdown() {
//     return Consumer<AuthProvider>(
//       builder: (context, provider, child) {
//         if (provider.isLoading) {
//           return const Center(child: CircularProgressIndicator());
//         }

//         print("Main Machine data: ${provider.machine}");

//         if (provider.machine.isEmpty) {
//           return const Text("No Main Machine data available");
//         }

//         List<String> machineOptions = provider.machine
//             .map((machine) => "${machine['name'] ?? 'Unknown'}")
//             .toList();

//         return _buildStyledDropdown(
//           'Select your Machine type',
//           machineOptions,
//           selectedMachineName,
//           (value) => setState(() => selectedMachineName = value),
//         );
//       },
//     );
//   }

//   Widget _buildMachineDropdowns() {
//     return _buildStyledDropdown(
//       'Select Machine Categorys',
//       ['CNC Machine', 'Lathe Machine', 'Conventional Machine'],
//       selectedMachineName,
//       (value) => setState(() => selectedMachineName = value),
//     );
//   }

//   Widget _buildMachineWaysCategoryDropdown() {
//     return _buildStyledDropdown(
//       'Select Machine SubCategorys',
//       [
//         'Lathe Machine',
//         'Milling Machine',
//         'Drilling Machine',
//         'CNC Machine',
//         'Lathe Machine',
//         'Conventional Machine'
//       ],
//       selectedMachineWaysCategory,
//       (value) => setState(() => selectedMachineWaysCategory = value),
//     );
//   }

//   Widget _buildStyledDropdown(String hint, List<String> options,
//       String? selectedValue, Function(String?) onChanged) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 8),
//       child: DropdownButtonFormField2<String>(
//         isExpanded: true,
//         value: selectedValue,
//         decoration: InputDecoration(
//           border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
//           contentPadding:
//               const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
//         ),
//         items: options
//             .map((option) => DropdownMenuItem<String>(
//                   value: option,
//                   child: Text(option,
//                       style: const TextStyle(
//                           fontSize: 16, fontWeight: FontWeight.w500)),
//                 ))
//             .toList(),
//         onChanged: onChanged,
//         validator: (value) => value == null ? 'Please select an option' : null,
//       ),
//     );
//   }

//   Widget _buildTextField(String label, TextEditingController controller) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 10),
//       child: TextFormField(
//         controller: controller,
//         keyboardType: TextInputType.number,
//         cursorColor: Colors.grey,
//         decoration: InputDecoration(
//           labelText: label,
//           border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
//         ),
//         validator: _validateInput,
//       ),
//     );
//   }

//   void _calculateMHR() {
//     if (_formKey.currentState!.validate()) {
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(builder: (context) => MHRCalculatorScreen()),
//       );
//     }
//   }
// }

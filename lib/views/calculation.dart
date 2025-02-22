import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:machine_hour_rate/core/theme/colors.dart';
import 'package:machine_hour_rate/models/currency,dart';
import 'package:machine_hour_rate/providers/auth_provider.dart';
import 'package:machine_hour_rate/views/calculation/mhr_calculation.dart';
import 'package:provider/provider.dart';

class CalculationSheet extends StatefulWidget {
  const CalculationSheet({super.key});

  @override
  State<CalculationSheet> createState() => _CalculationSheetState();
}

class _CalculationSheetState extends State<CalculationSheet> {
  final _formKey = GlobalKey<FormState>();
  // String? selectedCurrency;
  String? selectedMachineName;
  String? selectedMachineWaysCategory;
  // CurrencyModel? _selectedCurrency;
  String? _selectedCurrency;

  final TextEditingController _powerConsumptionController =
      TextEditingController();
  final TextEditingController _laborCostController = TextEditingController();
  final TextEditingController _maintenanceExpensesController =
      TextEditingController();

  String? _validateInput(String? value) {
    if (value == null || value.isEmpty) {
      return 'This field is required';
    }
    if (double.tryParse(value) == null) {
      return 'Enter a valid number';
    }
    return null;
  }

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    final provider = Provider.of<AuthProvider>(context, listen: false);
    // await provider.fetchCurrency();
    // await provider.fetchMainMachine();
  }

  Future<void> _refreshData() async {
    await _fetchData();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    // final currency = authProvider.currency;
    // final mainMachines = authProvider.mainMachines;

    return Scaffold(
      backgroundColor: Colors.white,
      body: RefreshIndicator(
        onRefresh: _refreshData,
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom,
                  left: 16,
                  right: 16,
                ),
                child: SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(height: 10),
                        _buildCurrencyDropdown(),
                        // _buildMachineTypeDropdown(),
                        _buildMachineDropdowns(),
                        _buildMachineWaysCategoryDropdown(),
                        _buildTextField(
                            'Machine Purchase Price (MP) (Rs)',
                            _powerConsumptionController,
                            TextInputType.number,
                            _validateInput),
                        _buildTextField(
                            'Machine Life in Years (L) (Yrs)',
                            _laborCostController,
                            TextInputType.number,
                            _validateInput),
                        _buildTextField(
                            'Salvage Value (S) (Rs)',
                            _maintenanceExpensesController,
                            TextInputType.number,
                            _validateInput),
                        _buildTextField(
                            'Power Consumption per Hour (PC) (Kw)',
                            _maintenanceExpensesController,
                            TextInputType.number,
                            _validateInput),
                        _buildTextField(
                            'Power Cost per Unit (PU) (Rs)',
                            _maintenanceExpensesController,
                            TextInputType.number,
                            _validateInput),
                        _buildTextField(
                            'Operator Wage per Hour (OW) (Rs)',
                            _maintenanceExpensesController,
                            TextInputType.number,
                            _validateInput),
                        _buildTextField(
                            'Maintenance Cost per Year (MC) (Rs)',
                            _maintenanceExpensesController,
                            TextInputType.number,
                            _validateInput),
                        _buildTextField(
                            'Consumables Cost per Year (CC) (Rs)',
                            _maintenanceExpensesController,
                            TextInputType.number,
                            _validateInput),
                        _buildTextField(
                            'Factory Rent/Overheads per Year (RA) (Rs)',
                            _maintenanceExpensesController,
                            TextInputType.number,
                            _validateInput),
                        _buildTextField(
                            'Operating Hours per Day (H) (Hr)',
                            _maintenanceExpensesController,
                            TextInputType.number,
                            _validateInput),
                        _buildTextField(
                            'Working Days per Year (D) (Days))',
                            _maintenanceExpensesController,
                            TextInputType.number,
                            _validateInput),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 16),
              color: Colors.white,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: kButtonColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 100, vertical: 15),
                ),
                onPressed: _calculateMHR,
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.calculate, color: Colors.white),
                    SizedBox(width: 10),
                    Text('CALCULATE', style: TextStyle(color: Colors.white)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCurrencyDropdown() {
    return Consumer<AuthProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (provider.currencies.isEmpty) {
          return const Text("No currency data available");
        }

        return DropdownButtonFormField<String>(
          value: _selectedCurrency,
          decoration: const InputDecoration(
            labelText: "Select your currency",
            border: OutlineInputBorder(),
          ),
          items: provider.currencies.map((currency) {
            return DropdownMenuItem<String>(
              value: currency.id,
              child: Text("${currency.name} (${currency.amount})"),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              _selectedCurrency = value;
            });
          },
        );
      },
    );
  }
  //   return Consumer<AuthProvider>(
  //     builder: (context, provider, child) {
  //       if (provider.isLoading) {
  //         return const Center(child: CircularProgressIndicator());
  //       }

  //       if (provider.currencies.isEmpty) {
  //         return const Text("No currency data available");
  //       }

  //       print("Currency Data: ${provider.currencies}");

  //       List<String> CurrenyModel = provider.currencies
  //           .map((currency) => "${currency.name} (${currency.amount})")
  //           .toList();

  //       return _buildStyledDropdown(
  //         'Select your currency',
  //         _selectedCurrency.
  //       );
  //     },
  //   );
  // }

  // Widget _buildCurrencyDropdown() {
  //   return Consumer<AuthProvider>(
  //     builder: (context, provider, child) {
  //       if (provider.isLoading || provider.currencies.isEmpty) {
  //         return const Center(child: CircularProgressIndicator());
  //       }

  //       print("Currency Data: ${provider.currencies}");

  //       if (provider.currencies.isEmpty) {
  //         return const Text("No currency data available");
  //       }

  //       List<String> currencyOptions = provider.currencies
  //           .map((currency) =>
  //               "${currency['name']} (${int.parse(currency['amount'].toString())})")
  //           .toList();

  //       return _buildStyledDropdown(
  //         'Select your currency',
  //         currencyOptions,
  //         selectedCurrency,
  //         (value) => setState(() => selectedCurrency = value),
  //       );
  //     },
  //   );
  // }

  // Widget _buildMachineTypeDropdown() {
  //   return Consumer<AuthProvider>(
  //     builder: (context, provider, child) {
  //       if (provider.isLoading || provider.machine.isEmpty) {
  //         return const Center(child: CircularProgressIndicator());
  //       }

  //       print("Main Machine data: ${provider.machine}");

  //       if (provider.machine.isEmpty) {
  //         return const Text("No Main Machine data available");
  //       }

  //       List<String> machineOptions = provider.machine
  //           .map((machine) => machine['name']?.toString() ?? 'Unknown')
  //           .toSet()
  //           .toList();

  //       if (!machineOptions.contains(selectedMachineName)) {
  //         selectedMachineName = null;
  //       }

  //       print("Dropdown Options: $machineOptions");
  //       print("Selected Value: $selectedMachineName");

  //       return _buildStyledDropdown(
  //           'Select your Machine type', machineOptions, selectedMachineName,
  //           (value) async {
  //         setState(() {
  //           selectedMachineName = value;
  //         });
  //       });
  //     },
  //   );
  // }

  Widget _buildMachineDropdowns() {
    return _buildStyledDropdown(
      'Select Machine Categorys',
      ['CNC Machine', 'Conventional Machine'],
      selectedMachineName,
      (value) => setState(() => selectedMachineName = value),
    );
  }

  Widget _buildMachineWaysCategoryDropdown() {
    return _buildStyledDropdown(
      'Select Machine SubCategorys',
      ['Lathe Machine', 'Milling Machine', 'Drilling Machine'],
      selectedMachineWaysCategory,
      (value) => setState(() => selectedMachineWaysCategory = value),
    );
  }

  Widget _buildStyledDropdown(String hint, List<String> options,
      String? selectedValue, Function(String?) onChanged) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: DropdownButtonFormField2<String>(
        isExpanded: true,
        value: selectedValue,
        decoration: InputDecoration(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          focusedBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
            borderSide: BorderSide(color: Colors.blue, width: 2.0),
          ),
          errorBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
            borderSide: BorderSide(color: Colors.grey, width: 2.0),
          ),
          focusedErrorBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
            borderSide: BorderSide(color: Colors.grey, width: 2.5),
          ),
          errorStyle: const TextStyle(color: Colors.red, fontSize: 14),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          suffixIcon: selectedValue != null
              ? IconButton(
                  icon: const Icon(Icons.close, color: Colors.red),
                  onPressed: () {
                    setState(() => onChanged(null));
                  },
                )
              : null,
        ),
        items: [
          DropdownMenuItem<String>(
            value: null,
            child: Text(hint, style: const TextStyle(color: Colors.grey)),
          ),
          ...options.map((option) => DropdownMenuItem<String>(
                value: option,
                child: Text(option,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w500)),
              ))
        ],
        onChanged: onChanged,
        validator: (value) => value == null ? 'Please select an option' : null,
        hint: Text(hint, style: const TextStyle(fontSize: 16)),
        dropdownStyleData: DropdownStyleData(
          maxHeight: 300,
          width: 250,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Colors.white,
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 5,
                spreadRadius: 1,
                offset: Offset(0, 2),
              ),
            ],
          ),
        ),
        menuItemStyleData: const MenuItemStyleData(
          height: 50,
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller,
      TextInputType inputType, String? Function(String?) validator) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: TextFormField(
        controller: controller,
        keyboardType: inputType,
        cursorColor: Colors.grey,
        cursorErrorColor: Colors.grey,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Colors.grey),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          focusedBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
            borderSide: BorderSide(color: Colors.blue, width: 2.0),
          ),
          errorBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
            borderSide: BorderSide(color: Colors.grey, width: 2.0),
          ),
          focusedErrorBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
            borderSide: BorderSide(color: Colors.grey, width: 2.5),
          ),
          errorStyle: const TextStyle(color: Colors.red, fontSize: 14),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
        validator: validator,
      ),
    );
  }

  void _calculateMHR() {
    if (_formKey.currentState!.validate()) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MHRCalculatorScreen()),
      );
    }
  }
}
// import 'package:dropdown_button2/dropdown_button2.dart';
// import 'package:flutter/material.dart';
// import 'package:machine_hour_rate/providers/auth_provider.dart';
// import 'package:machine_hour_rate/views/calculation/mhr_calculation.dart';
// import 'package:machine_hour_rate/views/pages/help.dart';
// import 'package:provider/provider.dart';

// class CalculationSheet extends StatefulWidget {
//   const CalculationSheet({super.key});

//   @override
//   State<CalculationSheet> createState() => _CalculationSheetState();
// }

// class _CalculationSheetState extends State<CalculationSheet> {
//   final _formKey = GlobalKey<FormState>();
//   String? selectedCurrency;
//   String? selectedMachineType;
//   String? selectedMachineCategory;
//   String? selectedMachineSubCategory;

//   @override
//   void initState() {
//     super.initState();
//     // Fetching data on init
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       final authProvider = Provider.of<AuthProvider>(context, listen: false);
//       authProvider.fetchCurrencyData();
//       authProvider.fetchMachineTypes();
//       const mainCatId =
//           'some_value'; // Replace 'some_value' with the actual value you want to use
//       authProvider.fetchMachineCategories(mainCatId);
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
//                       _buildMachineDropdown(),
//                       _buildMachineWaysCategoryDropdown(),
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
//                 backgroundColor: Colors.blue,
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

//   // Currency Dropdown
//   Widget _buildCurrencyDropdown() {
//     final authProvider = Provider.of<AuthProvider>(context);
//     return _buildStyledDropdown(
//       "Select Currency",
//       authProvider.currencies,
//       selectedCurrency,
//       (value) {
//         setState(() {
//           selectedCurrency = value;
//           SharedPreferencesHelper.setSelectedCurrency(value!);
//         });
//       },
//     );
//   }

//   // Machine Type Dropdown
//   Widget _buildMachineTypeDropdown() {
//     final authProvider = Provider.of<AuthProvider>(context);
//     return _buildStyledDropdown(
//       "Select Machine Type",
//       authProvider.machineTypes,
//       selectedMachineType,
//       (value) {
//         setState(() {
//           selectedMachineType = value;
//           SharedPreferencesHelper.setSelectedMachineType(value!);
//           // authProvider.fetchMachineCategories(value);
//         });
//       },
//     );
//   }

//   // Machine Category Dropdown
//   Widget _buildMachineDropdown() {
//     final authProvider = Provider.of<AuthProvider>(context);
//     return _buildStyledDropdown(
//       "Select Machine Category",
//       authProvider.machineCategories,
//       selectedMachineCategory,
//       (value) {
//         setState(() {
//           selectedMachineCategory = value;
//           SharedPreferencesHelper.setSelectedMachineCategory(value!);
//           // SharedPreferencesHelper.getSelectedMachineCategory();
//           // authProvider.fetchMachines(value);
//         });
//       },
//     );
//   }

//   Widget _buildMachineWaysCategoryDropdown() {
//     final authProvider = Provider.of<AuthProvider>(context);
//     return _buildStyledDropdown(
//       "Select Machine SubCategory",
//       authProvider.machineSubCategories,
//       selectedMachineSubCategory,
//       (value) async {
//         setState(() {
//           selectedMachineSubCategory = value;
//           SharedPreferencesHelper.setSeletedMachineSubCategory(value!);
//           // SharedPreferencesHelper.getSeletedMachineSubCategory();
//           // authProvider.fetchMachines(value);
//         });
//       },
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
//           focusedBorder: const OutlineInputBorder(
//             borderRadius: BorderRadius.all(Radius.circular(10.0)),
//             borderSide: BorderSide(color: Colors.blue, width: 2.0),
//           ),
//           errorBorder: const OutlineInputBorder(
//             borderRadius: BorderRadius.all(Radius.circular(10.0)),
//             borderSide: BorderSide(color: Colors.grey, width: 2.0),
//           ),
//           focusedErrorBorder: const OutlineInputBorder(
//             borderRadius: BorderRadius.all(Radius.circular(10.0)),
//             borderSide: BorderSide(color: Colors.grey, width: 2.5),
//           ),
//           errorStyle: const TextStyle(color: Colors.red, fontSize: 14),
//           contentPadding:
//               const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
//           suffixIcon: selectedValue != null
//               ? IconButton(
//                   icon: const Icon(Icons.close, color: Colors.red),
//                   onPressed: () {
//                     setState(() => onChanged(null));
//                   },
//                 )
//               : null,
//         ),
//         items: [
//           DropdownMenuItem<String>(
//             value: null,
//             child: Text(hint, style: const TextStyle(color: Colors.grey)),
//           ),
//           ...options.map((option) => DropdownMenuItem<String>(
//                 value: option,
//                 child: Text(option,
//                     style: const TextStyle(
//                         fontSize: 16, fontWeight: FontWeight.w500)),
//               ))
//         ],
//         onChanged: onChanged,
//         validator: (value) => value == null ? 'Please select an option' : null,
//         hint: Text(hint, style: const TextStyle(fontSize: 16)),
//         dropdownStyleData: DropdownStyleData(
//           maxHeight: 300,
//           width: 250,
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(12),
//             color: Colors.white,
//             boxShadow: const [
//               BoxShadow(
//                 color: Colors.black26,
//                 blurRadius: 5,
//                 spreadRadius: 1,
//                 offset: Offset(0, 2),
//               ),
//             ],
//           ),
//         ),
//         menuItemStyleData: const MenuItemStyleData(
//           height: 50,
//           padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
//         ),
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

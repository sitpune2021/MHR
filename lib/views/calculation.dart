import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:machine_hour_rate/core/theme/colors.dart';
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
  String? selectedCurrency;
  String? selectedMachineName;
  String? selectedMachineWaysCategory;
  final TextEditingController _powerConsumptionController =
      TextEditingController();
  final TextEditingController _laborCostController = TextEditingController();
  final TextEditingController _maintenanceExpensesController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        Provider.of<AuthProvider>(context, listen: false).loadCategories());
  }

  @override
  Widget build(BuildContext context) {
    // final authProvider = Provider.of<AuthProvider>(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          top: 16,
          left: 16,
          right: 16,
        ),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'NEW CALCULATION',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                _buildDropdown(), // Currency selection
                _buildMachineTypeDropdown(), // Machine Type Dropdown
                _buildMachineDropdown(), // Machine Name Dropdown
                _buildMachineWaysCategoryDropdown(), // Machine Ways Categories Dropdown
                const Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      'Machine Cost Factors',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                _buildTextField(
                  'Machine Purchase Price (MP) (Rs)',
                  _powerConsumptionController,
                  TextInputType.number,
                  (value) {
                    if (value == null || value.isEmpty) {
                      return 'Power consumption is required';
                    }
                    if (double.tryParse(value) == null) {
                      return 'Enter a valid number';
                    }
                    return null;
                  },
                ),
                _buildTextField(
                  'Machine Life in Years (L) (Yrs)',
                  _laborCostController,
                  TextInputType.number,
                  (value) {
                    if (value == null || value.isEmpty) {
                      return 'Labor cost is required';
                    }
                    if (double.tryParse(value) == null) {
                      return 'Enter a valid amount';
                    }
                    return null;
                  },
                ),
                _buildTextField(
                  'Salvage Value (S) (Rs)',
                  _maintenanceExpensesController,
                  TextInputType.number,
                  (value) {
                    if (value == null || value.isEmpty) {
                      return 'Maintenance cost is required';
                    }
                    if (double.tryParse(value) == null) {
                      return 'Enter a valid amount';
                    }
                    return null;
                  },
                ),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      'Operating Costs',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                _buildTextField(
                  'Power Consumption per Hour (PC) (Kw)',
                  _maintenanceExpensesController,
                  TextInputType.number,
                  (value) {
                    if (value == null || value.isEmpty) {
                      return 'Maintenance cost is required';
                    }
                    if (double.tryParse(value) == null) {
                      return 'Enter a valid amount';
                    }
                    return null;
                  },
                ),
                _buildTextField(
                  'Power Cost per Unit (PU) (Rs)',
                  _maintenanceExpensesController,
                  TextInputType.number,
                  (value) {
                    if (value == null || value.isEmpty) {
                      return 'Maintenance cost is required';
                    }
                    if (double.tryParse(value) == null) {
                      return 'Enter a valid amount';
                    }
                    return null;
                  },
                ),
                _buildTextField(
                  'Operator Wage per Hour (OW) (Rs)',
                  _maintenanceExpensesController,
                  TextInputType.number,
                  (value) {
                    if (value == null || value.isEmpty) {
                      return 'Maintenance cost is required';
                    }
                    if (double.tryParse(value) == null) {
                      return 'Enter a valid amount';
                    }
                    return null;
                  },
                ),
                _buildTextField(
                  'Maintenance Cost per Year (MC) (Rs)',
                  _maintenanceExpensesController,
                  TextInputType.number,
                  (value) {
                    if (value == null || value.isEmpty) {
                      return 'Maintenance cost is required';
                    }
                    if (double.tryParse(value) == null) {
                      return 'Enter a valid amount';
                    }
                    return null;
                  },
                ),
                _buildTextField(
                  'Consumables Cost per Year (CC) (Rs)',
                  _maintenanceExpensesController,
                  TextInputType.number,
                  (value) {
                    if (value == null || value.isEmpty) {
                      return 'Maintenance cost is required';
                    }
                    if (double.tryParse(value) == null) {
                      return 'Enter a valid amount';
                    }
                    return null;
                  },
                ),
                _buildTextField(
                  'Factory Rent/Overheads per Year (RA) (Rs)',
                  _maintenanceExpensesController,
                  TextInputType.number,
                  (value) {
                    if (value == null || value.isEmpty) {
                      return 'Maintenance cost is required';
                    }
                    if (double.tryParse(value) == null) {
                      return 'Enter a valid amount';
                    }
                    return null;
                  },
                ),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      'Working Hours',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                _buildTextField(
                  'Operating Hours per Day (H) (Hr)',
                  _maintenanceExpensesController,
                  TextInputType.number,
                  (value) {
                    if (value == null || value.isEmpty) {
                      return 'Maintenance cost is required';
                    }
                    if (double.tryParse(value) == null) {
                      return 'Enter a valid amount';
                    }
                    return null;
                  },
                ),
                _buildTextField(
                  'Working Days per Year (D) (Days))',
                  _maintenanceExpensesController,
                  TextInputType.number,
                  (value) {
                    if (value == null || value.isEmpty) {
                      return 'Maintenance cost is required';
                    }
                    if (double.tryParse(value) == null) {
                      return 'Enter a valid amount';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kButtonColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 100, vertical: 15),
                  ),
                  onPressed: _calculateMHR,
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.calculate, color: Colors.white),
                      SizedBox(width: 8),
                      Text('CALCULATE', style: TextStyle(color: Colors.white)),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDropdown() {
    return _buildStyledDropdown(
      'Select your currency',
      ['USD (\$)', 'INR (₹)'],
      selectedCurrency,
      (value) => setState(() => selectedCurrency = value),
    );
  }

  Widget _buildMachineTypeDropdown() {
    return _buildStyledDropdown(
      'Select Machine Type',
      [
        'Industry',
        'Others',
      ],
      selectedMachineName,
      (value) => setState(() => selectedMachineName = value),
    );
  }

  Widget _buildMachineDropdown() {
    return Consumer<AuthProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading) {
          return const CircularProgressIndicator(); // Show loading indicator
        }

        if (provider.categories.isEmpty) {
          return const Text(
              "No categories available"); // Show message if no data
        }

        return _buildStyledDropdown(
          'Select Machine Categorys',
          provider.categories
              .map((category) => category["name"]! as String)
              .toList(),
          selectedMachineName,
          (value) => setState(() => selectedMachineName = value),
        );
      },
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
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.blue, width: 2),
          ),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          suffixIcon: selectedValue != null
              ? IconButton(
                  icon: const Icon(Icons.close, color: Colors.red),
                  onPressed: () {
                    setState(() => onChanged(null));
                  },
                )
              : null, // Show clear button only if an option is selected
        ),
        items: [
          DropdownMenuItem<String>(
            value: null, // Allows unselecting
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

        /// Customization of Dropdown Menu
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
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          focusedBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
            borderSide: BorderSide(color: Colors.blue, width: 2.0),
          ),
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

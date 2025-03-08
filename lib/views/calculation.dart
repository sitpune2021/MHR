import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:machine_hour_rate/core/theme/colors.dart';
import 'package:machine_hour_rate/models/currencyModel.dart';
import 'package:machine_hour_rate/models/machine_categoriesModel.dart';
import 'package:machine_hour_rate/models/machine_subcategoriesModel.dart';
import 'package:machine_hour_rate/models/mainmachineModel.dart';
import 'package:machine_hour_rate/views/calculation/mhr_calculation.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:machine_hour_rate/providers/calculationprovider.dart';

class CalculationSheet extends StatefulWidget {
  const CalculationSheet({super.key});

  @override
  State<CalculationSheet> createState() => _CalculationSheetState();
}

class _CalculationSheetState extends State<CalculationSheet> {
  final _formKey = GlobalKey<FormState>();
  List<CurrencyModel> currencyList = [];
  String? selectedCurrency;
  String? selectedCurrencyId;
  String? selectedCurrencyName;

  List<MainMachineModel> machineList = [];
  String? selectedMachine;
  String? selectedMachineId;

  List<MachineCatModel> categoryList = [];
  String? selectedCategory;
  String? selectedCategoryId;

  List<MachineSubCatModel> subcategoryList = [];
  String? selectedSubCategory;
  String? selectedSubCategoryId;

  final TextEditingController _powerConsumptionController =
      TextEditingController();
  final TextEditingController _maintenanceCostController =
      TextEditingController();
  final TextEditingController _machinePriceController = TextEditingController();
  final TextEditingController _machineLifeController = TextEditingController();
  final TextEditingController _salvageValueController = TextEditingController();
  final TextEditingController _powerCostController = TextEditingController();
  final TextEditingController _operatorWageController = TextEditingController();
  final TextEditingController _consumableCostController =
      TextEditingController();
  final TextEditingController _factoryRentController = TextEditingController();
  final TextEditingController _operatingHoursController =
      TextEditingController();
  final TextEditingController _workingDaysController = TextEditingController();
  final TextEditingController _fuelCostController = TextEditingController();
  @override
  void initState() {
    super.initState();
    _fetchData();
    fetchCurrencyData();
    fetchMachineData();
  }

  String? _validateInput(String? value) {
    if (value == null || value.isEmpty) {
      return 'This field is required';
    }
    final double? number = double.tryParse(value);
    if (number == null || number < 0) {
      return 'Enter a valid positive number';
    }
    return null;
  }

// 1 currency List
  Future<void> fetchCurrencyData() async {
    final url = Uri.parse('https://mhr.sitsolutions.co.in/get_currency');
    try {
      final response = await http.get(url);
      if (kDebugMode) {
        print("API Response Status Code: ${response.statusCode}");
      }
      if (kDebugMode) {
        print("API Response Body: ${response.body}");
      }
      if (response.statusCode == 200) {
        Map<String, dynamic> jsonData = json.decode(response.body);

        if (!jsonData.containsKey("details") || jsonData["details"] == null) {
          if (kDebugMode) {
            print("Error: 'details' key missing or null");
          }
          return;
        }
        List<dynamic> currencyJsonList = jsonData["details"];
        List<CurrencyModel> currencies =
            currencyJsonList.map((e) => CurrencyModel.fromJson(e)).toList();

        setState(() {
          currencyList = currencies;
        });

        if (kDebugMode) {
          print("Currency List Updated: ${currencyList.map((e) => e.name)}");
        }
      } else {
        throw Exception('Failed to load currency data');
      }
    } catch (error) {
      if (kDebugMode) {
        print('Error fetching currency data: $error');
      }
    }
  }

//2 Fetch Main Machine
  Future<void> fetchMachineData() async {
    final url = Uri.parse('https://mhr.sitsolutions.co.in/maincategories');
    try {
      final response = await http.get(url);
      if (kDebugMode) {
        print("API Response Status Code: ${response.statusCode}");
      }
      if (kDebugMode) {
        print("API Response Body: ${response.body}");
      }
      if (response.statusCode == 200) {
        Map<String, dynamic> jsonData = json.decode(response.body);
        if (!jsonData.containsKey("details") || jsonData["details"] == null) {
          if (kDebugMode) {
            print("Error: 'details' key missing or null");
          }
          return;
        }
        List<dynamic> machineJsonList = jsonData["details"];
        List<MainMachineModel> machines =
            machineJsonList.map((e) => MainMachineModel.fromJson(e)).toList();
        setState(() {
          machineList = machines;
        });
      } else {
        throw Exception('Failed to load machine data');
      }
    } catch (error) {
      if (kDebugMode) {
        print('Error fetching machine data: $error');
      }
    }
  }

// 3 Fetch Machine Categories (POST)
  Future<void> fetchCategoryData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (kDebugMode) {
      print(prefs.getString('selectedMainMachineId'));
    }
    final url = Uri.parse('https://mhr.sitsolutions.co.in/categories');
    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(
            {"main_cat_id": prefs.getString('selectedMainMachineId')}),
      );
      if (kDebugMode) {
        print("API Response Status Code: ${response.statusCode}");
      }
      if (kDebugMode) {
        print("API Response Body: ${response.body}");
      }
      if (response.statusCode == 200) {
        Map<String, dynamic> jsonData = json.decode(response.body);
        if (!jsonData.containsKey("details") || jsonData["details"] == null) {
          if (kDebugMode) {
            print("Error: 'details' key missing or null");
          }
          return;
        }
        List<dynamic> categoryJsonList = jsonData["details"];
        List<MachineCatModel> categories =
            categoryJsonList.map((e) => MachineCatModel.fromJson(e)).toList();
        setState(() {
          categoryList = categories;
          if (kDebugMode) {
            print("Categories Loaded: ${categoryList.map((e) => e.name)}");
          }
        });
      } else {
        throw Exception('Failed to load categories');
      }
    } catch (error) {
      if (kDebugMode) {
        print('Error fetching category data: $error');
      }
    }
  }

// 4 Fetch Machine SubCategories (POST)
  Future<void> fetchSubCategories() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (kDebugMode) {
      print(prefs.getString('selectedMainMachineId'));
    }
    if (kDebugMode) {
      print(prefs.getString('selectedMachinecatId'));
    }

    final url = Uri.parse("https://mhr.sitsolutions.co.in/subcategories");
    try {
      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "cat_id": prefs.getString('selectedMachinecatId'),
        }),
      );
      if (kDebugMode) {
        print("API Response subcategories.................: ${response.body}");
      }
      if (response.statusCode == 200) {
        Map<String, dynamic> jsonData = json.decode(response.body);
        if (!jsonData.containsKey("details") || jsonData["details"] == null) {
          if (kDebugMode) {
            print("Error: 'details' key missing or null");
          }
          return;
        }
        List<dynamic> subcategoryJsonList = jsonData["details"];
        List<MachineSubCatModel> subcategories = subcategoryJsonList
            .map((e) => MachineSubCatModel.fromJson(e))
            .toList();
        setState(() {
          subcategoryList = subcategories;
          if (kDebugMode) {
            print("SubCategories length........: ${subcategoryList.length}");
          }
          if (kDebugMode) {
            print(
                "SubCategories catid...........: ${subcategoryList.map((e) => e.id)}");
          }
        });
      } else {
        throw Exception('Failed to load subcategories');
      }
    } catch (error) {
      if (kDebugMode) {
        print('Error fetching subcategory data: $error');
      }
    }
  }

//focus
  final FocusNode _maintenanceCostFocusNode = FocusNode();
  final FocusNode _machinePriceFocusNode = FocusNode();
  final FocusNode _machineLifeFocusNode = FocusNode();
  final FocusNode _salvageValueFocusNode = FocusNode();
  final FocusNode _powerConsumptionFocusNode = FocusNode();
  final FocusNode _powerCostFocusNode = FocusNode();
  final FocusNode _operatorWageFocusNode = FocusNode();
  final FocusNode _consumableCostFocusNode = FocusNode();
  final FocusNode _factoryRentFocusNode = FocusNode();
  final FocusNode _operatingHoursFocusNode = FocusNode();
  final FocusNode _workingDaysFocusNode = FocusNode();
  final FocusNode _fuelCostFocusNode = FocusNode();

  // Make sure to dispose the FocusNodes
  @override
  void dispose() {
    _maintenanceCostFocusNode.dispose();
    _machinePriceFocusNode.dispose();
    _machineLifeFocusNode.dispose();
    _salvageValueFocusNode.dispose();
    _powerConsumptionFocusNode.dispose();
    _powerCostFocusNode.dispose();
    _operatorWageFocusNode.dispose();
    _consumableCostFocusNode.dispose();
    _factoryRentFocusNode.dispose();
    _operatingHoursFocusNode.dispose();
    _workingDaysFocusNode.dispose();
    _fuelCostFocusNode.dispose();
    super.dispose();
  }

  Future<void> _fetchData() async {
    fetchCurrencyData();
    fetchMachineData();
    fetchCategoryData();
    fetchSubCategories();
  }

  Future<void> _refreshData() async {
    setState(() {
      selectedCurrency = null;
      selectedMachine = null;
      selectedCategory = null;
      selectedSubCategory = null;

      _powerConsumptionController.clear();
      _maintenanceCostController.clear();
      _machinePriceController.clear();
      _machineLifeController.clear();
      _salvageValueController.clear();
      _powerCostController.clear();
      _operatorWageController.clear();
      _consumableCostController.clear();
      _factoryRentController.clear();
      _operatingHoursController.clear();
      _workingDaysController.clear();
      _fuelCostController.clear();

      currencyList.clear();
      machineList.clear();
      categoryList.clear();
      subcategoryList.clear();

      _formKey.currentState?.reset();
    });
    await _fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: RefreshIndicator(
        color: kBackgroundColor,
        backgroundColor: Colors.white,
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
                        _buildCurrency(),
                        _buildMachine(),
                        selectedMachine != null
                            ? _buildMachineCate()
                            : Container(),
                        selectedCategory != null
                            ? _buildMachineSub()
                            : Container(),
                        // _buildTextField(
                        //     'Maintenance Cost per Year (MC) (Rs)',
                        //     _maintenanceCostController,
                        //     TextInputType.number,
                        //     _validateInput,

                        //     ),
                        // _buildTextField(
                        //     'Machine Purchase Price (MP) (Rs)',
                        //     _machinePriceController,
                        //     TextInputType.number,
                        //     _validateInput),
                        // _buildTextField(
                        //     'Machine Life in Years (L) (Yrs)',
                        //     _machineLifeController,
                        //     TextInputType.number,
                        //     _validateInput),
                        // _buildTextField(
                        //     'Salvage Value (S) (Rs)',
                        //     _salvageValueController,
                        //     TextInputType.number,
                        //     _validateInput),
                        // // Power Consumption & Power Cost only if selectedMachineId == 1
                        // if (selectedMachineId == '1') ...[
                        //   _buildTextField(
                        //       'Power Consumption per Hour (PC) (Kw)',
                        //       _powerConsumptionController,
                        //       TextInputType.number,
                        //       _validateInput),
                        //   _buildTextField(
                        //       'Power Cost per Unit (PU) (Rs)',
                        //       _powerCostController,
                        //       TextInputType.number,
                        //       _validateInput),
                        // ],
                        // // Fuel Cost only if selectedMachineId == 2
                        // if (selectedMachineId == '2')
                        //   _buildTextField(
                        //       'Fuel Cost (PH) (Rs)',
                        //       _fuelCostController,
                        //       TextInputType.number,
                        //       _validateInput),
                        // _buildTextField(
                        //     'Operator Wage per Hour (OW) (Rs)',
                        //     _operatorWageController,
                        //     TextInputType.number,
                        //     _validateInput),
                        // _buildTextField(
                        //     'Consumables Cost per Year (CC) (Rs)',
                        //     _consumableCostController,
                        //     TextInputType.number,
                        //     _validateInput),
                        // _buildTextField(
                        //     'Factory Rent/Overheads per Year (RA) (Rs)',
                        //     _factoryRentController,
                        //     TextInputType.number,
                        //     _validateInput),
                        // _buildTextField(
                        //     'Operating Hours per Day (H) (Hr)',
                        //     _operatingHoursController,
                        //     TextInputType.number,
                        //     _validateInput),
                        // _buildTextField(
                        //     'Working Days per Year (D) (Days))',
                        //     _workingDaysController,
                        //     TextInputType.number,
                        //     _validateInput),
                        _buildTextField(
                          'Maintenance Cost per Year (MC) (Rs)',
                          _maintenanceCostController,
                          TextInputType.number,
                          _validateInput,
                          focusNode: _maintenanceCostFocusNode,
                          nextFocusNode: _machinePriceFocusNode,
                        ),
                        _buildTextField(
                          'Machine Purchase Price (MP) (Rs)',
                          _machinePriceController,
                          TextInputType.number,
                          _validateInput,
                          focusNode: _machinePriceFocusNode,
                          nextFocusNode: _machineLifeFocusNode,
                        ),
                        _buildTextField(
                          'Machine Life in Years (L) (Yrs)',
                          _machineLifeController,
                          TextInputType.number,
                          _validateInput,
                          focusNode: _machineLifeFocusNode,
                          nextFocusNode: _salvageValueFocusNode,
                        ),
                        _buildTextField(
                          'Salvage Value (S) (Rs)',
                          _salvageValueController,
                          TextInputType.number,
                          _validateInput,
                          focusNode: _salvageValueFocusNode,
                          nextFocusNode: _powerConsumptionFocusNode,
                        ),
                        if (selectedMachineId == '1') ...[
                          _buildTextField(
                            'Power Consumption per Hour (PC) (Kw)',
                            _powerConsumptionController,
                            TextInputType.number,
                            _validateInput,
                            focusNode: _powerConsumptionFocusNode,
                            nextFocusNode: _powerCostFocusNode,
                          ),
                          _buildTextField(
                            'Power Cost per Unit (PU) (Rs)',
                            _powerCostController,
                            TextInputType.number,
                            _validateInput,
                            focusNode: _powerCostFocusNode,
                          ),
                        ],
                        if (selectedMachineId == '2')
                          _buildTextField(
                            'Fuel Cost (PH) (Rs)',
                            _fuelCostController,
                            TextInputType.number,
                            _validateInput,
                            focusNode: _fuelCostFocusNode,
                          ),
                        _buildTextField(
                          'Operator Wage per Hour (OW) (Rs)',
                          _operatorWageController,
                          TextInputType.number,
                          _validateInput,
                          focusNode: _operatorWageFocusNode,
                          nextFocusNode: _consumableCostFocusNode,
                        ),
                        _buildTextField(
                          'Consumables Cost per Year (CC) (Rs)',
                          _consumableCostController,
                          TextInputType.number,
                          _validateInput,
                          focusNode: _consumableCostFocusNode,
                          nextFocusNode: _factoryRentFocusNode,
                        ),
                        _buildTextField(
                          'Factory Rent/Overheads per Year (RA) (Rs)',
                          _factoryRentController,
                          TextInputType.number,
                          _validateInput,
                          focusNode: _factoryRentFocusNode,
                          nextFocusNode: _operatingHoursFocusNode,
                        ),
                        _buildTextField(
                          'Operating Hours per Day (H) (Hr)',
                          _operatingHoursController,
                          TextInputType.number,
                          _validateInput,
                          focusNode: _operatingHoursFocusNode,
                          nextFocusNode: _workingDaysFocusNode,
                        ),
                        _buildTextField(
                          'Working Days per Year (D) (Days))',
                          _workingDaysController,
                          TextInputType.number,
                          _validateInput,
                          focusNode: _workingDaysFocusNode,
                        ),
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
                    // Icon(Icons.calculate, color: Colors.white),
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

  Widget _buildCurrency() {
    return _buildStyledDropdown(
      'Select Currency',
      currencyList,
      selectedCurrency,
      (String? name) async {
        if (name != null) {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          CurrencyModel selecteed =
              currencyList.firstWhere((e) => "${e.name} - ${e.amount}" == name);
          await prefs.setString('selectedCurrency', name);
          await prefs.setString('selectedCurrencyId', selecteed.id);
          await prefs.setString('selectedCurrencyAmountName', selecteed.name);
          await prefs.setString('selectedCurrencyName', selecteed.amount);
          setState(() {
            selectedCurrency = name;
          });
          if (kDebugMode) {
            print(
                "-------Currency Id---------${prefs.getString('selectedCurrencyId')}");
          }
          if (kDebugMode) {
            print(
                "-------Currency name---------${prefs.getString('selectedCurrencyAmountName')}");
          }
          if (kDebugMode) {
            print(
                "-------Currency amount---------${prefs.getString('selectedCurrencyName')}");
          }
        }
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Currency selection is required';
        }
        return null;
      },
    );
  }

  Widget _buildMachine() {
    return _buildStyledDropdowns(
      'Select Main Machine',
      machineList,
      selectedMachine,
      (String? name) async {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        if (name != null) {
          MainMachineModel selected =
              machineList.firstWhere((e) => e.name == name);
          await prefs.setString('selectedMainMachineId', selected.id);
          await prefs.setString('selectedMainMachineName', selected.name);
          setState(() {
            selectedMachine = name;
            selectedMachineId = selected.id;
            selectedCategory = null;
            selectedSubCategory = null;
            // _powerConsumptionController.clear();
            // _powerCostController.clear();
            // _fuelCostController.clear();
            categoryList.clear();
            subcategoryList.clear();
          });
          if (kDebugMode) {
            print(
                "-----Main Machine Id-------${prefs.getString('selectedMainMachineId')}");
          }
          if (kDebugMode) {
            print(
                "-------Main Machine name--------${prefs.getString('selectedMainMachineName')}");
          }
          fetchCategoryData();
        }
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Main machine selection is required';
        }
        return null;
      },
    );
  }

  Widget _buildMachineCate() {
    return _buildStyledDropdownss(
      'Select Machine Categories',
      categoryList,
      selectedCategory,
      (String? name) async {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        if (name != null) {
          MachineCatModel selected =
              categoryList.firstWhere((e) => e.name == name);
          await prefs.setString('selectedMachinecatId', selected.id);
          await prefs.setString('selectedMachinecatName', selected.name);
          setState(() {
            selectedCategory = name;
            selectedSubCategory = null;
            subcategoryList.clear();
          });
          if (kDebugMode) {
            print(
                "-----Machine categories Id-------${prefs.getString('selectedMachinecatId')}");
          }
          if (kDebugMode) {
            print(
                "-------Machine Categories Name--------${prefs.getString('selectedMainMachineName')}");
          }
          if (kDebugMode) {
            print(
                "-----Main---Machine Id--------${prefs.getString('selectedMainMachineId')}");
          }
          fetchSubCategories();
          if (kDebugMode) {
            print(
                "Selected Machine cat id: ${prefs.getString('selectedMachinecatId')}");
          }
        }
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Machine categories selection is required';
        }
        return null;
      },
    );
  }

  Widget _buildMachineSub() {
    return _buildStyledDropdowne(
      'Select Machine SubCategories',
      subcategoryList,
      selectedSubCategory,
      (String? name) async {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        if (name != null) {
          MachineSubCatModel selected =
              subcategoryList.firstWhere((e) => e.name == name);
          await prefs.setString('selectedMachinesubcatId', selected.id);
          await prefs.setString('selectedMachinesubcatName', selected.name);
          setState(() {
            selectedSubCategory = name;
          });
          if (kDebugMode) {
            print(selected.id);
          }
          if (kDebugMode) {
            print(selected.name);
          }
          if (kDebugMode) {
            print(
                "Selected Machine SubCategory ID: ${prefs.getString('selectedMachinecatId')}");
          }
        }
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Machine subcategories selection is required';
        }
        return null;
      },
    );
  }

  Widget _buildStyledDropdown(String hint, List<CurrencyModel> options,
      String? selectedValue, Function(String?) onChanged,
      {required String? Function(dynamic value) validator}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: DropdownButtonFormField<String>(
        isExpanded: true,
        value: selectedValue,
        validator: validator,
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
          suffixIcon: selectedValue != null && selectedValue.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.close, color: Colors.red),
                  onPressed: () async {
                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    await prefs.remove('selectedCurrency');
                    await prefs.remove('selectedCurrencyId');
                    await prefs.remove('selectedCurrencyAmountName');
                    await prefs.remove('selectedCurrencyName');
                    setState(() {
                      selectedCurrency = null;
                    });
                    if (kDebugMode) {
                      print("Currency selection cleared");
                    }
                  },
                )
              : null,
        ),
        items: options
            .map((currency) => DropdownMenuItem<String>(
                  value: "${currency.name} - ${currency.amount}",
                  child: Text("${currency.name} - ${currency.amount}",
                      style: const TextStyle(fontSize: 16)),
                ))
            .toList(),
        onChanged: onChanged,
        hint: Text(hint,
            style: const TextStyle(fontSize: 16, color: Colors.grey)),
      ),
    );
  }

  Widget _buildStyledDropdowns(String hint, List<MainMachineModel> options,
      String? selectedValue, Function(String?) onChanged,
      {required String? Function(dynamic value) validator}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: DropdownButtonFormField<String>(
        isExpanded: true,
        value: selectedValue,
        validator: validator,
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
          suffixIcon: selectedValue != null && selectedValue.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.close, color: Colors.red),
                  onPressed: () async {
                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    await prefs.remove('selectedMainMachineId');
                    await prefs.remove('selectedMainMachineName');
                    await prefs.remove('selectedCategoryId');
                    await prefs.remove('selectedCategoryName');
                    await prefs.remove('selectedSubCategoryId');
                    await prefs.remove('selectedSubCategoryName');
                    setState(() {
                      selectedMachine = null;
                      selectedMachineId = null;
                      selectedCategory = null;
                      selectedSubCategory = null;
                      _powerConsumptionController.clear();
                      _powerCostController.clear();
                      _fuelCostController.clear();
                      categoryList.clear();
                      subcategoryList.clear();
                    });

                    if (kDebugMode) {
                      print("Main Machine selection cleared");
                    }
                  },
                )
              : null,
        ),
        items: options
            .map((machine) => DropdownMenuItem<String>(
                  value: machine.name,
                  child:
                      Text(machine.name, style: const TextStyle(fontSize: 16)),
                ))
            .toList(),
        onChanged: onChanged,
        hint: Text(hint,
            style: const TextStyle(fontSize: 16, color: Colors.grey)),
      ),
    );
  }

  Widget _buildStyledDropdownss(String hint, List<MachineCatModel> options,
      String? selectedValue, Function(String?) onChanged,
      {required String? Function(dynamic value) validator}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: DropdownButtonFormField<String>(
        isExpanded: true,
        value: selectedValue,
        validator: validator,
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
          suffixIcon: selectedValue != null && selectedValue.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.close, color: Colors.red),
                  onPressed: () async {
                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    await prefs.remove('selectedMachinecatId');
                    await prefs.remove('selectedMachinecatName');
                    await prefs.remove('selectedSubCategoryId');
                    await prefs.remove('selectedSubCategoryName');
                    setState(() {
                      selectedCategory = null;
                      selectedSubCategory = null;
                      subcategoryList.clear();
                    });
                    if (kDebugMode) {
                      print("Categories selection cleared");
                    }
                  },
                )
              : null,
        ),
        items: options
            .map((machines) => DropdownMenuItem<String>(
                  value: machines.name,
                  child:
                      Text(machines.name, style: const TextStyle(fontSize: 16)),
                ))
            .toList(),
        onChanged: onChanged,
        hint: Text(hint,
            style: const TextStyle(fontSize: 16, color: Colors.grey)),
      ),
    );
  }

  Widget _buildStyledDropdowne(String hint, List<MachineSubCatModel> options,
      String? selectedValue, Function(String?) onChanged,
      {required String? Function(dynamic value) validator}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: DropdownButtonFormField<String>(
        isExpanded: true,
        value: selectedValue,
        validator: validator,
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
          suffixIcon: selectedValue != null && selectedValue.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.close, color: Colors.red),
                  onPressed: () async {
                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    await prefs.remove('selectedMachinesubcatId');
                    await prefs.remove('selectedMachinesubcatName');
                    setState(() {
                      selectedSubCategory = null;
                    });
                    if (kDebugMode) {
                      print("SubCategories selection cleared");
                    }
                  },
                )
              : null,
        ),
        items: options
            .map((subcat) => DropdownMenuItem<String>(
                  value: subcat.name,
                  child: Container(
                      color: Colors.white,
                      child: Text(subcat.name,
                          style: const TextStyle(fontSize: 16))),
                ))
            .toList(),
        onChanged: onChanged,
        hint: Text(hint,
            style: const TextStyle(fontSize: 16, color: Colors.grey)),
        selectedItemBuilder: (BuildContext context) {
          return options.map<Widget>((MachineSubCatModel subcat) {
            return SizedBox(
                width: 80, // Set your desired width here
                child: Text(
                  selectedValue ?? hint,
                  style: const TextStyle(fontSize: 16),
                ));
          }).toList();
        },
      ),
    );
  }

  Widget _buildTextField(String labelText, TextEditingController controller,
      TextInputType keyboardType, String? Function(String?) validator,
      {FocusNode? focusNode, FocusNode? nextFocusNode}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        focusNode: focusNode,
        cursorColor: Colors.blue,
        cursorErrorColor: Colors.blue,
        onFieldSubmitted: (value) {
          if (nextFocusNode != null) {
            FocusScope.of(context).requestFocus(nextFocusNode);
          } else {
            FocusScope.of(context).unfocus();
          }
        },
        validator: (value) {
          String? errorMessage = validator(value);
          if (errorMessage == null &&
              value != null &&
              double.tryParse(value) != null) {
            if (double.parse(value) < 0) {
              return 'Negative values are not allowed';
            }
          }
          return errorMessage;
        },
        decoration: InputDecoration(
          labelText: labelText,
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
            borderSide: BorderSide(color: Colors.blue, width: 2.5),
          ),
          errorStyle: const TextStyle(color: Colors.red, fontSize: 14),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
      ),
    );
  }

  void _calculateMHR() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (_formKey.currentState!.validate() &&
        selectedCategory != null &&
        selectedSubCategory != null) {
      final provider = Provider.of<CalculationProvider>(context, listen: false);
      String? selectedMainCatId = prefs.getString('selectedMainMachineId');
      Map<String, dynamic> requestData = {
        "main_cat_id": selectedMainCatId,
        "maintanance_cost": _maintenanceCostController.text.isNotEmpty
            ? _maintenanceCostController.text
            : '0',
        "machine_purchase_price": _machinePriceController.text.isNotEmpty
            ? _machinePriceController.text
            : '0',
        "machine_life": _machineLifeController.text.isNotEmpty
            ? _machineLifeController.text
            : '0',
        "salvage_value": _salvageValueController.text.isNotEmpty
            ? _salvageValueController.text
            : '0',
        "operator_wage": _operatorWageController.text.isNotEmpty
            ? _operatorWageController.text
            : '0',
        "consumable_cost": _consumableCostController.text.isNotEmpty
            ? _consumableCostController.text
            : '0',
        "factory_rent": _factoryRentController.text.isNotEmpty
            ? _factoryRentController.text
            : '0',
        "operating_hours": _operatingHoursController.text.isNotEmpty
            ? _operatingHoursController.text
            : '0',
        "working_days": _workingDaysController.text.isNotEmpty
            ? _workingDaysController.text
            : '0',
      };
      if (selectedMainCatId == '1') {
        // Category 1 fields
        requestData["currency_id"] = prefs.getString('selectedCurrencyId');
        requestData["power_consumption"] =
            _powerConsumptionController.text.isNotEmpty
                ? _powerConsumptionController.text
                : '0';
        requestData["power_cost"] = _powerCostController.text.isNotEmpty
            ? _powerCostController.text
            : '0';
      } else if (selectedMainCatId == '2') {
        requestData["currency_id"] = prefs.getString('selectedCurrencyId');
        // Category 2 fields
        requestData["fuel_cost_per_hour"] = _fuelCostController.text.isNotEmpty
            ? _fuelCostController.text
            : '0';
      }
      //  Print data
      if (kDebugMode) {
        print("Request Data: $requestData");
      }
      // Save input values
      requestData.forEach((key, value) async {
        await prefs.setString(key, value.toString());
      });
      try {
        await provider.calculateMHR(requestData);
        if (provider.calculationResult != null) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MHRCalculatorScreen(),
            ),
          );
        } else {
          if (kDebugMode) {
            print("Calculation resulted in null.");
          }
        }
      } catch (error) {
        if (kDebugMode) {
          print("Error fetching calculation: $error");
        }
      }
    } else {
      if (kDebugMode) {
        print("Please fill all required fields correctly.");
      }
    }
  }
}

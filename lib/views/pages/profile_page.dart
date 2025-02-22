

  // @override
  // Widget build(BuildContext context) {
  //   // final authProvider = Provider.of<AuthProvider>(context);
  //   return Scaffold(
  //     backgroundColor: Colors.white,
  //     body: Column(
  //       children: [
  //         Padding(
  //           padding: EdgeInsets.only(
  //             bottom: MediaQuery.of(context).viewInsets.bottom,
  //             top: 16,
  //             left: 16,
  //             right: 16,
  //           ),
  //           child: SingleChildScrollView(
  //             child: Form(
  //               key: _formKey,
  //               child: Column(
  //                 mainAxisSize: MainAxisSize.min,
  //                 children: [
  //                   // const Text(
  //                   //   'NEW CALCULATION',
  //                   //   style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
  //                   // ),
  //                   // const SizedBox(height: 10),
  //                   _buildDropdown(), // Currency selection
  //                   _buildMachineTypeDropdown(), // Machine Type Dropdown
  //                   _buildMachineDropdowns(), // Machine Name Dropdown
  //                   // _buildMachineDropdown(), // Machine Name Dropdown
  //                   _buildMachineWaysCategoryDropdown(), // Machine Ways Categories Dropdown
  //                   const Row(
  //                     mainAxisAlignment: MainAxisAlignment.start,
  //                     children: [
  //                       Text(
  //                         'Machine Cost Factors',
  //                         style: TextStyle(
  //                             fontSize: 20, fontWeight: FontWeight.bold),
  //                       ),
  //                     ],
  //                   ),
  //                   const SizedBox(height: 10),
  //                   _buildTextField(
  //                     'Machine Purchase Price (MP) (Rs)',
  //                     _powerConsumptionController,
  //                     TextInputType.number,
  //                     (value) {
  //                       if (value == null || value.isEmpty) {
  //                         return 'Power consumption is required';
  //                       }
  //                       if (double.tryParse(value) == null) {
  //                         return 'Enter a valid number';
  //                       }
  //                       return null;
  //                     },
  //                   ),
  //                   _buildTextField(
  //                     'Machine Life in Years (L) (Yrs)',
  //                     _laborCostController,
  //                     TextInputType.number,
  //                     (value) {
  //                       if (value == null || value.isEmpty) {
  //                         return 'Labor cost is required';
  //                       }
  //                       if (double.tryParse(value) == null) {
  //                         return 'Enter a valid amount';
  //                       }
  //                       return null;
  //                     },
  //                   ),
  //                   _buildTextField(
  //                     'Salvage Value (S) (Rs)',
  //                     _maintenanceExpensesController,
  //                     TextInputType.number,
  //                     (value) {
  //                       if (value == null || value.isEmpty) {
  //                         return 'Maintenance cost is required';
  //                       }
  //                       if (double.tryParse(value) == null) {
  //                         return 'Enter a valid amount';
  //                       }
  //                       return null;
  //                     },
  //                   ),
  //                   const Row(
  //                     mainAxisAlignment: MainAxisAlignment.start,
  //                     children: [
  //                       Text(
  //                         'Operating Costs',
  //                         style: TextStyle(
  //                             fontSize: 20, fontWeight: FontWeight.bold),
  //                       ),
  //                     ],
  //                   ),
  //                   const SizedBox(height: 10),
  //                   _buildTextField(
  //                     'Power Consumption per Hour (PC) (Kw)',
  //                     _maintenanceExpensesController,
  //                     TextInputType.number,
  //                     (value) {
  //                       if (value == null || value.isEmpty) {
  //                         return 'Maintenance cost is required';
  //                       }
  //                       if (double.tryParse(value) == null) {
  //                         return 'Enter a valid amount';
  //                       }
  //                       return null;
  //                     },
  //                   ),
  //                   _buildTextField(
  //                     'Power Cost per Unit (PU) (Rs)',
  //                     _maintenanceExpensesController,
  //                     TextInputType.number,
  //                     (value) {
  //                       if (value == null || value.isEmpty) {
  //                         return 'Maintenance cost is required';
  //                       }
  //                       if (double.tryParse(value) == null) {
  //                         return 'Enter a valid amount';
  //                       }
  //                       return null;
  //                     },
  //                   ),
  //                   _buildTextField(
  //                     'Operator Wage per Hour (OW) (Rs)',
  //                     _maintenanceExpensesController,
  //                     TextInputType.number,
  //                     (value) {
  //                       if (value == null || value.isEmpty) {
  //                         return 'Maintenance cost is required';
  //                       }
  //                       if (double.tryParse(value) == null) {
  //                         return 'Enter a valid amount';
  //                       }
  //                       return null;
  //                     },
  //                   ),
  //                   _buildTextField(
  //                     'Maintenance Cost per Year (MC) (Rs)',
  //                     _maintenanceExpensesController,
  //                     TextInputType.number,
  //                     (value) {
  //                       if (value == null || value.isEmpty) {
  //                         return 'Maintenance cost is required';
  //                       }
  //                       if (double.tryParse(value) == null) {
  //                         return 'Enter a valid amount';
  //                       }
  //                       return null;
  //                     },
  //                   ),
  //                   _buildTextField(
  //                     'Consumables Cost per Year (CC) (Rs)',
  //                     _maintenanceExpensesController,
  //                     TextInputType.number,
  //                     (value) {
  //                       if (value == null || value.isEmpty) {
  //                         return 'Maintenance cost is required';
  //                       }
  //                       if (double.tryParse(value) == null) {
  //                         return 'Enter a valid amount';
  //                       }
  //                       return null;
  //                     },
  //                   ),
  //                   _buildTextField(
  //                     'Factory Rent/Overheads per Year (RA) (Rs)',
  //                     _maintenanceExpensesController,
  //                     TextInputType.number,
  //                     (value) {
  //                       if (value == null || value.isEmpty) {
  //                         return 'Maintenance cost is required';
  //                       }
  //                       if (double.tryParse(value) == null) {
  //                         return 'Enter a valid amount';
  //                       }
  //                       return null;
  //                     },
  //                   ),
  //                   const Row(
  //                     mainAxisAlignment: MainAxisAlignment.start,
  //                     children: [
  //                       Text(
  //                         'Working Hours',
  //                         style: TextStyle(
  //                             fontSize: 20, fontWeight: FontWeight.bold),
  //                       ),
  //                     ],
  //                   ),
  //                   const SizedBox(height: 10),
  //                   _buildTextField(
  //                     'Operating Hours per Day (H) (Hr)',
  //                     _maintenanceExpensesController,
  //                     TextInputType.number,
  //                     (value) {
  //                       if (value == null || value.isEmpty) {
  //                         return 'Maintenance cost is required';
  //                       }
  //                       if (double.tryParse(value) == null) {
  //                         return 'Enter a valid amount';
  //                       }
  //                       return null;
  //                     },
  //                   ),
  //                   _buildTextField(
  //                     'Working Days per Year (D) (Days))',
  //                     _maintenanceExpensesController,
  //                     TextInputType.number,
  //                     (value) {
  //                       if (value == null || value.isEmpty) {
  //                         return 'Maintenance cost is required';
  //                       }
  //                       if (double.tryParse(value) == null) {
  //                         return 'Enter a valid amount';
  //                       }
  //                       return null;
  //                     },
  //                   ),
  //                   // const SizedBox(height: 20),
  //                   // ElevatedButton(
  //                   //   style: ElevatedButton.styleFrom(
  //                   //     backgroundColor: kButtonColor,
  //                   //     shape: RoundedRectangleBorder(
  //                   //       borderRadius: BorderRadius.circular(12),
  //                   //     ),
  //                   //     padding: const EdgeInsets.symmetric(
  //                   //         horizontal: 100, vertical: 15),
  //                   //   ),
  //                   //   onPressed: _calculateMHR,
  //                   //   child: const Row(
  //                   //     mainAxisSize: MainAxisSize.min,
  //                   //     children: [
  //                   //       Icon(Icons.calculate, color: Colors.white),
  //                   //       SizedBox(width: 8),
  //                   //       Text('CALCULATE', style: TextStyle(color: Colors.white)),
  //                   //     ],
  //                   //   ),
  //                   // ),
  //                   // const SizedBox(height: 20),
  //                 ],
  //               ),
  //             ),
  //           ),
  //         ),
  //         Container(
  //           width: double.infinity,
  //           padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
  //           color: Colors.white, // Background color for button section
  //           child: ElevatedButton(
  //             style: ElevatedButton.styleFrom(
  //               backgroundColor: kButtonColor,
  //               shape: RoundedRectangleBorder(
  //                 borderRadius: BorderRadius.circular(12),
  //               ),
  //               padding:
  //                   const EdgeInsets.symmetric(horizontal: 100, vertical: 15),
  //             ),
  //             onPressed: _calculateMHR,
  //             child: const Row(
  //               mainAxisSize: MainAxisSize.min,
  //               children: [
  //                 Icon(Icons.calculate, color: Colors.white),
  //                 SizedBox(width: 8),
  //                 Text('CALCULATE', style: TextStyle(color: Colors.white)),
  //               ],
  //             ),
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  // Widget _buildCurrencyDropdown() {
  //   return _buildStyledDropdown(
  //     'Select your currency',
  //     ['USD (\$)', 'INR (₹)'],
  //     selectedCurrency,
  //     (value) => setState(() => selectedCurrency = value),
  //   );
  // }

  // Widget _buildMachineTypeDropdown() {
  //   return _buildStyledDropdown(
  //     'Select Machine Type',
  //     [
  //       'Industry',
  //       'Others',
  //     ],
  //     selectedMachineName,
  //     (value) => setState(() => selectedMachineName = value),
  //   );
  // }//

  // Widget _buildMachineDropdown() {
  //   return Consumer<AuthProvider>(
  //     builder: (context, provider, child) {
  //       if (provider.isLoading) {
  //         return const CircularProgressIndicator(); // Show loading indicator
  //       }

  //       if (provider.categories.isEmpty) {
  //         return const Text(
  //             "No categories available"); // Show message if no data
  //       }

  //       return _buildStyledDropdown(
  //         'Select Machine Categorys',
  //         provider.categories
  //             .map((category) => category["name"]! as String)
  //             .toList(),
  //         selectedMachineName,
  //         (value) => setState(() => selectedMachineName = value),
  //       );
  //     },
  //   );
  // }

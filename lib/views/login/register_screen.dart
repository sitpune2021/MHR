// // ignore_for_file: use_build_context_synchronously

// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:machine_hour_rate/core/theme/colors.dart';
// import 'package:machine_hour_rate/providers/auth_provider.dart';
// import 'package:machine_hour_rate/views/home/home_screen.dart';
// import 'package:machine_hour_rate/views/login/login_screen.dart';
// import 'package:country_picker/country_picker.dart';
// import 'package:provider/provider.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class RegisterScreen extends StatefulWidget {
//   const RegisterScreen({super.key});

//   @override
//   State<RegisterScreen> createState() => _RegisterScreenState();
// }

// class _RegisterScreenState extends State<RegisterScreen> {
//   final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
//   final TextEditingController _firstNameController = TextEditingController();
//   final TextEditingController _lastNameController = TextEditingController();
//   final TextEditingController _mobileController = TextEditingController();
//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();

//   String? _selectedCountryCode = '+1';

//   @override
//   void dispose() {
//     _firstNameController.dispose();
//     _lastNameController.dispose();
//     _mobileController.dispose();
//     _emailController.dispose();
//     _passwordController.dispose();
//     super.dispose();
//   }

//   Future<void> _continueAsGuest() async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.setBool('isGuest', true);
//     Navigator.pushReplacement(
//       context,
//       MaterialPageRoute(builder: (context) => const HomeScreen()),
//     );
//   }

//   Future<void> _registerUser(BuildContext context) async {
//     if (_formKey.currentState!.validate()) {
//       final authProvider = Provider.of<AuthProvider>(context, listen: false);

//       String? errorMessage = await authProvider.registerUser(
//         firstName: _firstNameController.text.trim(),
//         lastName: _lastNameController.text.trim(),
//         mobile: _mobileController.text.trim(),
//         email: _emailController.text.trim(),
//         password: _passwordController.text.trim(),
//       );

//       if (errorMessage == null) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('Registered Successfully')),
//         );
//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(builder: (context) => const HomeScreen()),
//         );
//       } else {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text(errorMessage)),
//         );
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final authProvider = Provider.of<AuthProvider>(context);
//     final isLoading = authProvider.isLoading;
//     final validationErrors = authProvider.validationErrors;
//     return Scaffold(
//       resizeToAvoidBottomInset: false,
//       body: Center(
//         child: GestureDetector(
//           onTap: () => FocusScope.of(context).unfocus(),
//           child: SingleChildScrollView(
//             physics: const ClampingScrollPhysics(),
//             child: Padding(
//               padding: const EdgeInsets.all(14.0),
//               child: Form(
//                 key: _formKey,
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: <Widget>[
//                     Image.asset('assets/logo.png', height: 100),
//                     const SizedBox(height: 20),
//                     _buildFirstField('First Name', _firstNameController, false,
//                         _nameValidator),
//                     _buildLastField('Last Name', _lastNameController, false,
//                         _nameValidator),
//                     _buildMobileNumberField(),
//                     _buildEmailField(
//                         'Email', _emailController, false, _emailValidator),
//                     _buildPassField('Password', _passwordController, true,
//                         _passwordValidator),
//                     const SizedBox(height: 20),
//                     _buildRegisterButton(),
//                     TextButton(
//                       onPressed: () {
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                               builder: (context) => const LoginScreen()),
//                         );
//                       },
//                       child: const Text('Already have an account? Login',
//                           style: TextStyle(color: Colors.green)),
//                     ),
//                     TextButton(
//                       onPressed: _continueAsGuest,
//                       child: const Text('Continue as Guest user',
//                           style: TextStyle(color: Colors.blue)),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildFirstField(String label, TextEditingController controller,
//       bool isPassword, String? Function(String?) validator) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 8.0),
//       child: TextFormField(
//         controller: controller,
//         enableSuggestions: true,
//         autocorrect: true,
//         decoration: InputDecoration(
//           labelText: label,
//           border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
//         ),
//         validator: validator,
//       ),
//     );
//   }

//   Widget _buildLastField(String label, TextEditingController controller,
//       bool isPassword, String? Function(String?) validator) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 8.0),
//       child: TextFormField(
//         controller: controller,
//         decoration: InputDecoration(
//           labelText: label,
//           border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
//         ),
//         validator: validator,
//       ),
//     );
//   }

//   Widget _buildEmailField(String label, TextEditingController controller,
//       bool isPassword, String? Function(String?) validator) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 8.0),
//       child: TextFormField(
//         controller: controller,
//         decoration: InputDecoration(
//           labelText: label,
//           border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
//         ),
//         validator: validator,
//       ),
//     );
//   }

//   Widget _buildPassField(String label, TextEditingController controller,
//       bool isPassword, String? Function(String?) validator) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 8.0),
//       child: TextFormField(
//         controller: controller,
//         obscureText: isPassword,
//         decoration: InputDecoration(
//           labelText: label,
//           border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
//           suffixIcon: IconButton(
//             icon: Icon(
//               isPassword ? Icons.visibility : Icons.visibility_off_sharp,
//             ),
//             onPressed: () {
//               setState(() {
//                 isPassword = !isPassword;
//               });
//             },
//           ),
//         ),
//         validator: validator,
//       ),
//     );
//   }

//   Widget _buildMobileNumberField() {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 8.0),
//       child: Row(
//         children: [
//           GestureDetector(
//             onTap: _showCountryPicker,
//             child: Container(
//               padding:
//                   const EdgeInsets.symmetric(horizontal: 12.0, vertical: 14.0),
//               decoration: BoxDecoration(
//                 border: Border.all(color: Colors.grey),
//                 borderRadius: BorderRadius.circular(10.0),
//               ),
//               child: Text(_selectedCountryCode ?? '+1'),
//             ),
//           ),
//           const SizedBox(width: 10),
//           Expanded(
//             child: TextFormField(
//               controller: _mobileController,
//               decoration: const InputDecoration(
//                 labelText: 'Mobile Number',
//                 border: OutlineInputBorder(),
//               ),
//               keyboardType: TextInputType.phone,
//               inputFormatters: [
//                 FilteringTextInputFormatter.digitsOnly,
//                 LengthLimitingTextInputFormatter(10),
//               ],
//               validator: _phoneValidator,
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   String? _nameValidator(String? value) {
//     if (value == null || value.trim().isEmpty) {
//       return 'This field is required';
//     }
//     return null;
//   }

//   String? _emailValidator(String? value) {
//     if (value == null || value.isEmpty) {
//       return 'Email is required';
//     }
//     if (!RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$')
//         .hasMatch(value)) {
//       return 'Please enter a valid email';
//     }
//     return null;
//   }

//   String? _passwordValidator(String? value) {
//     if (value == null || value.length < 8) {
//       return 'Password must be at least 8 characters';
//     }
//     return null;
//   }

//   String? _phoneValidator(String? value) {
//     if (value == null || value.length != 10) {
//       return 'Please enter a valid 10-digit phone number';
//     }
//     return null;
//   }

//   Widget _buildRegisterButton() {
//     return ElevatedButton(
//         onPressed: () => _registerUser(context),
//         style: ElevatedButton.styleFrom(
//           padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
//           backgroundColor: kButtonColor,
//           foregroundColor: Colors.black87,
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(10.0),
//           ),
//         ),
//         child: const Text(
//           'Register Now',
//           style: TextStyle(fontSize: 16),
//         ));
//   }

//   void _showCountryPicker() {
//     showCountryPicker(
//       context: context,
//       onSelect: (Country country) {
//         setState(() {
//           _selectedCountryCode = '+${country.phoneCode}';
//         });
//       },
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:machine_hour_rate/providers/auth_provider.dart';
import 'package:machine_hour_rate/views/home/home_screen.dart';
import 'package:machine_hour_rate/views/login/login_screen.dart';
import 'package:provider/provider.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _mobileController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _registerUser(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);

      String? errorMessage = await authProvider.registerUser(
        firstName: _firstNameController.text.trim(),
        lastName: _lastNameController.text.trim(),
        mobile: _mobileController.text.trim(),
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      if (errorMessage == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Registered Successfully')),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMessage)),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final isLoading = authProvider.isLoading;
    final validationErrors = authProvider.validationErrors;

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(14.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                Image.asset('assets/logo.png', height: 100),
                const SizedBox(height: 20),
                _buildTextField(
                  'First Name',
                  _firstNameController,
                  validationErrors?['first_name'],
                ),
                _buildTextField(
                  'Last Name',
                  _lastNameController,
                  validationErrors?['last_name'],
                ),
                _buildTextField(
                  'Mobile',
                  _mobileController,
                  validationErrors?['mobile'],
                  keyboardType: TextInputType.phone,
                ),
                _buildTextField(
                  'Email',
                  _emailController,
                  validationErrors?['email'],
                  keyboardType: TextInputType.emailAddress,
                ),
                _buildTextField(
                  'Password',
                  _passwordController,
                  validationErrors?['password'],
                  isPassword: true,
                ),
                const SizedBox(height: 20),
                isLoading
                    ? const CircularProgressIndicator()
                    : _buildRegisterButton(),
                TextButton(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const LoginScreen()),
                  ),
                  child: const Text('Already have an account? Login'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller,
    String? errorMessage, {
    bool isPassword = false,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        obscureText: isPassword,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          errorText: errorMessage,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
        ),
      ),
    );
  }

  Widget _buildRegisterButton() {
    return ElevatedButton(
      onPressed: () => _registerUser(context),
      child: const Text('Register Now'),
    );
  }
}

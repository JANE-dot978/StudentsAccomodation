// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

// import '../../core/utils/validators.dart';
// import '../../providers/user_provider.dart';
// import '../../widgets/app_name_text_widget.dart';
// import '../../widgets/loading_management.dart';
// import '../../widgets/subtittle_text_widget.dart';
// import '../../widgets/titles_text_widget.dart';
// import 'register_screen.dart';
// import '../../core/routes/app_routes.dart';

// class LoginScreen extends StatefulWidget {
//   static const routName = "/login";
//   const LoginScreen({super.key});

//   @override
//   State<LoginScreen> createState() => _LoginScreenState();
// }

// class _LoginScreenState extends State<LoginScreen> {
//   bool obscureText = true;
//   final _formkey = GlobalKey<FormState>();
//   bool _isLoading = false;

//   late final TextEditingController _emailController;
//   late final TextEditingController _passwordController;

//   late final FocusNode _emailFocusNode;
//   late final FocusNode _passwordFocusNode;

//   @override
//   void initState() {
//     super.initState();
//     _emailController = TextEditingController();
//     _passwordController = TextEditingController();
//     _emailFocusNode = FocusNode();
//     _passwordFocusNode = FocusNode();
//   }

//   @override
//   void dispose() {
//     _emailController.dispose();
//     _passwordController.dispose();
//     _emailFocusNode.dispose();
//     _passwordFocusNode.dispose();
//     super.dispose();
//   }

//   Future<void> _loginFct(BuildContext context) async {
//     final isValid = _formkey.currentState!.validate();
//     FocusScope.of(context).unfocus();
//     if (!isValid) return;

//     setState(() => _isLoading = true);

//     final userProvider = Provider.of<UserProvider>(context, listen: false);

//     try {
//       final errorMessage = await userProvider.login(
//         _emailController.text.trim(),
//         _passwordController.text.trim(),
//       );

//       if (errorMessage != null) {
//         if (mounted) {
//           ScaffoldMessenger.of(context)
//               .showSnackBar(SnackBar(content: Text(errorMessage)));
//         }
//         return;
//       }

//       final user = userProvider.getUser;
//       if (user != null && mounted) {
//         if (user.role == 'student' || user.role == 'user') {
//           Navigator.pushReplacementNamed(context, AppRoutes.studentHome);
//         } else if (user.role == 'landlord') {
//           Navigator.pushReplacementNamed(context, AppRoutes.landlordDashboard);
//         } else if (user.role == 'admin') {
//           Navigator.pushReplacementNamed(context, AppRoutes.adminDashboard);
//         }
//       }
//     } finally {
//       if (mounted) setState(() => _isLoading = false);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () => FocusScope.of(context).unfocus(),
//       child: Scaffold(
//         body: LoadngManager(
//           isLoading: _isLoading,
//           child: Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: SingleChildScrollView(
//               child: Column(
//                 children: [
//                   const SizedBox(height: 60),
//                   const AppNameTextWidget(fontSize: 30),
//                   const SizedBox(height: 16),
//                   const Align(
//                     alignment: Alignment.centerLeft,
//                     child: TitlesTextWidget(label: "Welcome back!"),
//                   ),
//                   const SizedBox(height: 16),
//                   Form(
//                     key: _formkey,
//                     child: Column(
//                       children: [
//                         TextFormField(
//                           controller: _emailController,
//                           focusNode: _emailFocusNode,
//                           keyboardType: TextInputType.emailAddress,
//                           textInputAction: TextInputAction.next,
//                           decoration: const InputDecoration(
//                             hintText: "Email address",
//                             prefixIcon: Icon(Icons.email),
//                           ),
//                           onFieldSubmitted: (_) {
//                             FocusScope.of(context).requestFocus(_passwordFocusNode);
//                           },
//                           validator: MyValidators.emailValidator,
//                         ),
//                         const SizedBox(height: 16),
//                         TextFormField(
//                           controller: _passwordController,
//                           focusNode: _passwordFocusNode,
//                           keyboardType: TextInputType.visiblePassword,
//                           textInputAction: TextInputAction.done,
//                           obscureText: obscureText,
//                           decoration: InputDecoration(
//                             hintText: "Password",
//                             prefixIcon: const Icon(Icons.lock),
//                             suffixIcon: IconButton(
//                               icon: Icon(
//                                   obscureText ? Icons.visibility : Icons.visibility_off),
//                               onPressed: () => setState(() => obscureText = !obscureText),
//                             ),
//                           ),
//                           onFieldSubmitted: (_) => _loginFct(context),
//                           validator: MyValidators.passwordValidator,
//                         ),
//                         const SizedBox(height: 16),
//                         Align(
//                           alignment: Alignment.centerRight,
//                           child: TextButton(
//                             onPressed: () {},
//                             child: const SubtitleTextWidget(label: "Forgot password?"),
//                           ),
//                         ),
//                         const SizedBox(height: 16),
//                         SizedBox(
//                           width: double.infinity,
//                           child: ElevatedButton.icon(
//                             icon: const Icon(Icons.login),
//                             label: const Text("Login"),
//                             onPressed: () => _loginFct(context),
//                           ),
//                         ),
//                         const SizedBox(height: 16),
//                         FittedBox(
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               const SubtitleTextWidget(label: "Don't have an account?"),
//                               TextButton(
//                                 onPressed: () {
//                                   Navigator.pushReplacementNamed(
//                                       context, AppRoutes.register);
//                                 },
//                                 child: const SubtitleTextWidget(label: "Create One"),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

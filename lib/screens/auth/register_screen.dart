// import 'dart:typed_data';
// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:http/http.dart' as http;

// import '../../models/user_model.dart';
// import '../../providers/user_provider.dart';
// import '../../widgets/loading_management.dart';
// import '../../widgets/pick_image_widget.dart';
// import '../../widgets/subtittle_text_widget.dart';
// import '../../widgets/titles_text_widget.dart';
// import '../../core/routes/app_routes.dart';
// import '../../core/utils/validators.dart';
// import '../../services/my_app_function.dart';

// class RegisterScreen extends StatefulWidget {
//   static const routName = "/register";
//   const RegisterScreen({super.key});

//   @override
//   State<RegisterScreen> createState() => _RegisterScreenState();
// }

// class _RegisterScreenState extends State<RegisterScreen> {
//   Uint8List? _pickedImageBytes;
//   String? _pickedImageName;
//   bool obscureText = true;
//   bool isLoading = false;
//   late String userImageUrl;
//   final _formkey = GlobalKey<FormState>();
//   final TextEditingController _nameController = TextEditingController();
//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();
//   final TextEditingController _repeatPasswordController = TextEditingController();
//   final FocusNode _nameFocusNode = FocusNode();
//   final FocusNode _emailFocusNode = FocusNode();
//   final FocusNode _passwordFocusNode = FocusNode();
//   final FocusNode _repeatPasswordFocusNode = FocusNode();
//   String role = 'user';

//   @override
//   void dispose() {
//     _nameController.dispose();
//     _emailController.dispose();
//     _passwordController.dispose();
//     _repeatPasswordController.dispose();
//     _nameFocusNode.dispose();
//     _emailFocusNode.dispose();
//     _passwordFocusNode.dispose();
//     _repeatPasswordFocusNode.dispose();
//     super.dispose();
//   }

//   Future<void> LocalImagePicker() async {
//     final picker = ImagePicker();
//     await MyAppFunctions.imagePickerDialog(
//       context: context,
//       cameraFCT: () async {
//         final image = await picker.pickImage(source: ImageSource.camera);
//         if (image != null) {
//           _pickedImageBytes = await image.readAsBytes();
//           _pickedImageName = image.name;
//           setState(() {});
//         }
//       },
//       galleryFCT: () async {
//         final image = await picker.pickImage(source: ImageSource.gallery);
//         if (image != null) {
//           _pickedImageBytes = await image.readAsBytes();
//           _pickedImageName = image.name;
//           setState(() {});
//         }
//       },
//       removeFCT: () async {
//         setState(() {
//           _pickedImageBytes = null;
//           _pickedImageName = null;
//         });
//       },
//     );
//   }

//   Future<String?> uploadImageToCloudinary(Uint8List imageBytes, String fileName) async {
//     const cloudName = 'dgppqmq3t';
//     const uploadPreset = 'studentaccomodations';

//     final url = Uri.parse('https://api.cloudinary.com/v1_1/$cloudName/image/upload');
//     final request = http.MultipartRequest('POST', url)
//       ..fields['upload_preset'] = uploadPreset
//       ..files.add(http.MultipartFile.fromBytes('file', imageBytes, filename: fileName));

//     final response = await request.send();
//     if (response.statusCode == 200) {
//       final respStr = await response.stream.bytesToString();
//       final data = jsonDecode(respStr);
//       return data['secure_url'];
//     }
//     return null;
//   }

//   Future<void> _registerFCT() async {
//     final isValid = _formkey.currentState!.validate();
//     FocusScope.of(context).unfocus();
//     if (!isValid) return;

//     if (_pickedImageBytes == null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Please select an image')),
//       );
//       return;
//     }

//     setState(() => isLoading = true);

//     try {
//       final userCred = await FirebaseAuth.instance.createUserWithEmailAndPassword(
//         email: _emailController.text.trim(),
//         password: _passwordController.text.trim(),
//       );

//       userImageUrl = await uploadImageToCloudinary(
//             _pickedImageBytes!,
//             _pickedImageName ?? 'profile.jpg',
//           ) ??
//           '';

//       if (userImageUrl.isEmpty) throw Exception('Image upload failed');

//       final newUser = UserModel(
//         uid: userCred.user!.uid,
//         email: _emailController.text.trim(),
//         username: _nameController.text.trim(),
//         role: role,
//         userCart: [],
//         userWish: [],
//         userImage: userImageUrl,
//         createdAt: Timestamp.now(),
//       );

//       await FirebaseFirestore.instance.collection('users').doc(newUser.uid).set(newUser.toMap());

//       if (mounted) {
//         Provider.of<UserProvider>(context, listen: false).setUser(newUser);
//       }

//       await userCred.user!.sendEmailVerification();

//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Registered! Verify your email before login.')),
//       );

//       Navigator.pushReplacementNamed(context, AppRoutes.login);
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Registration failed: $e')),
//       );
//     } finally {
//       if (mounted) setState(() => isLoading = false);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final size = MediaQuery.of(context).size;
//     return GestureDetector(
//       onTap: () => FocusScope.of(context).unfocus(),
//       child: Scaffold(
//         body: LoadngManager(
//           isLoading: isLoading,
//           child: Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: SingleChildScrollView(
//               child: Column(
//                 children: [
//                   const SizedBox(height: 60),
//                   const Text("studentsaccomodations"),
//                   const SizedBox(height: 30),
//                   const Align(
//                     alignment: Alignment.centerLeft,
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         TitlesTextWidget(label: "Welcome!"),
//                         SubtitleTextWidget(label: "Create your account", fontSize: 14),
//                       ],
//                     ),
//                   ),
//                   const SizedBox(height: 30),
//                   SizedBox(
//                     width: size.width * 0.3,
//                     height: size.width * 0.3,
//                     child: PickImageWidget(
//                       pickedImageBytes: _pickedImageBytes,
//                       onTap: LocalImagePicker,
//                     ),
//                   ),
//                   const SizedBox(height: 20),
//                   Form(
//                     key: _formkey,
//                     child: Column(
//                       children: [
//                         TextFormField(
//                           controller: _nameController,
//                           focusNode: _nameFocusNode,
//                           keyboardType: TextInputType.name,
//                           textInputAction: TextInputAction.next,
//                           decoration: const InputDecoration(
//                             hintText: "Full Name",
//                             prefixIcon: Icon(Icons.person),
//                           ),
//                           validator: MyValidators.displayNameValidator,
//                           onFieldSubmitted: (_) {
//                             FocusScope.of(context).requestFocus(_emailFocusNode);
//                           },
//                         ),
//                         const SizedBox(height: 16),
//                         TextFormField(
//                           controller: _emailController,
//                           focusNode: _emailFocusNode,
//                           keyboardType: TextInputType.emailAddress,
//                           textInputAction: TextInputAction.next,
//                           decoration: const InputDecoration(
//                             hintText: "Email",
//                             prefixIcon: Icon(Icons.email),
//                           ),
//                           validator: MyValidators.emailValidator,
//                           onFieldSubmitted: (_) {
//                             FocusScope.of(context).requestFocus(_passwordFocusNode);
//                           },
//                         ),
//                         const SizedBox(height: 16),
//                         TextFormField(
//                           controller: _passwordController,
//                           focusNode: _passwordFocusNode,
//                           keyboardType: TextInputType.visiblePassword,
//                           obscureText: obscureText,
//                           textInputAction: TextInputAction.next,
//                           decoration: InputDecoration(
//                             hintText: "Password",
//                             prefixIcon: const Icon(Icons.lock),
//                             suffixIcon: IconButton(
//                               icon: Icon(obscureText ? Icons.visibility : Icons.visibility_off),
//                               onPressed: () => setState(() => obscureText = !obscureText),
//                             ),
//                           ),
//                           validator: MyValidators.passwordValidator,
//                           onFieldSubmitted: (_) {
//                             FocusScope.of(context).requestFocus(_repeatPasswordFocusNode);
//                           },
//                         ),
//                         const SizedBox(height: 16),
//                         TextFormField(
//                           controller: _repeatPasswordController,
//                           focusNode: _repeatPasswordFocusNode,
//                           obscureText: obscureText,
//                           textInputAction: TextInputAction.done,
//                           decoration: InputDecoration(
//                             hintText: "Repeat Password",
//                             prefixIcon: const Icon(Icons.lock),
//                             suffixIcon: IconButton(
//                               icon: Icon(obscureText ? Icons.visibility : Icons.visibility_off),
//                               onPressed: () => setState(() => obscureText = !obscureText),
//                             ),
//                           ),
//                           validator: (value) => MyValidators.repeatPasswordValidator(
//                               value: value, password: _passwordController.text),
//                           onFieldSubmitted: (_) => _registerFCT(),
//                         ),
//                         const SizedBox(height: 30),
//                         SizedBox(
//                           width: double.infinity,
//                           child: ElevatedButton.icon(
//                             icon: const Icon(Icons.add),
//                             label: const Text("Sign Up"),
//                             onPressed: _registerFCT,
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

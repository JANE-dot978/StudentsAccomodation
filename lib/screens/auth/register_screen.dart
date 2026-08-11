import 'dart:typed_data';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

import '../../models/user_model.dart';
import '../../providers/user_provider.dart';
import '../../widgets/loading_management.dart';
import '../../core/routes/app_routes.dart';
import '../../core/utils/validators.dart';
import '../../services/my_app_function.dart';

// ✅ Same Neutral Professional Color Palette as Login
const kNavy = Color(0xFF1A237E);
const kSlate = Color(0xFF37474F);
const kTeal = Color(0xFF00695C);
const kLightGrey = Color(0xFFF5F6FA);
const kMidGrey = Color(0xFFECEFF1);

class RegisterScreen extends StatefulWidget {
  static const routName = "/register";
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  Uint8List? _pickedImageBytes;
  String? _pickedImageName;
  bool obscureText = true;
  bool obscureRepeatText = true;
  bool isLoading = false;
  late String userImageUrl;
  final _formkey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _repeatPasswordController =
      TextEditingController();
  final FocusNode _nameFocusNode = FocusNode();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();
  final FocusNode _repeatPasswordFocusNode = FocusNode();
  String role = 'user';

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _repeatPasswordController.dispose();
    _nameFocusNode.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    _repeatPasswordFocusNode.dispose();
    super.dispose();
  }

  Future<void> _localImagePicker() async {
    final picker = ImagePicker();
    await MyAppFunctions.imagePickerDialog(
      context: context,
      cameraFCT: () async {
        final image = await picker.pickImage(source: ImageSource.camera);
        if (image != null) {
          _pickedImageBytes = await image.readAsBytes();
          _pickedImageName = image.name;
          setState(() {});
        }
      },
      galleryFCT: () async {
        final image = await picker.pickImage(source: ImageSource.gallery);
        if (image != null) {
          _pickedImageBytes = await image.readAsBytes();
          _pickedImageName = image.name;
          setState(() {});
        }
      },
      removeFCT: () async {
        setState(() {
          _pickedImageBytes = null;
          _pickedImageName = null;
        });
      },
    );
  }

  Future<String?> uploadImageToCloudinary(
      Uint8List imageBytes, String fileName) async {
    const cloudName = 'dgppqmq3t';
    const uploadPreset = 'studentaccomodations';

    final url =
        Uri.parse('https://api.cloudinary.com/v1_1/$cloudName/image/upload');
    final request = http.MultipartRequest('POST', url)
      ..fields['upload_preset'] = uploadPreset
      ..files.add(http.MultipartFile.fromBytes(
        'file',
        imageBytes,
        filename: fileName,
      ));

    final response = await request.send();
    if (response.statusCode == 200) {
      final respStr = await response.stream.bytesToString();
      final data = jsonDecode(respStr);
      return data['secure_url'];
    }
    return null;
  }

  Future<void> _registerFCT() async {
    final isValid = _formkey.currentState!.validate();
    FocusScope.of(context).unfocus();
    if (!isValid) return;

    if (_pickedImageBytes == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Row(
            children: [
              Icon(Icons.warning_amber_rounded, color: Colors.white),
              SizedBox(width: 8),
              Text('Please select a profile picture'),
            ],
          ),
          backgroundColor: Colors.orange.shade700,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
      return;
    }

    setState(() => isLoading = true);

    try {
      final userCred =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      userImageUrl = await uploadImageToCloudinary(
            _pickedImageBytes!,
            _pickedImageName ?? 'profile.jpg',
          ) ??
          '';

      if (userImageUrl.isEmpty) throw Exception('Image upload failed');

      final newUser = UserModel(
        uid: userCred.user!.uid,
        email: _emailController.text.trim(),
        username: _nameController.text.trim(),
        role: role,
        userCart: [],
        userWish: [],
        userImage: userImageUrl,
        createdAt: Timestamp.now(),
      );

      await FirebaseFirestore.instance
          .collection('users')
          .doc(newUser.uid)
          .set(newUser.toMap());

      if (mounted) {
        Provider.of<UserProvider>(context, listen: false).setUser(newUser);
      }

      await userCred.user!.sendEmailVerification();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Row(
              children: [
                Icon(Icons.check_circle, color: Colors.white),
                SizedBox(width: 8),
                Expanded(
                  child:
                      Text('Account created! Verify your email to login.'),
                ),
              ],
            ),
            backgroundColor: Colors.green.shade700,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
        Navigator.pushReplacementNamed(context, AppRoutes.login);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.error_outline, color: Colors.white),
                const SizedBox(width: 8),
                Expanded(child: Text('Registration failed: $e')),
              ],
            ),
            backgroundColor: Colors.red.shade700,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  // ✅ Reusable input decoration matching login theme
  InputDecoration _inputDecoration({
    required String hint,
    required IconData icon,
    Widget? suffix,
  }) {
    return InputDecoration(
      hintText: hint,
      prefixIcon: Icon(icon, color: kSlate, size: 22),
      suffixIcon: suffix,
      filled: true,
      fillColor: kLightGrey,
      hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: kMidGrey, width: 1.5),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: kNavy, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.red, width: 1.5),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.red, width: 2),
      ),
      contentPadding:
          const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        body: LoadngManager(
          isLoading: isLoading,
          child: Container(
            // ✅ Same Navy + Slate Gradient as Login
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  kNavy,
                  kSlate,
                  Color(0xFF546E7A),
                ],
              ),
            ),
            child: SafeArea(
              child: Column(
                children: [
                  // ✅ Top Header Section
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 20,
                    ),
                    child: Row(
                      children: [
                        // Back button
                        GestureDetector(
                          onTap: () => Navigator.pushReplacementNamed(
                            context,
                            AppRoutes.login,
                          ),
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: Colors.white.withOpacity(0.3),
                                width: 1,
                              ),
                            ),
                            child: const Icon(
                              Icons.arrow_back_ios,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ),

                        const SizedBox(width: 16),

                        // Header Text
                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Create Account',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                letterSpacing: -0.5,
                              ),
                            ),
                            Text(
                              'Join Cozy Corner today',
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.white70,
                              ),
                            ),
                          ],
                        ),

                        const Spacer(),

                        // App icon top right
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.3),
                              width: 1,
                            ),
                          ),
                          child: const Icon(
                            Icons.home_work_rounded,
                            color: Colors.white,
                            size: 22,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // ✅ White Form Card
                  Expanded(
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(32),
                          topRight: Radius.circular(32),
                        ),
                      ),
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.fromLTRB(24, 28, 24, 24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // ✅ Profile Image Picker - Centered
                            Center(
                              child: Column(
                                children: [
                                  Stack(
                                    children: [
                                      // Profile circle
                                      Container(
                                        width: 110,
                                        height: 110,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            color: kNavy,
                                            width: 3,
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color: kNavy.withOpacity(0.2),
                                              blurRadius: 15,
                                              spreadRadius: 2,
                                            ),
                                          ],
                                        ),
                                        child: ClipOval(
                                          child: _pickedImageBytes != null
                                              ? Image.memory(
                                                  _pickedImageBytes!,
                                                  fit: BoxFit.cover,
                                                )
                                              : Container(
                                                  color: kLightGrey,
                                                  child: const Icon(
                                                    Icons.person,
                                                    size: 55,
                                                    color: kSlate,
                                                  ),
                                                ),
                                        ),
                                      ),

                                      // Camera button
                                      Positioned(
                                        bottom: 0,
                                        right: 0,
                                        child: GestureDetector(
                                          onTap: _localImagePicker,
                                          child: Container(
                                            padding: const EdgeInsets.all(8),
                                            decoration: BoxDecoration(
                                              gradient: const LinearGradient(
                                                colors: [kNavy, kSlate],
                                              ),
                                              shape: BoxShape.circle,
                                              boxShadow: [
                                                BoxShadow(
                                                  color: kNavy.withOpacity(0.4),
                                                  blurRadius: 8,
                                                ),
                                              ],
                                            ),
                                            child: const Icon(
                                              Icons.camera_alt,
                                              color: Colors.white,
                                              size: 18,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),

                                  const SizedBox(height: 8),

                                  // Upload hint
                                  Text(
                                    'Tap to upload profile photo',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey.shade500,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 24),

                            // Section label
                            const Text(
                              'Your Details',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: kNavy,
                                letterSpacing: -0.3,
                              ),
                            ),

                            const SizedBox(height: 4),

                            Text(
                              'Fill in your information to get started',
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey.shade500,
                              ),
                            ),

                            const SizedBox(height: 20),

                            // ✅ Form
                            Form(
                              key: _formkey,
                              child: Column(
                                children: [
                                  // Full Name
                                  TextFormField(
                                    controller: _nameController,
                                    focusNode: _nameFocusNode,
                                    keyboardType: TextInputType.name,
                                    textInputAction: TextInputAction.next,
                                    decoration: _inputDecoration(
                                      hint: 'Full Name',
                                      icon: Icons.person_outline,
                                    ),
                                    validator:
                                        MyValidators.displayNameValidator,
                                    onFieldSubmitted: (_) {
                                      FocusScope.of(context)
                                          .requestFocus(_emailFocusNode);
                                    },
                                  ),

                                  const SizedBox(height: 16),

                                  // Email
                                  TextFormField(
                                    controller: _emailController,
                                    focusNode: _emailFocusNode,
                                    keyboardType: TextInputType.emailAddress,
                                    textInputAction: TextInputAction.next,
                                    decoration: _inputDecoration(
                                      hint: 'Email Address',
                                      icon: Icons.email_outlined,
                                    ),
                                    validator: MyValidators.emailValidator,
                                    onFieldSubmitted: (_) {
                                      FocusScope.of(context)
                                          .requestFocus(_passwordFocusNode);
                                    },
                                  ),

                                  const SizedBox(height: 16),

                                  // Password
                                  TextFormField(
                                    controller: _passwordController,
                                    focusNode: _passwordFocusNode,
                                    obscureText: obscureText,
                                    textInputAction: TextInputAction.next,
                                    decoration: _inputDecoration(
                                      hint: 'Password',
                                      icon: Icons.lock_outline,
                                      suffix: IconButton(
                                        icon: Icon(
                                          obscureText
                                              ? Icons.visibility_off_outlined
                                              : Icons.visibility_outlined,
                                          color: Colors.grey.shade500,
                                          size: 20,
                                        ),
                                        onPressed: () => setState(
                                          () => obscureText = !obscureText,
                                        ),
                                      ),
                                    ),
                                    validator: MyValidators.passwordValidator,
                                    onFieldSubmitted: (_) {
                                      FocusScope.of(context).requestFocus(
                                        _repeatPasswordFocusNode,
                                      );
                                    },
                                  ),

                                  const SizedBox(height: 16),

                                  // Confirm Password
                                  TextFormField(
                                    controller: _repeatPasswordController,
                                    focusNode: _repeatPasswordFocusNode,
                                    obscureText: obscureRepeatText,
                                    textInputAction: TextInputAction.done,
                                    decoration: _inputDecoration(
                                      hint: 'Confirm Password',
                                      icon: Icons.lock_outline,
                                      suffix: IconButton(
                                        icon: Icon(
                                          obscureRepeatText
                                              ? Icons.visibility_off_outlined
                                              : Icons.visibility_outlined,
                                          color: Colors.grey.shade500,
                                          size: 20,
                                        ),
                                        onPressed: () => setState(
                                          () => obscureRepeatText =
                                              !obscureRepeatText,
                                        ),
                                      ),
                                    ),
                                    validator: (value) =>
                                        MyValidators.repeatPasswordValidator(
                                      value: value,
                                      password: _passwordController.text,
                                    ),
                                    onFieldSubmitted: (_) => _registerFCT(),
                                  ),

                                  const SizedBox(height: 32),

                                  // ✅ Create Account Button
                                  SizedBox(
                                    width: double.infinity,
                                    height: 54,
                                    child: DecoratedBox(
                                      decoration: BoxDecoration(
                                        gradient: const LinearGradient(
                                          colors: [kNavy, kSlate],
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(12),
                                        boxShadow: [
                                          BoxShadow(
                                            color: kNavy.withOpacity(0.35),
                                            blurRadius: 12,
                                            offset: const Offset(0, 5),
                                          ),
                                        ],
                                      ),
                                      child: ElevatedButton.icon(
                                        onPressed:
                                            isLoading ? null : _registerFCT,
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.transparent,
                                          shadowColor: Colors.transparent,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                        ),
                                        icon: isLoading
                                            ? const SizedBox(
                                                height: 20,
                                                width: 20,
                                                child:
                                                    CircularProgressIndicator(
                                                  strokeWidth: 2,
                                                  color: Colors.white,
                                                ),
                                              )
                                            : const Icon(
                                                Icons.person_add,
                                                color: Colors.white,
                                              ),
                                        label: Text(
                                          isLoading
                                              ? 'Creating Account...'
                                              : 'Create Account',
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                            letterSpacing: 0.5,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),

                                  const SizedBox(height: 20),

                                  // ✅ Terms Text
                                  Text(
                                    'By signing up, you agree to our\nTerms of Service & Privacy Policy',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey.shade500,
                                      height: 1.5,
                                    ),
                                  ),

                                  const SizedBox(height: 20),

                                  // ✅ Divider
                                  Divider(color: Colors.grey.shade200),

                                  const SizedBox(height: 16),

                                  // ✅ Login Link
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Already have an account? ',
                                        style: TextStyle(
                                          color: Colors.grey.shade600,
                                          fontSize: 14,
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () =>
                                            Navigator.pushReplacementNamed(
                                          context,
                                          AppRoutes.login,
                                        ),
                                        child: const Text(
                                          'Sign In',
                                          style: TextStyle(
                                            color: kNavy,
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),

                                  const SizedBox(height: 16),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
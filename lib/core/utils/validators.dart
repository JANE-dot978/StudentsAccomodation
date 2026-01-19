class MyValidators {
  // Email validation
  static String? emailValidator(String? value) {
    if (value == null || value.isEmpty) return 'Email cannot be empty';
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) return 'Enter a valid email';
    return null;
  }

  // Password validation (min 6 chars)
  static String? passwordValidator(String? value) {
    if (value == null || value.isEmpty) return 'Password cannot be empty';
    if (value.length < 6) return 'Password must be at least 6 characters';
    return null;
  }

  // Repeat password validation
  static String? repeatPasswordValidator({String? value, required String password}) {
    if (value == null || value.isEmpty) return 'Please repeat your password';
    if (value != password) return 'Passwords do not match';
    return null;
  }

  // Display name / full name validation
  static String? displayNameValidator(String? value) {
    if (value == null || value.isEmpty) return 'Name cannot be empty';
    if (value.length < 3) return 'Name must be at least 3 characters';
    return null;
  }
}

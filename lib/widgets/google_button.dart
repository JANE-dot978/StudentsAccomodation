import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';
import '../core/routes/app_routes.dart'; 

class GoogleButton extends StatelessWidget {
  const GoogleButton({super.key});

  Future<void> _googleSignIn({required BuildContext context}) async {
    try {
      
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
          child: CircularProgressIndicator(),
        ),
      );

      final userProvider = Provider.of<UserProvider>(context, listen: false);
      
      
      final errorMessage = await userProvider.signInWithGoogle();

      if (!context.mounted) return;

      
      Navigator.pop(context);

    
      if (errorMessage != null) {
        if (!context.mounted) return;
        
        
        if (errorMessage != 'Sign-in cancelled') {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(errorMessage),
              backgroundColor: Colors.red,
              duration: const Duration(seconds: 4),
            ),
          );
        }
        return;
      }

    
      final user = userProvider.getUser;
      
      if (user != null && context.mounted) {
        if (user.role == 'student' || user.role == 'user') {
          Navigator.pushReplacementNamed(context, AppRoutes.mainNavigation);
        } else if (user.role == 'landlord') {
          Navigator.pushReplacementNamed(context, AppRoutes.landlordMain);
        } else if (user.role == 'admin') {
          Navigator.pushReplacementNamed(context, AppRoutes.adminDashboard);
        }
      }
    } catch (error) {
    
      if (context.mounted) {
        Navigator.pop(context);
        
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('An error occurred: ${error.toString()}'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 4),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 14),
          side: BorderSide(color: Colors.grey.shade300, width: 1.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        icon: Image.network(
          'https://www.google.com/favicon.ico',
          height: 24,
          width: 24,
          errorBuilder: (context, error, stackTrace) => const Icon(
            Icons.login,
            color: Colors.red,
            size: 24,
          ),
        ),
        label: const Text(
          "Continue with Google",
          style: TextStyle(
            color: Colors.black87,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        onPressed: () async => await _googleSignIn(context: context),
      ),
    );
  }
}
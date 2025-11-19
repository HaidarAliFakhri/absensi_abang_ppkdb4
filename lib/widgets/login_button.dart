import 'package:absensi_abang_ppkdb4/app/constants/app_color.dart';
import 'package:flutter/material.dart';

class LoginButton extends StatelessWidget {
  const LoginButton({
    super.key,
    this.onPressed,
    required this.text,
    this.isLoading,
  });
  final void Function()? onPressed;
  final String text;
  final bool? isLoading;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColor.blueButton,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        ),
        child: isLoading == true
            ? CircularProgressIndicator()
            : Text(
                text,
                // "Login",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
      ),
    );
  }
}

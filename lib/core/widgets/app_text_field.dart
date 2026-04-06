import 'package:flutter/material.dart';

class AppTextField extends StatelessWidget {
  final String labelText;
  final String? hintText;
  final TextEditingController? controller;
  final bool obscureText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;

  const AppTextField({
    super.key,
    required this.labelText,
    this.hintText,
    this.controller,
    this.obscureText = false,
    this.prefixIcon,
    this.suffixIcon,
    this.keyboardType = TextInputType.text,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          labelText,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColor,
              ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          obscureText: obscureText,
          keyboardType: keyboardType,
          validator: validator,
          decoration: InputDecoration(
            hintText: hintText,
            prefixIcon: prefixIcon,
            suffixIcon: suffixIcon,
          ),
        ),
      ],
    );
  }
}

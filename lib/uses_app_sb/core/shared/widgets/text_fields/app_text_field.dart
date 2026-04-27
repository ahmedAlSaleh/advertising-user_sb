 import 'package:advertising_user/main.dart';
import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppTextField extends StatelessWidget {
  const AppTextField({
    super.key,
    this.prefix,
    required this.hint,
    this.isPassWordVisible,
    this.suffixIcon,
    this.onChanged,
    this.onFieldSubmitted,
    this.onTap,
    this.errorText,
    this.maxLines,
    required this.validator,
    required this.controller,
    this.keyboardType,
  });

  final Widget? prefix;
  final String hint;
  final bool? isPassWordVisible;
  final Widget? suffixIcon;
  final Function(String?)? onChanged;
  final Function(String)? onFieldSubmitted;
  final Function()? onTap;
  final String? errorText;
  final int? maxLines;
  final String? Function(String?) validator;
  final TextEditingController controller;
  final TextInputType? keyboardType;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: keyboardType,
      controller: controller,
      maxLines: maxLines ?? 1,
      obscureText: isPassWordVisible ?? false,
      onChanged: onChanged,
      onFieldSubmitted: onFieldSubmitted,
      onTap: onTap,
      decoration: InputDecoration(
        hoverColor: appTheme.primaryBackground.withOpacity(0.5),
        suffixIcon: suffixIcon,
        prefixIcon: prefix,
        floatingLabelBehavior: FloatingLabelBehavior.never,
        errorText: errorText,
        // labelText: label,

        hintText: hint,

        labelStyle: appTheme.text12,
        hintStyle: appTheme.text12,
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: appTheme.secondaryText.withOpacity(0.1),
            width: 1,
          ),
          borderRadius: BorderRadius.circular(16.sp),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: appTheme.secondaryText.withOpacity(0.1),
            width: 1,
          ),
          borderRadius: BorderRadius.circular(16.sp),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: appTheme.error,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(16.sp),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: appTheme.error,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(16.sp),
        ),
        filled: true,
        fillColor: appTheme.secondaryText.withOpacity(0.1),
        // contentPadding: const EdgeInsetsDirectional.fromSTEB(16, 16, 16, 16),
      ),
      style: appTheme.text16,
      validator: validator,
    );
  }
}

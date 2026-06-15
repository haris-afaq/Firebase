import 'package:firebase_practice/constants/app_colors.dart';
import 'package:flutter/material.dart';

class MainButton extends StatelessWidget {
  final String title;
  final Color titleColor;
  final VoidCallback onClick;
  final bool isLoading;

  const MainButton({
    required this.title,
    this.titleColor = AppColors.whiteColor,
    required this.onClick,
    this.isLoading = false,
    super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onClick,
      child: Container(
      width: double.infinity,
      height: 55,
      decoration: BoxDecoration(
        color: AppColors.firebaseOrangeColor,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Center(
        child: isLoading? CircularProgressIndicator(
          color: AppColors.whiteColor,
          strokeWidth: 3,
        ): Text(title,
        style: TextStyle(color: AppColors.whiteColor,
        fontSize: 18,
        fontWeight: FontWeight.w600
        ),
        ),
      ),
      ),
    );
  }
}
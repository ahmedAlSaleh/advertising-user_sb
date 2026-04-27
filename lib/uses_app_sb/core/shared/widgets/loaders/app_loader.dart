import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:math' as math;

import '../../../../../main.dart';


class AppLoader extends StatefulWidget {
  final String? message;

  const AppLoader({
    super.key,
    this.message,
  });

  @override
  State<AppLoader> createState() => _AppLoaderState();

  /// Show loader dialog
  static void show(
    BuildContext context, {
    String? message,
  }) {
    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black.withOpacity(0.5),
      builder: (context) => AppLoader(
        message: message,
      ),
    );
  }

  /// Hide loader dialog
  static void hide(BuildContext context) {
    Navigator.of(context).pop();
  }
}

class _AppLoaderState extends State<AppLoader>
    with TickerProviderStateMixin {
  late AnimationController _boxController;
  late AnimationController _heartController;
  late AnimationController _spinnerController;
  late AnimationController _textController;

  late Animation<double> _boxRotation;
  late Animation<double> _boxGlow;
  late Animation<double> _heartScale;
  late Animation<double> _heartGlow;

  @override
  void initState() {
    super.initState();

    // Glowing box animations
    _boxController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat();

    _boxRotation = Tween<double>(begin: 0.0, end: 2 * math.pi).animate(
      CurvedAnimation(
        parent: _boxController,
        curve: Curves.linear,
      ),
    );

    _boxGlow = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(
        parent: _boxController,
        curve: Curves.easeInOut,
      ),
    );

    // Pulsing heart animations
    _heartController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    )..repeat(reverse: true);

    _heartScale = Tween<double>(begin: 0.9, end: 1.1).animate(
      CurvedAnimation(
        parent: _heartController,
        curve: Curves.easeInOut,
      ),
    );

    _heartGlow = Tween<double>(begin: 0.3, end: 0.8).animate(
      CurvedAnimation(
        parent: _heartController,
        curve: Curves.easeInOut,
      ),
    );

    // Spinner animations
    _spinnerController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat();

    // Text animation (for animated dots)
    _textController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _boxController.dispose();
    _heartController.dispose();
    _spinnerController.dispose();
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      child: Container(
        padding: EdgeInsets.all(32.w),
        decoration: BoxDecoration(
          color: appTheme.secondaryBackground,
          borderRadius: BorderRadius.circular(24.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Combined animations
            SizedBox(
              height: 140.h,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Glowing Box Animation (Background)
                  AnimatedBuilder(
                    animation: _boxController,
                    builder: (context, child) {
                      return Transform.rotate(
                        angle: _boxRotation.value,
                        child: Container(
                          width: 80.w,
                          height: 80.w,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16.r),
                            gradient: LinearGradient(
                              colors: [
                                appTheme.primary,
                                appTheme.primary.withOpacity(0.5),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: appTheme.primary
                                    .withOpacity(_boxGlow.value * 0.6),
                                blurRadius: 30,
                                spreadRadius: 10,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),

                  // Pulsing Heart Animation (Foreground)
                  AnimatedBuilder(
                    animation: _heartController,
                    builder: (context, child) {
                      return Transform.scale(
                        scale: _heartScale.value,
                        child: Container(
                          width: 70.w,
                          height: 70.w,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: appTheme.error.withOpacity(0.1),
                            boxShadow: [
                              BoxShadow(
                                color: appTheme.error
                                    .withOpacity(_heartGlow.value),
                                blurRadius: 30,
                                spreadRadius: 5,
                              ),
                            ],
                          ),
                          child: Icon(
                            Icons.favorite,
                            size: 40.sp,
                            color: appTheme.error,
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),

            SizedBox(height: 24.h),

            // Dual Gradient Circle Loaders
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Primary colored spinner (for glowing box)
                SizedBox(
                  width: 50.w,
                  height: 50.w,
                  child: AnimatedBuilder(
                    animation: _spinnerController,
                    builder: (context, child) {
                      return Transform.rotate(
                        angle: _spinnerController.value * 2 * math.pi,
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: SweepGradient(
                              colors: [
                                appTheme.primary,
                                appTheme.primary.withOpacity(0.3),
                                appTheme.primary,
                              ],
                              stops: const [0.0, 0.5, 1.0],
                            ),
                          ),
                          child: Container(
                            margin: EdgeInsets.all(8.w),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: appTheme.secondaryBackground,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),

                SizedBox(width: 16.w),

                // Error colored spinner (for pulsing heart)
                SizedBox(
                  width: 50.w,
                  height: 50.w,
                  child: AnimatedBuilder(
                    animation: _spinnerController,
                    builder: (context, child) {
                      return Transform.rotate(
                        angle: _spinnerController.value * -2 * math.pi,
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: SweepGradient(
                              colors: [
                                appTheme.error,
                                appTheme.error.withOpacity(0.3),
                                appTheme.error,
                              ],
                              stops: const [0.0, 0.5, 1.0],
                            ),
                          ),
                          child: Container(
                            margin: EdgeInsets.all(8.w),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: appTheme.secondaryBackground,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),

            if (widget.message != null) ...[
              SizedBox(height: 24.h),
              AnimatedBuilder(
                animation: _textController,
                builder: (context, child) {
                  // Calculate number of dots (0 to 3)
                  int dotCount = (_textController.value * 4).floor() % 4;
                  String dots = '.' * dotCount;

                  // Extract base text without existing dots
                  String baseText = widget.message!.replaceAll('.', '').trim();

                  return Text(
                    '$baseText$dots',
                    style: TextStyle(
                      color: appTheme.primaryText,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  );
                },
              ),
            ],
          ],
        ),
      ),
    );
  }
}

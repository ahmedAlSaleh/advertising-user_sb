import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:math' as math;

import '../../../../../main.dart';


class SpinningDotsLoader extends StatefulWidget {
  final Color? color;
  final double? size;

  const SpinningDotsLoader({
    super.key,
    this.color,
    this.size,
  });

  @override
  State<SpinningDotsLoader> createState() => _SpinningDotsLoaderState();
}

class _SpinningDotsLoaderState extends State<SpinningDotsLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = widget.color ?? appTheme.primary;
    final size = widget.size ?? 80.w;

    return SizedBox(
      width: size,
      height: size,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Stack(
            alignment: Alignment.center,
            children: List.generate(8, (index) {
              final angle = (index * math.pi * 2) / 8;
              final radius = size / 3;

              return Transform.rotate(
                angle: _controller.value * 2 * math.pi,
                child: Transform.translate(
                  offset: Offset(
                    math.cos(angle) * radius,
                    math.sin(angle) * radius,
                  ),
                  child: Transform.scale(
                    scale: 1 -
                        (math.sin(_controller.value * 2 * math.pi + angle) +
                            1) /
                            4,
                    child: Container(
                      width: size / 8,
                      height: size / 8,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: color.withOpacity(0.9),
                        boxShadow: [
                          BoxShadow(
                            color: color.withOpacity(0.3),
                            blurRadius: 8,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }),
          );
        },
      ),
    );
  }
}


class GlowingBoxLoader extends StatefulWidget {
  final String? message;
  final Color? glowColor;

  const GlowingBoxLoader({
    super.key,
    this.message,
    this.glowColor,
  });

  @override
  State<GlowingBoxLoader> createState() => _GlowingBoxLoaderState();
}

class _GlowingBoxLoaderState extends State<GlowingBoxLoader>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late AnimationController _textController;
  late Animation<double> _glowAnimation;
  late Animation<double> _rotateAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat(reverse: true);

    _textController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    )..repeat();

    _glowAnimation = Tween<double>(begin: 0.3, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    _rotateAnimation = Tween<double>(begin: 0, end: 0.1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final glowColor = widget.glowColor ?? appTheme.primary;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Transform.rotate(
              angle: math.sin(_rotateAnimation.value * math.pi),
              child: Container(
                width: 80.w,
                height: 80.w,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16.r),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      glowColor,
                      glowColor.withOpacity(0.6),
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: glowColor.withOpacity(_glowAnimation.value * 0.6),
                      blurRadius: 30,
                      spreadRadius: 10,
                    ),
                  ],
                ),
                child: Icon(
                  Icons.shopping_cart_outlined,
                  size: 40.sp,
                  color: Colors.white,
                ),
              ),
            );
          },
        ),
        SizedBox(height: 50.h),
        SpinningDotsLoader(color: glowColor, size: 90.w),
        if (widget.message != null) ...[
          SizedBox(height: 24.h),
          AnimatedBuilder(
            animation: _textController,
            builder: (context, child) {
              int dotCount = (_textController.value * 4).floor() % 4;
              String dots = '.' * dotCount;
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
    );
  }
}

// // ============================================================================
// // Preview Screen (للاختبار فقط)
// // ============================================================================
// class CombinedLoadersPreviewScreen extends StatelessWidget {
//   const CombinedLoadersPreviewScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: appTheme.primaryBackground,
//       appBar: AppBar(
//         title: const Text('Loaders Preview'),
//       ),
//       body: SingleChildScrollView(
//         padding: EdgeInsets.all(24.w),
//         child: Column(
//           children: [
//             const _CombinedLoaderCard(
//               loader: GlowingBoxLoader(
//                 message: 'Loading',
//               ),
//             ),
//             SizedBox(height: 24.h),
//             const _CombinedLoaderCard(
//               loader: SpinningDotsLoader(),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// class _CombinedLoaderCard extends StatelessWidget {
//   final Widget loader;
//
//   const _CombinedLoaderCard({
//     required this.loader,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: double.infinity,
//       padding: EdgeInsets.all(32.w),
//       decoration: BoxDecoration(
//         color: appTheme.secondaryBackground,
//         borderRadius: BorderRadius.circular(20.r),
//         boxShadow: [
//           BoxShadow(
//             color: appTheme.primaryText.withOpacity(0.06),
//             blurRadius: 12,
//             offset: const Offset(0, 4),
//           ),
//         ],
//       ),
//       child: Center(child: loader),
//     );
//   }
// }
//
//
//
// طريقة الاستخدام في أي مكان في التطبيق:
// 1. استخدام GlowingBoxLoader:
// dart// في صفحة التحميل
// Center(
// child: GlowingBoxLoader(
// message: 'جاري التحميل',
// glowColor: Colors.blue, // اختياري
// ),
// )
//
// // أو بدون رسالة
// GlowingBoxLoader()
// 2. استخدام SpinningDotsLoader:
// dartCenter(
// child: SpinningDotsLoader(
// color: Colors.green,
// size: 100.w,
// ),
// )
// 3. في Dialog أو BottomSheet:
// dartshowDialog(
// context: context,
// barrierDismissible: false,
// builder: (context) => Center(
// child: Material(
// color: Colors.transparent,
// child: GlowingBoxLoader(
// message: 'Please wait',
// ),
// ),
// ),
// );
// 4. في FutureBuilder:
// dartFutureBuilder(
// future: fetchData(),
// builder: (context, snapshot) {
// if (snapshot.connectionState == ConnectionState.waiting) {
// return Center(
// child: GlowingBoxLoader(message: 'Loading data'),
// );
// }
// return YourDataWidget();
// },
// )
// ملاحظات:
//
// الملف جاهز للاستخدام في أي مكان
// يمكنك تخصيص الألوان والأحجام
// الـ Loaders متحركة وجذابة
// لا تحتاج dependencies إضافية غير الموجودة
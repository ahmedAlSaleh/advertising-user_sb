import 'package:advertising_user/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class StepIndicator extends StatelessWidget {
  final int currentStep;
  final int totalSteps;

  const StepIndicator({
    super.key,
    required this.currentStep,
    required this.totalSteps,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(totalSteps, (index) {
        final step = index + 1;
        final isActive = step == currentStep;
        final isCompleted = step < currentStep;

        return Row(
          children: [
            Container(
              width: 40.w,
              height: 40.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isActive || isCompleted
                    ? appTheme.primary
                    : appTheme.secondaryBackground,
                border: Border.all(
                  color: isActive ? appTheme.primary : appTheme.secondaryText,
                  width: 2,
                ),
              ),
              child: Center(
                child: isCompleted
                    ? Icon(Icons.check, color: Colors.white, size: 20.sp)
                    : Text(
                        step.toString(),
                        style: appTheme.text16.copyWith(
                          color: isActive ? Colors.white : appTheme.secondaryText,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ),
            if (step < totalSteps)
              Container(
                width: 40.w,
                height: 2.h,
                color: step < currentStep
                    ? appTheme.primary
                    : appTheme.secondaryText,
                margin: EdgeInsets.symmetric(horizontal: 8.w),
              ),
          ],
        );
      }),
    );
  }
}

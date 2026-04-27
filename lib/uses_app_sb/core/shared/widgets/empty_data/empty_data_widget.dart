 import 'package:advertising_user/main.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// ignore: must_be_immutable
class EmptyData extends StatelessWidget {
  EmptyData({
    super.key,
    required this.icon,
    required this.message,
    this.onTap,
  });

  final IconData icon;
  final String message;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        if (onTap != null) {
          onTap!(); // Trigger the refresh action
        }
      },
      child: SingleChildScrollView(
        physics:
            const AlwaysScrollableScrollPhysics(), // Ensure scroll is enabled even if no data
        child: SizedBox(
          height: MediaQuery.of(context).size.height -
              100, // Ensure it takes full height to trigger refresh
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: onTap,
                  child: Icon(
                    icon,
                    color: appTheme.primary,
                    size: 60,
                  ),
                ),
                Align(
                  alignment: const AlignmentDirectional(0, 0),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Text(
                      (message).tr,
                      textAlign: TextAlign.center,
                      style: appTheme.text18.copyWith(
                        fontFamily: "NotoNaskhArabic",
                        color: appTheme.primary,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

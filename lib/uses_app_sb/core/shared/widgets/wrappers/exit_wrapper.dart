import 'package:flutter/material.dart';
import 'package:advertising_user/uses_app_sb/core/shared/widgets/dialogs/exit_confirmation_dialog.dart';

/// A wrapper widget that handles exit confirmation for the entire app
///
/// Wrap your Scaffold with this widget to enable exit confirmation dialog
/// when the user tries to exit the app using the device back button.
///
/// Example:
/// ```dart
/// return ExitWrapper(
///   child: Scaffold(
///     appBar: AppBar(title: Text('Home')),
///     body: YourContent(),
///   ),
/// );
/// ```
class ExitWrapper extends StatelessWidget {
  final Widget child;

  const ExitWrapper({
    super.key,
    required this.child,
  });

  Future<bool> _onWillPop(BuildContext context) async {
    // Check if we can go back in the navigation stack
    if (Navigator.of(context).canPop()) {
      return true;
    }

    // Show exit confirmation dialog
    final shouldExit = await showExitConfirmationDialog();
    return shouldExit;
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) async {
        if (!didPop) {
          final shouldPop = await _onWillPop(context);
          if (shouldPop && context.mounted) {
            Navigator.of(context).pop();
          }
        }
      },
      child: child,
    );
  }
}

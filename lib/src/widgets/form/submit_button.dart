import 'package:flutter/material.dart';

class SubmitFormButton extends StatelessWidget {
  const SubmitFormButton({
    super.key,
    this.submitButtonStyle,
    this.onSubmit,
    this.submitButtonChild,
  });

  /// Style configuration for the submit button.
  final ButtonStyle? submitButtonStyle;

  /// Callback function invoked when the form is submitted.
  final void Function()? onSubmit;

  /// The widget displayed as the child of the submit button.
  final Widget? submitButtonChild;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: submitButtonStyle ??
            ButtonStyle(
              backgroundColor: WidgetStateProperty.all(Colors.amber),
              shape: WidgetStateProperty.all(RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
              )),
            ),
        onPressed: onSubmit,
        child: submitButtonChild ?? const Text('Get Weather'),
      ),
    );
  }
}

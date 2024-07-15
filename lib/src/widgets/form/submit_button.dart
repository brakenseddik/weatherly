import 'package:flutter/material.dart';

class SubmitFormButton extends StatelessWidget {
  final ButtonStyle? submitButtonStyle;
  final void Function()? onSubmit;
  final Widget? submitButtonChild;
  const SubmitFormButton({
    super.key,
    this.submitButtonStyle,
    this.onSubmit,
    this.submitButtonChild,
  });

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
        child: submitButtonChild ??
            const Text(
              'Get Weather',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
      ),
    );
  }
}

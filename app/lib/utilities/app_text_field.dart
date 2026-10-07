import 'package:flutter/material.dart';

/// Themed text field. [radius] and [bordered] cover the pill (forms), rounded
/// (multi-line) and borderless (on dark backgrounds) variants.
class AppTextField extends StatelessWidget {
  const AppTextField({
    super.key,
    required this.controller,
    this.hintText,
    this.errorText,
    this.onSubmitted,
    this.textInputAction,
    this.minLines,
    this.maxLines = 1,
    this.suffix,
    this.radius = 28,
    this.bordered = true,
  });

  final TextEditingController controller;
  final String? hintText;
  final String? errorText;
  final ValueChanged<String>? onSubmitted;
  final TextInputAction? textInputAction;
  final int? minLines;
  final int? maxLines;
  final Widget? suffix;
  final double radius;
  final bool bordered;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    OutlineInputBorder border(Color color, double width) => OutlineInputBorder(
      borderRadius: BorderRadius.circular(radius),
      borderSide: bordered
          ? BorderSide(color: color, width: width)
          : BorderSide.none,
    );

    return TextField(
      controller: controller,
      onSubmitted: onSubmitted,
      textInputAction: textInputAction,
      minLines: minLines,
      maxLines: maxLines,
      keyboardType: maxLines == 1
          ? TextInputType.text
          : TextInputType.multiline,
      style: Theme.of(context).textTheme.bodyLarge,
      decoration: InputDecoration(
        hintText: hintText,
        errorText: errorText,
        suffixIcon: suffix,
        contentPadding: maxLines == 1 ? null : const EdgeInsets.all(18),
        enabledBorder: border(colors.outline, 1.5),
        focusedBorder: border(colors.secondary, 2),
        errorBorder: border(colors.error, 1.5),
        focusedErrorBorder: border(colors.error, 2),
      ),
    );
  }
}

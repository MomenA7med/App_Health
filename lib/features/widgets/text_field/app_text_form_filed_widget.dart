import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:app_health/core/extensions/extension_theme.dart';
import 'package:app_health/features/widgets/label_with_asterisk_widget.dart';
import 'package:app_health/res/app_colors.dart';

// ignore: must_be_immutable
class AppTextFormField extends StatefulWidget {
  final String? title;
  final String? subtitle;
  final bool requiredTitle;
  final String? hintText;
  final String? helperText;
  final String? initialValue;
  final bool obscure;
  final bool enable;
  final bool readOnly;
  final void Function(String?)? onSaved;
  final void Function(String?)? onFieldSubmitted;
  final void Function(String)? onChanged;
  final String? Function(String?)? validator;
  final TextInputType? textInputType;
  final TextInputAction? textInputAction;
  final TextEditingController? controller;
  final int maxLines;
  final int? maxLength;
  final String? customCounterText;
  final EdgeInsetsGeometry? contentPadding;
  final TextStyle? hintTextStyle;
  Color? enableBorderColor;
  FocusNode? focusNode;
  Iterable<String>? autofillHints;
  final TextAlign? textAlign;
  final Widget? prefixIcon;
  final List<TextInputFormatter>? inputFormatters;
  final Widget? suffixIcon;

  AppTextFormField({
    super.key,
    this.title,
    this.subtitle,
    this.hintText,
    this.prefixIcon,
    this.onSaved,
    this.helperText,
    this.onChanged,
    this.hintTextStyle,
    this.initialValue,
    this.contentPadding,
    this.onFieldSubmitted,
    this.textInputAction,
    this.obscure = false,
    this.enable = true,
    this.readOnly = false,
    this.maxLines = 1,
    this.maxLength,
    this.textInputType,
    this.validator,
    this.controller,
    this.inputFormatters,
    this.customCounterText,
    this.enableBorderColor,
    this.focusNode,
    this.autofillHints,
    this.textAlign = TextAlign.start,
    this.suffixIcon,
    this.requiredTitle = true,
  }) : assert(initialValue == null || controller == null);

  @override
  State<AppTextFormField> createState() => _AppTextFormFieldState();
}

class _AppTextFormFieldState extends State<AppTextFormField> {
  bool obscure = true;
  bool setObscure = false;

  @override
  Widget build(BuildContext context) {
    if (!setObscure) {
      obscure = widget.obscure;
      setObscure = true;
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.title != null) ...[
          LabelWithAsterisk(
            subtitle: widget.subtitle,
            text: widget.title!,
            showAsterisk: widget.requiredTitle,
          ),
          const SizedBox(height: 10),
        ],
        TextFormField(
          enabled: widget.enable,
          initialValue: widget.initialValue,
          obscureText: obscure,
          readOnly: widget.readOnly,
          style: context.bodyMedium.copyWith(fontWeight: FontWeight.bold),
          controller: widget.controller,
          autofillHints: widget.autofillHints,
          inputFormatters: widget.inputFormatters,
          focusNode: widget.focusNode,
          onTapOutside: (event) {
            FocusManager.instance.primaryFocus?.unfocus();
          },
          decoration: InputDecoration(
            errorMaxLines: 2,
            prefixIcon: widget.prefixIcon,
            contentPadding: widget.contentPadding,
            helperText: widget.helperText,
            counterText: widget.customCounterText,
            hintText: widget.hintText,
            fillColor: AppColors.appFormFieldFill,
            filled: true,
            hintStyle:
                widget.hintTextStyle ??
                context.textTheme.titleSmall!.copyWith(fontSize: 14),
            enabledBorder: textFormFieldEnabledBorder,
            disabledBorder: textFormFieldDisabledBorder,
            errorBorder: textFormFieldErrorBorder,
            focusedErrorBorder: textFormFieldFocusErrorBorder,
            focusedBorder: textFormFieldFocusBorder,
            border: const OutlineInputBorder(),
            suffixIcon: widget.obscure
                ? IconButton(
                    icon: Icon(
                      // Based on passwordVisible state choose the icon
                      obscure
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                      color: AppColors.suffixIcon,
                    ),
                    onPressed: () {
                      setState(() {
                        obscure = !obscure;
                      });
                    },
                  )
                : widget.suffixIcon,
          ),
          onChanged: widget.onChanged,
          onFieldSubmitted: widget.onFieldSubmitted,
          onSaved: widget.onSaved,
          validator: widget.validator,
          maxLines: widget.maxLines,
          textInputAction: widget.textInputAction,
          keyboardType: widget.textInputType,
          maxLength: widget.maxLength,
          maxLengthEnforcement:
              MaxLengthEnforcement.truncateAfterCompositionEnds,
          textAlign: widget.textAlign!,
        ),
      ],
    );
  }

  OutlineInputBorder get textFormFieldErrorBorder => OutlineInputBorder(
    borderRadius: BorderRadius.circular(10),
    borderSide: const BorderSide(color: AppColors.formFieldProfileErrorIBorder),
  );

  OutlineInputBorder get textFormFieldFocusBorder => OutlineInputBorder(
    borderRadius: BorderRadius.circular(10),
    borderSide: const BorderSide(
      color: AppColors.formFieldFocusIBorder,
      width: 1,
    ),
  );

  OutlineInputBorder get textFormFieldFocusErrorBorder => OutlineInputBorder(
    borderRadius: BorderRadius.circular(10),
    borderSide: const BorderSide(
      color: AppColors.formFieldProfileErrorIBorder,
      width: 1,
    ),
  );

  OutlineInputBorder get textFormFieldEnabledBorder => OutlineInputBorder(
    borderRadius: BorderRadius.circular(10),
    borderSide: BorderSide(
      color: widget.enableBorderColor ?? AppColors.enabledAppFormFieldBorder,
      width: 1,
    ),
  );

  OutlineInputBorder get textFormFieldDisabledBorder => OutlineInputBorder(
    borderRadius: BorderRadius.circular(10),
    borderSide: BorderSide(
      color: widget.enableBorderColor ?? AppColors.enabledAppFormFieldBorder,
      width: 2,
    ),
  );
}

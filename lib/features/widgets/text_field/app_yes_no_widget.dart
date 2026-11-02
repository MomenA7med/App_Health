import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:app_health/core/extensions/extension_localization.dart';
import 'package:app_health/core/extensions/extension_theme.dart';
import 'package:app_health/features/widgets/label_with_asterisk_widget.dart';
import 'package:app_health/features/widgets/text_field/app_text_form_filed_widget.dart';
import 'package:app_health/res/app_asset_paths.dart';
import 'package:app_health/res/app_colors.dart';
import 'package:app_health/utils/locale/app_localization_keys.dart';
import 'package:app_health/utils/validations/app_validate.dart';

class AppYesNoWidget extends StatefulWidget {
  final bool? isYes;
  final void Function(bool isYes) onChanged;
  final String title;
  final String? fieldTitle, filedHintText, fieldInitialValue;
  final String? Function(String?)? fieldValidator;
  final Function(String?)? fieldOnSaved;
  final bool showField;
  final bool isRequired;

  const AppYesNoWidget({
    super.key,
    this.isYes,
    required this.title,
    required this.onChanged,
    this.isRequired = false,
    this.fieldOnSaved,
    this.fieldTitle,
    this.fieldInitialValue,
    this.fieldValidator,
    this.filedHintText,
    this.showField = false,
  });

  @override
  State<AppYesNoWidget> createState() => _AppYesNoWidgetState();
}

class _AppYesNoWidgetState extends State<AppYesNoWidget> with AppValidate {
  bool? isYes;

  @override
  void initState() {
    isYes = widget.isYes;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.isRequired)
          LabelWithAsterisk(text: widget.title, showAsterisk: true),
        if (!widget.isRequired)
          Text(
            widget.title,
            style: context.bodyMedium.copyWith(fontWeight: FontWeight.w700),
          ),
        const SizedBox(height: 20),
        FormField<bool>(
          initialValue: isYes,
          //validator: listYesOrNoValidator,
          builder: (FormFieldState<bool> state) {
            void onChangedHandler(bool value) {
              state.didChange(value);
            }

            return Builder(
              builder: (context) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Wrap(
                      spacing: 40,
                      runSpacing: 15,
                      children: <Widget>[
                        _buildItemWidget(
                          context.translate(LocalizationKeys.yes),
                          true,
                          onChangedHandler,
                        ),
                        _buildItemWidget(
                          context.translate(LocalizationKeys.no),
                          false,
                          onChangedHandler,
                        ),
                      ],
                    ),
                    SizedBox(height: 5.h),
                    state.hasError
                        ? Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 15,
                              vertical: 10,
                            ),
                            child: Text(
                              state.errorText!,
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.error,
                                fontSize: 12.0,
                              ),
                            ),
                          )
                        : Container(),
                  ],
                );
              },
            );
          },
        ),
        if (widget.showField && (isYes ?? false)) ...[
          const SizedBox(height: 10),
          AppTextFormField(
            title: widget.fieldTitle,
            hintText: widget.filedHintText,
            validator: widget.fieldValidator,
            onSaved: widget.fieldOnSaved,
            initialValue: widget.fieldInitialValue,
          ),
        ],
      ],
    );
  }

  Widget _buildItemWidget(
    String title,
    bool value,
    Function(bool value) onChangedHandler,
  ) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        CustomRadioWidget(
          value: value,
          groupValue: isYes,
          onChanged: (bool value) {
            setState(() {
              isYes = value;
            });
            widget.onChanged(isYes!);
            onChangedHandler(value);
          },
        ),
        SizedBox(width: 10),
        Text(
          title,
          style: context.bodyMedium.copyWith(
            fontWeight: value == isYes ? null : FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

class CustomRadioWidget extends StatelessWidget {
  final bool value;
  final bool? groupValue;
  final void Function(bool) onChanged;

  const CustomRadioWidget({
    super.key,
    required this.value,
    this.groupValue,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onChanged(value),
      child: Container(
        width: 20,
        height: 20,
        decoration: ShapeDecoration(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(36),
            side: BorderSide(color: AppColors.taskItemBorder),
          ),
        ),
        child: value == groupValue
            ? SvgPicture.asset(AppAssetPaths.checkBoxCircleIcon)
            : null,
      ),
    );
  }
}

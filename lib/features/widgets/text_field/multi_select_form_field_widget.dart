import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:app_health/features/widgets/label_with_asterisk_widget.dart';
import 'package:app_health/features/widgets/text_field/app_text_form_filed_widget.dart';
import 'package:app_health/res/app_colors.dart';

class MultiSelectItem extends Equatable {
  final String value;
  final int key;

  const MultiSelectItem({required this.value, required this.key});

  factory MultiSelectItem.fromTitle(String title) =>
      MultiSelectItem(value: title, key: 1);

  static List<MultiSelectItem> iAgreeToAllTermsAndConditionsValue(
    BuildContext context,
  ) => [
    // MultiSelectItem.fromTitle(
    //     context.translate(LocalizationKeys.iAgreeToAllTermsAndConditions))
  ];

  @override
  List<Object?> get props => [value, key];
}

// ignore: must_be_immutable
class MultiSelectFormFieldWidget extends StatelessWidget {
  final String? title;
  final bool requiredTitle;

  final List<MultiSelectItem> items;
  final List<MultiSelectItem>? initialValue;
  final FormFieldSetter<List<MultiSelectItem>>? onSaved;
  final FormFieldValidator<List<MultiSelectItem>>? validator;
  final ValueChanged<List<MultiSelectItem>>? onChange;
  final Future<bool?> Function()? onFirstItemTap;
  final int? otherId;
  final String? otherTitle;
  final String? otherHintText;
  final String? initialOtherValue;
  final FormFieldSetter<String>? onSavedOtherId;
  final FormFieldValidator<String>? validatorOtherId;

  final String? initialAdditionalValue;
  final FormFieldSetter<String>? onSavedAdditionalId;
  final String? additionalHintText;
  final int? additionalId;
  final String? additionalTitle;
  final FormFieldValidator<String>? validatorAdditionalId;
  final bool ignoring;

  const MultiSelectFormFieldWidget({
    super.key,
    this.title,
    required this.items,
    this.onSaved,
    this.requiredTitle = true,
    this.initialValue,
    this.validator,
    this.onChange,
    this.otherTitle,
    this.otherHintText,
    this.otherId,
    this.validatorOtherId,
    this.onSavedOtherId,
    this.initialOtherValue,
    this.additionalId,
    this.validatorAdditionalId,
    this.onSavedAdditionalId,
    this.initialAdditionalValue,
    this.additionalTitle,
    this.additionalHintText,
    this.onFirstItemTap,
    this.ignoring = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null) ...[
          LabelWithAsterisk(text: title!, showAsterisk: requiredTitle),
          const SizedBox(height: 10),
        ],
        _MultiSelectFormField(
          onSaved: onSaved,
          initialValue: initialValue,
          validator: validator,
          items: items,
          onChange: onChange,
          otherId: otherId,
          otherTitle: otherTitle,
          otherHintText: otherHintText,
          validatorOtherId: validatorOtherId,
          onSavedOtherId: onSavedOtherId,
          initialOtherValue: initialOtherValue,
          additionalId: additionalId,
          validatorAdditionalId: validatorAdditionalId,
          onSavedAdditionalId: onSavedAdditionalId,
          initialAdditionalValue: initialAdditionalValue,
          additionalTitle: additionalTitle,
          additionalHintText: additionalHintText,
          onFirstItemTap: onFirstItemTap,
          ignoring: ignoring,
        ),
      ],
    );
  }
}

class _MultiSelectFormField extends StatefulWidget {
  final ValueChanged<List<MultiSelectItem>>? onChange;
  final List<MultiSelectItem> items;
  final List<MultiSelectItem>? initialValue;
  final FormFieldValidator<List<MultiSelectItem>>? validator;
  final FormFieldSetter<List<MultiSelectItem>>? onSaved;
  final String? otherTitle;
  final String? otherHintText;
  final int? otherId;
  final String? initialOtherValue;
  final FormFieldSetter<String>? onSavedOtherId;
  final FormFieldValidator<String>? validatorOtherId;
  final String? initialAdditionalValue;
  final FormFieldSetter<String>? onSavedAdditionalId;
  final String? additionalHintText;
  final int? additionalId;
  final String? additionalTitle;
  final FormFieldValidator<String>? validatorAdditionalId;
  final Future<bool?> Function()? onFirstItemTap;
  final bool ignoring;
  const _MultiSelectFormField({
    required this.onSaved,
    required this.onChange,
    required this.items,
    required this.initialValue,
    required this.validator,
    required this.otherId,
    required this.otherTitle,
    required this.otherHintText,
    required this.validatorOtherId,
    required this.onSavedOtherId,
    required this.initialOtherValue,
    required this.additionalId,
    required this.validatorAdditionalId,
    required this.onSavedAdditionalId,
    required this.initialAdditionalValue,
    required this.additionalTitle,
    required this.additionalHintText,
    required this.onFirstItemTap,
    required this.ignoring,
  });

  @override
  State<_MultiSelectFormField> createState() => __MultiSelectFormFieldState();
}

class __MultiSelectFormFieldState extends State<_MultiSelectFormField> {
  List<MultiSelectItem> selectedValue = [];
  bool firstBuild = true;

  @override
  void initState() {
    selectedValue = widget.initialValue ?? [];

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FormField(
      validator: widget.validator,
      onSaved: widget.onSaved,
      initialValue: widget.initialValue,
      builder: (FormFieldState<List<MultiSelectItem>> state) {
        void onChangedHandler(List<MultiSelectItem> value) {
          state.didChange(value);
        }

        return Builder(
          builder: (context) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Wrap(
                  children: widget.items
                      .map(
                        (item) => Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Checkbox(
                              semanticLabel: item.value,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                              fillColor: WidgetStateProperty.resolveWith(
                                getColor,
                              ),
                              value: isChecked(item),
                              onChanged: (value) {
                                if (widget.ignoring) {
                                  return;
                                }
                                _changeSelected(value, item);
                                onChangedHandler(selectedValue);
                              },
                              visualDensity: VisualDensity.compact,
                            ),
                            itemCanClickable(item)
                                ? GestureDetector(
                                    onTap: () async {
                                      if (widget.ignoring) {
                                        return;
                                      }
                                      final result = await widget.onFirstItemTap
                                          ?.call();
                                      if (result == true && !isChecked(item)) {
                                        _changeSelected(true, item);
                                        onChangedHandler(selectedValue);
                                      }
                                    },
                                    child: Text(
                                      item.value,
                                      style: TextStyle(
                                        decorationThickness: 1.5,
                                        decorationColor: AppColors.colorPrimary,
                                        decoration: TextDecoration.underline,
                                      ),
                                    ),
                                  )
                                : Text(item.value),
                            SizedBox(width: 10),
                          ],
                        ),
                      )
                      .toList(),
                ),
                state.hasError
                    ? Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Text(
                          state.errorText!,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.error,
                            fontSize: 12.0,
                          ),
                        ),
                      )
                    : Container(),
                if (showOtherField) ...[
                  SizedBox(height: 10),
                  AppTextFormField(
                    title: widget.otherTitle,
                    hintText: widget.otherHintText,
                    validator: widget.validatorOtherId,
                    onSaved: widget.onSavedOtherId,
                    initialValue: widget.initialOtherValue,
                  ),
                ],
                if (showAdditionalField) ...[
                  SizedBox(height: 10),
                  AppTextFormField(
                    title: widget.additionalTitle,
                    hintText: widget.additionalHintText,
                    validator: widget.validatorAdditionalId,
                    onSaved: widget.onSavedAdditionalId,
                    initialValue: widget.initialAdditionalValue,
                  ),
                ],
              ],
            );
          },
        );
      },
    );
  }

  bool itemCanClickable(MultiSelectItem item) {
    return (widget.items.indexWhere((element) => element.key == item.key) ==
            0) &&
        widget.onFirstItemTap != null;
  }

  bool get showOtherField =>
      widget.otherId != null &&
      selectedValue.any((item) => item.key == widget.otherId);

  bool get showAdditionalField =>
      widget.additionalId != null &&
      selectedValue.any((item) => item.key == widget.additionalId);

  void _changeSelected(bool? value, MultiSelectItem item) {
    setState(() {
      if (value ?? false) {
        selectedValue.add(item);
      } else {
        selectedValue.remove(item);
      }
      widget.onChange?.call(selectedValue);
    });
  }

  bool isChecked(MultiSelectItem item) {
    return selectedValue.contains(item);
  }

  Color getColor(Set<WidgetState> states) {
    const Set<WidgetState> interactiveStates = <WidgetState>{
      WidgetState.pressed,
      WidgetState.hovered,
      WidgetState.focused,
      WidgetState.selected,
    };
    if (states.any(interactiveStates.contains)) {
      return AppColors.checkBoxFormFieldSelectedBg;
    }
    return AppColors.checkBoxFormFieldBg;
  }
}

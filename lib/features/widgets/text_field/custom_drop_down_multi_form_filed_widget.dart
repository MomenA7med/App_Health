import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:app_health/core/widgets/base_stateless_widget.dart';
import 'package:app_health/features/widgets/label_with_asterisk_widget.dart';
import 'package:app_health/res/app_colors.dart';
import 'package:multi_dropdown/multi_dropdown.dart';

import 'app_text_form_filed_widget.dart';

class CustomDropDownMultiItem extends Equatable {
  const CustomDropDownMultiItem({required this.value, required this.label});

  final String label;
  final String value;

  @override
  List<Object?> get props => [value, label];
}

// ignore: must_be_immutable
class CustomDropDownMultiFormFiledWidget extends StatefulWidget {
  final double? dropdownMaxHeight;
  final Color? enableBorderColor;
  final Color? fillColor;
  final FocusNode? focusNode;
  final String? hintText;
  final TextStyle? hintTextStyle;
  final Color? iconColor;
  final bool ignoring;
  final String? initialOtherValue;
  final TextStyle? itemTextStyle;
  final List<CustomDropDownMultiItem>? items;
  final ValueChanged<List<CustomDropDownMultiItem>>? onChanged;
  final FormFieldSetter<List<CustomDropDownMultiItem>>? onSaved;
  final FormFieldSetter<String>? onSavedOtherId;
  final FormFieldValidator<String>? validatorOtherId;
  final String? otherHintText;
  final int? otherId;
  final String? otherTitle;
  final bool requiredTitle;
  final String? title;
  FormFieldValidator<List<DropdownItem<CustomDropDownMultiItem>>>? validator;
  final bool withBorder;

  CustomDropDownMultiFormFiledWidget({
    super.key,
    this.items,
    this.title,
    this.itemTextStyle,
    this.enableBorderColor,
    this.ignoring = false,
    this.hintText,
    this.onChanged,
    this.onSaved,
    this.validator,
    this.dropdownMaxHeight,
    this.fillColor,
    this.withBorder = true,
    this.iconColor,
    this.focusNode,
    this.hintTextStyle,
    this.requiredTitle = true,
    this.otherId,
    this.onSavedOtherId,
    this.validatorOtherId,
    this.initialOtherValue,
    this.otherTitle,
    this.otherHintText,
  });

  @override
  State<CustomDropDownMultiFormFiledWidget> createState() =>
      _CustomDropDownFormFiledWidgetState();
}

class _CustomDropDownFormFiledWidgetState
    extends State<CustomDropDownMultiFormFiledWidget> {
  List<CustomDropDownMultiItem> selectedValue = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.title != null) ...[
          LabelWithAsterisk(
            text: widget.title!,
            showAsterisk: widget.requiredTitle,
          ),
          const SizedBox(height: 10),
        ],
        MultiDropdown<CustomDropDownMultiItem>(
          fieldDecoration: FieldDecoration(
            hintText: widget.hintText,
            backgroundColor: widget.fillColor ?? AppColors.appFormFieldFill,
            hintStyle: widget.hintTextStyle ?? context.titleSmall,
            borderRadius: 10,
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(
                color: AppColors.formFieldFocusIBorder,
              ),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: AppColors.transparentColor),
            ),
          ),
          dropdownDecoration: DropdownDecoration(
            borderRadius: BorderRadius.circular(10),
            backgroundColor: widget.fillColor ?? AppColors.appFormFieldFill,
          ),
          focusNode: widget.focusNode,
          validator: widget.validator,
          items: buildDropdownList(widget.items)!,
          onSelectionChange: (value) {
            selectedValue = [];
            setState(() {
              selectedValue = value;
            });
            if (widget.onChanged != null) {
              widget.onChanged!(value);
            }
          },
        ),
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
      ],
    );
  }

  List<DropdownItem<CustomDropDownMultiItem>>? buildDropdownList(
    List<CustomDropDownMultiItem>? list,
  ) {
    return list == null || widget.ignoring
        ? null
        : list.map((CustomDropDownMultiItem item) {
            return DropdownItem(
              label: item.label,
              value: CustomDropDownMultiItem(
                value: item.value,
                label: item.label,
              ),
            );
          }).toList();
  }

  bool get showOtherField {
    return widget.otherId != null &&
        selectedValue.any((item) => item.value == widget.otherId.toString());
  }
}

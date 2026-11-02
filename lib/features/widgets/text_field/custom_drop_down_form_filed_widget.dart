// import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:equatable/equatable.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:app_health/core/widgets/base_stateless_widget.dart';
// import 'package:app_health/features/widgets/label_with_asterisk_widget.dart';
// import 'package:app_health/features/widgets/text_field/app_text_form_filed_widget.dart';
// import 'package:app_health/res/app_colors.dart';

class CustomDropDownItem extends Equatable {
  const CustomDropDownItem({required this.value, required this.key});

  final String key;
  final String value;

  @override
  List<Object?> get props => [value, key];
}

// // ignore: must_be_immutable
// class CustomDropDownFormFiledWidget extends StatefulWidget {
//   final double? dropdownMaxHeight;
//   final Color? enableBorderColor;
//   final Color? fillColor;
//   final FocusNode? focusNode;
//   final String? hintText;
//   final TextStyle? hintTextStyle;
//   final Color? iconColor;
//   final bool ignoring;
//   final String? initialOtherValue;
//   ValueListenable<CustomDropDownItem>? initialValue;
//   final TextStyle? itemTextStyle;
//   final List<CustomDropDownItem>? items;
//   final ValueChanged<CustomDropDownItem?>? onChanged;
//   final FormFieldSetter<CustomDropDownItem>? onSaved;
//   final FormFieldSetter<String>? onSavedOtherId;
//   final String? otherHintText;
//   final String? otherId;
//   final String? otherTitle;
//   final bool requiredTitle;
//   final bool otherRequiredTitle;
//   ValueListenable<CustomDropDownItem>? selectedValue;
//   final String? title;
//   FormFieldValidator<CustomDropDownItem>? validator;
//   final FormFieldValidator<String>? validatorOtherId;
//   final TextInputType? textInputType;
//   final bool withBorder;
//   CustomDropDownFormFiledWidget({
//     super.key,
//     this.items,
//     this.title,
//     this.itemTextStyle,
//     this.enableBorderColor,
//     this.ignoring = false,
//     this.hintText,
//     this.onChanged,
//     this.onSaved,
//     this.validator,
//     this.dropdownMaxHeight,
//     this.initialValue,
//     this.fillColor,
//     this.withBorder = true,
//     this.iconColor,
//     this.focusNode,
//     this.hintTextStyle,
//     this.selectedValue,
//     this.requiredTitle = true,
//     this.otherRequiredTitle = true,
//     this.otherId,
//     this.validatorOtherId,
//     this.onSavedOtherId,
//     this.initialOtherValue,
//     this.otherTitle,
//     this.otherHintText,
//     this.textInputType,
//   });

//   @override
//   State<CustomDropDownFormFiledWidget> createState() =>
//       _CustomDropDownFormFiledWidgetState();
// }

// class _CustomDropDownFormFiledWidgetState
//     extends State<CustomDropDownFormFiledWidget> {
//   ValueListenable<CustomDropDownItem>? selectedValue;
//   @override
//   void initState() {
//     selectedValue = widget.initialValue;
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         if (widget.title != null) ...[
//           LabelWithAsterisk(
//             text: widget.title!,
//             showAsterisk: widget.requiredTitle,
//           ),
//           const SizedBox(height: 10),
//         ],
//         DropdownButtonFormField2<CustomDropDownItem>(
//           decoration: InputDecoration(
//             hintStyle: widget.hintTextStyle ?? context.textTheme.labelMedium,
//             isDense: true,
//             fillColor: widget.fillColor ?? AppColors.appFormFieldFill,
//             filled: true,
//             contentPadding: EdgeInsetsDirectional.only(
//               start: 1.w,
//               end: 10.h,
//               top: 12.h,
//               bottom: 12.h,
//             ),
//             enabledBorder: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(10),
//               borderSide: BorderSide(
//                 width: 1,
//                 color:
//                     widget.enableBorderColor ??
//                     AppColors.enabledAppFormFieldBorder,
//               ),
//             ),
//             focusedBorder: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(10),
//               borderSide: const BorderSide(
//                 color: AppColors.formFieldFocusIBorder,
//               ),
//             ),
//             border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
//           ),
//           focusNode: widget.focusNode,
//           isExpanded: true,
//           hint: widget.initialValue != null
//               ? Text(
//                   widget.initialValue!.value.value,
//                   style:
//                       widget.itemTextStyle ??
//                       context.bodyMedium.copyWith(fontWeight: FontWeight.w600),
//                 )
//               : Text(
//                   widget.hintText ?? '',
//                   style: widget.hintTextStyle ?? context.titleSmall,
//                 ),
//           buttonStyleData: FormFieldButtonStyleData(padding: EdgeInsets.zero),
//           dropdownStyleData: DropdownStyleData(
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(10),
//               color: AppColors.white,
//             ),
//             offset: const Offset(0, -10),
//           ),
//           iconStyleData: IconStyleData(
//             icon: Icon(
//               Icons.keyboard_arrow_down,
//               size: 24,
//               color: widget.iconColor ?? AppColors.suffixIcon,
//             ),
//           ),
//           items: buildDropdownList(widget.items),
//           validator: widget.validator,

//           valueListenable:
//               widget.selectedValue ?? selectedValue ?? widget.initialValue,
//           style: widget.itemTextStyle,
//           selectedItemBuilder: widget.fillColor != null
//               ? (BuildContext context) {
//                   return widget.items!.map((item) {
//                     return Text(
//                       widget.selectedValue != null
//                           ? widget.selectedValue?.value.value ?? ''
//                           : widget.initialValue?.value.value ?? '',
//                       style:
//                           widget.itemTextStyle ??
//                           context.bodyMedium.copyWith(fontSize: 14),
//                     );
//                   }).toList();
//                 }
//               : null,
//           onChanged: (value) {
//             widget.initialValue = value;
//             if (widget.onChanged != null) {
//               widget.onChanged!(value);
//             }
//             setState(() {
//               selectedValue = value;
//             });
//           },
//           onSaved: widget.onSaved,
//         ),
//         if (showOtherField) ...[
//           SizedBox(height: 10),
//           AppTextFormField(
//             title: widget.otherTitle,
//             hintText: widget.otherHintText,
//             validator: widget.validatorOtherId,
//             onSaved: widget.onSavedOtherId,
//             initialValue: widget.initialOtherValue,
//             textInputType: widget.textInputType,
//             requiredTitle: widget.otherRequiredTitle,
//           ),
//         ],
//       ],
//     );
//   }

//   bool get showOtherField =>
//       widget.otherId != null && selectedValue?.key == widget.otherId;

//   List<DropdownItem<CustomDropDownItem>>? buildDropdownList(
//     List<CustomDropDownItem>? list,
//   ) {
//     return list == null || widget.ignoring
//         ? null
//         : list.map((CustomDropDownItem item) {
//             return DropdownItem<CustomDropDownItem>(
//               value: item,
//               child: Text(
//                 item.value,
//                 style: TextStyle(
//                   color: AppColors.black,
//                   fontSize: 14,
//                   fontWeight: FontWeight.w400,
//                 ),
//               ),
//             );
//           }).toList();
//   }
// }

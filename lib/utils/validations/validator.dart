import 'package:flutter/material.dart';
import 'package:app_health/features/widgets/text_field/custom_drop_down_multi_form_filed_widget.dart';
import 'package:app_health/utils/extensions/extension_string.dart';
import 'package:multi_dropdown/multi_dropdown.dart';

class Validator {
  static bool isEmail(String email) {
    const String pattern = r'^[a-zA-Z0-9._%-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';

    // const String pattern =
    //     r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

    final regExp = RegExp(pattern);

    return regExp.hasMatch(email.trim());
  }

  static bool containEmail(String text) {
    final RegExp regExp = RegExp(
      r'([a-zA-Z0-9+._-]+@[a-zA-Z0-9._-]+\.[a-zA-Z0-9_-]+)',
      multiLine: true,
    );

    return regExp.hasMatch(text);
  }

  static bool containPhoneNumber(String text) {
    // For Arabic and english Number
    // RegExp regExp = RegExp(r'^[\u0660-\u0669\s0-9]{9}', multiLine: true);
    final RegExp regExp = RegExp(r'(\d{9})', multiLine: true);

    return regExp.hasMatch(text);
  }

  static bool isNumber(String number) {
    const String pattern = r'^[0-9]+$';

    final regExp = RegExp(pattern);
    return regExp.hasMatch(number.trim());
  }

  static bool isNumberInRange(num number, num min, num max) {
    return min <= number && number <= max;
  }

  static bool isDecimal(String number) {
    const String pattern = r'^[0-9]+(([.]?[0-9]*)?|([ ]?[0-9]*[/]?[0-9]*)?)?';
    final regExp = RegExp(pattern);
    return regExp.hasMatch(number.trim());
  }

  static bool isName(String name) {
    // const String pattern = r'^[a-zA-Z]+$';
    const String pattern = r"^[a-zA-Z]+(?:[\s.'-][a-zA-Z]+)*$";

    final regExp = RegExp(pattern);
    return regExp.hasMatch(name.trim());
  }

  static bool isPassportNumber(String name) {
    const String pattern = r'^(?!^0+$)[a-zA-Z0-9]{3,20}$';
    final regExp = RegExp(pattern);
    return regExp.hasMatch(name.trim());
  }

  static bool isPassword(String password) {
    const String pattern = r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9]).{8,}$';
    final regExp = RegExp(pattern);
    return regExp.hasMatch(password.trim());
  }

  static ValidationState validateEmail(String? email) {
    if (email.isNullOrEmpty) {
      return ValidationState.empty;
    } else if (!isEmail(email!)) {
      return ValidationState.formatting;
    } else {
      return ValidationState.valid;
    }
  }

  static ValidationState validatePassword(String? password) {
    if (password.isNullOrEmpty) {
      return ValidationState.empty;
    } else if (!isPassword(password!)) {
      return ValidationState.formatting;
    } else {
      return ValidationState.valid;
    }
  }

  static ValidationState validateAuthCode(String code) {
    if (code.isNullOrEmpty) {
      return ValidationState.empty;
    } else if (code.length != 6) {
      return ValidationState.formatting;
    } else {
      return ValidationState.valid;
    }
  }

  static ValidationState validatePhoneNumber(
    String? number, {
    int length = 11,
  }) {
    print("Number: $number");
    if (number.isNullOrEmpty) {
      return ValidationState.empty;
    } else if (!isNumber(number!) ||
        number.length != length ||
        !RegExp(r'^(010|011|012|015)').hasMatch(number)) {
      return ValidationState.formatting;
    } else {
      return ValidationState.valid;
    }
  }

  static ValidationState validatePassportNumber(String? number) {
    if (number.isNullOrEmpty) {
      return ValidationState.empty;
    } else if (!isPassportNumber(number!)) {
      return ValidationState.formatting;
    } else {
      return ValidationState.valid;
    }
  }

  static ValidationState validateText(String? text) {
    if (text.isNullOrEmpty) {
      return ValidationState.empty;
    } else {
      return ValidationState.valid;
    }
  }

  static ValidationState validateNum(int? text) {
    if (text == null) {
      return ValidationState.empty;
    } else {
      return ValidationState.valid;
    }
  }

  static ValidationState validateMultiDropDown(
    List<DropdownItem<CustomDropDownMultiItem>>? list,
  ) {
    if (list == null || list.isEmpty) {
      return ValidationState.empty;
    } else {
      return ValidationState.valid;
    }
  }

  static ValidationState validateDateTime(DateTime? dateTime) {
    if (dateTime == null) {
      return ValidationState.empty;
    } else {
      return ValidationState.valid;
    }
  }

  static ValidationState validateDateTimeInRange({
    DateTime? dateTime,
    DateTime? startDate,
    DateTime? endDate,
  }) {
    if (dateTime == null) {
      return ValidationState.empty;
    }

    if (startDate != null && dateTime.isBefore(startDate)) {
      return ValidationState.formatting;
    }

    if (endDate != null && dateTime.isAfter(endDate)) {
      return ValidationState.formatting;
    }

    return ValidationState.valid;
  }

  static ValidationState validateEndDateWithStartDate({
    DateTime? startDate,
    DateTime? endDate,
    bool canBeSame = false,
  }) {
    if (startDate == null && endDate == null) {
      return ValidationState.empty;
    } else if (startDate != null && endDate != null) {
      if (endDate.isAfter(startDate) ||
          (canBeSame && endDate.isAtSameMomentAs(startDate))) {
        return ValidationState.valid;
      }
      return ValidationState.formatting;
    } else if (startDate != null && endDate == null) {
      return ValidationState.empty;
    } else {
      return ValidationState.valid;
    }
  }

  static ValidationState validateTime(TimeOfDay? dateTime) {
    if (dateTime == null) {
      return ValidationState.empty;
    } else {
      return ValidationState.valid;
    }
  }

  static ValidationState validateTextWithLength(
    String? text, {
    int length = 22,
  }) {
    if (text.isNullOrEmpty) {
      return ValidationState.empty;
    } else if (text!.length != length) {
      return ValidationState.formatting;
    } else {
      return ValidationState.valid;
    }
  }

  static ValidationState validateName(String? name) {
    if (name.isNullOrEmpty) {
      return ValidationState.empty;
    } else if (!isName(name!) || name.length > 100) {
      return ValidationState.formatting;
    } else {
      return ValidationState.valid;
    }
  }

  static ValidationState validateNumberWithLength(
    String? number, {
    int length = 9,
  }) {
    if (number.isNullOrEmpty) {
      return ValidationState.empty;
    } else if (!isNumber(number!) || number.length != length) {
      return ValidationState.formatting;
    } else {
      return ValidationState.valid;
    }
  }

  static ValidationState validateNumber(String? number) {
    if (number.isNullOrEmpty) {
      return ValidationState.empty;
    } else if (!isNumber(number!)) {
      return ValidationState.formatting;
    } else {
      return ValidationState.valid;
    }
  }

  static ValidationState validateDecimal(String? number) {
    if (number.isNullOrEmpty) {
      return ValidationState.empty;
    } else if (!isDecimal(number!)) {
      return ValidationState.formatting;
    } else {
      return ValidationState.valid;
    }
  }

  static ValidationState validateTextWithText(
    String? textNeedToValid,
    String correctText,
  ) {
    if (textNeedToValid.isNullOrEmpty) {
      return ValidationState.empty;
    } else if (textNeedToValid! != correctText) {
      return ValidationState.formatting;
    } else {
      return ValidationState.valid;
    }
  }

  static ValidationState validateEmailOrPhoneNumber(
    String? emailOrPhoneNumber,
  ) {
    if (emailOrPhoneNumber.isNullOrEmpty) {
      return ValidationState.empty;
    } else if (!isEmail(emailOrPhoneNumber!)) {
      if (isNumber(emailOrPhoneNumber) && emailOrPhoneNumber.length == 9) {
        return ValidationState.valid;
      }
      return ValidationState.formatting;
    } else {
      return ValidationState.valid;
    }
  }

  static ValidationState validateNumberRange(
    String? number, {
    required int min,
    required int max,
  }) {
    if (number.isNullOrEmpty) {
      return ValidationState.empty;
    } else if (!isNumber(number!)) {
      return ValidationState.formatting;
    } else if (!isNumberInRange(num.parse(number), min, max)) {
      return ValidationState.formatting;
    } else {
      return ValidationState.valid;
    }
  }

  static ValidationState validateList(List? list) {
    if (list == null) {
      return ValidationState.empty;
    } else if (list.isEmpty) {
      return ValidationState.formatting;
    } else {
      return ValidationState.valid;
    }
  }

  static bool isUrl(String url) {
    String pattern =
        r'(http|https)://[\w-]+(\.[\w-]+)+([\w.,@?^=%&amp;:/~+#-]*[\w@?^=%&amp;/~+#-])?';

    var regExp = RegExp(pattern);

    return regExp.hasMatch(url.trim());
  }

  static ValidationState validatePattern(String? value, String? pattern) {
    if (value.isNullOrEmpty) {
      return ValidationState.empty;
    } else if (pattern.isNullOrEmpty) {
      return ValidationState.valid;
    } else if (!RegExp(pattern!).hasMatch(value!)) {
      return ValidationState.formatting;
    } else {
      return ValidationState.valid;
    }
  }
}

enum ValidationState { empty, formatting, valid }

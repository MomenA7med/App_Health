import 'package:flutter/material.dart';
import 'package:app_health/core/extensions/extension_localization.dart';
import 'package:app_health/features/widgets/text_field/custom_drop_down_form_filed_widget.dart';
import 'package:app_health/features/widgets/text_field/custom_drop_down_multi_form_filed_widget.dart';
import 'package:app_health/utils/format/app_date_format.dart';
import 'package:app_health/utils/locale/app_localization_keys.dart';
import 'package:app_health/utils/validations/validator.dart';
import 'package:multi_dropdown/multi_dropdown.dart';

mixin AppValidate<T extends StatefulWidget> on State<T> {
  String? textValidator(String? value) {
    final ValidationState validationState = Validator.validateText(value);
    switch (validationState) {
      case ValidationState.empty:
        return context.translate(LocalizationKeys.required);
      case ValidationState.formatting:
        return context.translate(LocalizationKeys.wrongFormat);
      case ValidationState.valid:
        return null;
    }
  }

  String? textValidatorOptional(String? value) {
    final ValidationState validationState = Validator.validateText(value);
    switch (validationState) {
      case ValidationState.formatting:
        return context.translate(LocalizationKeys.wrongFormat);
      case ValidationState.empty:
      case ValidationState.valid:
        return null;
    }
  }

  String? dropDownValidator(CustomDropDownItem? value) {
    final ValidationState validationState = Validator.validateText(value?.key);
    switch (validationState) {
      case ValidationState.empty:
      case ValidationState.formatting:
        return context.translate(LocalizationKeys.required);
      case ValidationState.valid:
        return null;
    }
  }

  String? dropDownValidatorOptional(CustomDropDownItem? value) {
    final ValidationState validationState = Validator.validateText(value?.key);
    switch (validationState) {
      case ValidationState.formatting:
        return context.translate(LocalizationKeys.required);
      case ValidationState.empty:
      case ValidationState.valid:
        return null;
    }
  }

  String? multiDropDownValidator(
    List<DropdownItem<CustomDropDownMultiItem>>? value,
  ) {
    final ValidationState validationState = Validator.validateMultiDropDown(
      value,
    );
    switch (validationState) {
      case ValidationState.empty:
      case ValidationState.formatting:
        return context.translate(LocalizationKeys.required);
      case ValidationState.valid:
        return null;
    }
  }

  String? dateTimeValidator(DateTime? value) {
    final ValidationState validationState = Validator.validateDateTime(value);
    switch (validationState) {
      case ValidationState.empty:
      case ValidationState.formatting:
        return context.translate(LocalizationKeys.required);
      case ValidationState.valid:
        return null;
    }
  }

  String? dateTimeValidatorInRange({
    DateTime? value,
    DateTime? startDate,
    DateTime? endDate,
  }) {
    final ValidationState validationState = Validator.validateDateTimeInRange(
      dateTime: value,
      startDate: startDate,
      endDate: endDate,
    );
    switch (validationState) {
      case ValidationState.empty:
      // return context.translate(LocalizationKeys.required);
      case ValidationState.formatting:
        final String? startText = startDate == null
            ? null
            : AppDateFormat.formattingShortDayMonthYear(
                startDate,
                context.languageCode,
              );
        final String? endText = endDate == null
            ? null
            : AppDateFormat.formattingShortDayMonthYear(
                endDate,
                context.languageCode,
              );
        final List<String> periodParts = [
          if (startText != null) startText,
          if (endText != null) endText,
        ];
        final String periodText = periodParts.isEmpty
            ? ''
            : ' (${periodParts.join(' - ')})';
        return '${context.translate(LocalizationKeys.dateMustBeWithinPeriod)}$periodText';
      case ValidationState.valid:
        return null;
    }
  }

  String? dateTimeValidatorOptional(DateTime? value) {
    final ValidationState validationState = Validator.validateDateTime(value);
    switch (validationState) {
      case ValidationState.formatting:
        return context.translate(LocalizationKeys.required);
      case ValidationState.empty:
      case ValidationState.valid:
        return null;
    }
  }

  String? endDateValidator({
    DateTime? startDate,
    DateTime? endDate,
    bool canBeSame = false,
  }) {
    ValidationState validationState = Validator.validateEndDateWithStartDate(
      startDate: startDate,
      endDate: endDate,
      canBeSame: canBeSame,
    );
    switch (validationState) {
      case ValidationState.empty:
        return context.translate(LocalizationKeys.required);
      case ValidationState.formatting:
        return context.translate(LocalizationKeys.endDateMustBeAfterStartDate);
      case ValidationState.valid:
        return null;
    }
  }

  String? timeValidator(TimeOfDay? value) {
    final ValidationState validationState = Validator.validateTime(value);
    switch (validationState) {
      case ValidationState.empty:
      case ValidationState.formatting:
        return context.translate(LocalizationKeys.required);
      case ValidationState.valid:
        return null;
    }
  }

  String? timeValidatorOptional(TimeOfDay? value) {
    final ValidationState validationState = Validator.validateTime(value);
    switch (validationState) {
      case ValidationState.formatting:
        return context.translate(LocalizationKeys.invalidTime);
      case ValidationState.empty:
      case ValidationState.valid:
        return null;
    }
  }

  String? textValidatorWithLength(String? value) {
    final ValidationState validationState = Validator.validateTextWithLength(
      value,
    );
    switch (validationState) {
      case ValidationState.empty:
        return context.translate(LocalizationKeys.required);
      case ValidationState.formatting:
        return context.translate(LocalizationKeys.wrongFormat);
      case ValidationState.valid:
        return null;
    }
  }

  String? numberValidator(String? value) {
    final ValidationState validationState = Validator.validateNumber(value);
    switch (validationState) {
      case ValidationState.empty:
        return context.translate(LocalizationKeys.required);
      case ValidationState.formatting:
        return context.translate(LocalizationKeys.wrongFormat);
      case ValidationState.valid:
        return null;
    }
  }

  String? numberValidatorOptional(String? value) {
    final ValidationState validationState = Validator.validateNumber(value);
    switch (validationState) {
      case ValidationState.formatting:
        return context.translate(LocalizationKeys.wrongFormat);
      case ValidationState.empty:
      case ValidationState.valid:
        return null;
    }
  }

  String? numberValidatorWithLength(
    BuildContext context,
    String? value,
    int length,
  ) {
    final ValidationState validationState = Validator.validateNumberWithLength(
      value,
      length: length,
    );
    switch (validationState) {
      case ValidationState.empty:
        return context.translate(LocalizationKeys.required);
      case ValidationState.formatting:
        return context.translate(LocalizationKeys.wrongFormat);
      case ValidationState.valid:
        return null;
    }
  }

  String? decimalNumberValidator(String? value) {
    final ValidationState validationState = Validator.validateDecimal(value);
    switch (validationState) {
      case ValidationState.empty:
        return context.translate(LocalizationKeys.required);
      case ValidationState.formatting:
        return context.translate(LocalizationKeys.wrongFormat);
      case ValidationState.valid:
        return null;
    }
  }

  String? decimalNumberValidatorOptional(String? value) {
    final ValidationState validationState = Validator.validateDecimal(value);
    switch (validationState) {
      case ValidationState.formatting:
        return context.translate(LocalizationKeys.wrongFormat);
      case ValidationState.empty:
      case ValidationState.valid:
        return null;
    }
  }

  String? validateNumberRange(String? value, {int min = 1, int max = 100}) {
    final ValidationState validationState = Validator.validateNumberRange(
      value,
      min: min,
      max: max,
    );
    switch (validationState) {
      case ValidationState.empty:
        return context.translate(LocalizationKeys.required);
      case ValidationState.formatting:
        return "${context.translate(LocalizationKeys.enterNumberBetween)} $min : $max";
      case ValidationState.valid:
        return null;
    }
  }

  String? validateNullableNumberRange(
    String? value, {
    int min = 1,
    int max = 100,
  }) {
    final ValidationState validationState = Validator.validateNumberRange(
      value,
      min: min,
      max: max,
    );
    switch (validationState) {
      case ValidationState.formatting:
        return "${context.translate(LocalizationKeys.enterNumberBetween)} $min : $max";
      case ValidationState.empty:
      case ValidationState.valid:
        return null;
    }
  }

  String? emailOrPhoneNumberValidator(String? value) {
    final ValidationState validationState =
        Validator.validateEmailOrPhoneNumber(value);
    switch (validationState) {
      case ValidationState.empty:
        return context.translate(LocalizationKeys.required);
      case ValidationState.formatting:
        return context.translate(LocalizationKeys.emailInvalid);
      case ValidationState.valid:
        return null;
    }
  }

  String? emailValidator(String? value) {
    final ValidationState validationState = Validator.validateEmail(value);
    switch (validationState) {
      case ValidationState.empty:
        return context.translate(LocalizationKeys.required);
      case ValidationState.formatting:
        return context.translate(LocalizationKeys.emailInvalid);
      case ValidationState.valid:
        return null;
    }
  }

  String? phoneNumberValidator(String? value) {
    final ValidationState validationState = Validator.validatePhoneNumber(
      value,
      length: 11,
    );
    switch (validationState) {
      case ValidationState.empty:
        return context.translate(LocalizationKeys.required);
      case ValidationState.formatting:
        return context.translate(LocalizationKeys.phoneNumberInvalid);
      case ValidationState.valid:
        return null;
    }
  }

  String? phoneNumberValidatorOptional(String? value) {
    final ValidationState validationState = Validator.validatePhoneNumber(
      value,
      length: 12,
    );
    switch (validationState) {
      case ValidationState.formatting:
        return context.translate(LocalizationKeys.phoneNumberInvalid);
      case ValidationState.empty:
      case ValidationState.valid:
        return null;
    }
  }

  String? confirmPasswordValidator(
    BuildContext context,
    String? value,
    String password,
  ) {
    final ValidationState validationState = Validator.validateTextWithText(
      value,
      password,
    );
    switch (validationState) {
      case ValidationState.empty:
        return context.translate(LocalizationKeys.required);
      case ValidationState.formatting:
        return context.translate(LocalizationKeys.passMatch);
      case ValidationState.valid:
        return null;
    }
  }

  String? passwordValidator(String? value) {
    final ValidationState validationState = Validator.validatePassword(value);
    switch (validationState) {
      case ValidationState.empty:
        return context.translate(LocalizationKeys.required);
      case ValidationState.formatting:
      //return context.translate(LocalizationKeys.passInvalid);
      case ValidationState.valid:
        return null;
    }
  }

  String? fullNameValidator(String? value) {
    final ValidationState validationState = Validator.validateName(value);
    switch (validationState) {
      case ValidationState.empty:
        return context.translate(LocalizationKeys.required);
      case ValidationState.formatting:
        return context.translate(LocalizationKeys.nameInvalid);
      case ValidationState.valid:
        return null;
    }
  }

  String? otpValidator(String? value) {
    final ValidationState validationState = Validator.validateNumberWithLength(
      value,
      length: 6,
    );
    switch (validationState) {
      case ValidationState.empty:
        return context.translate(LocalizationKeys.required);
      case ValidationState.formatting:
        return context.translate(LocalizationKeys.checkOtpCode);
      case ValidationState.valid:
        return null;
    }
  }

  String? patternValidatorOptional(String? value, String? pattern) {
    final ValidationState validationState = Validator.validatePattern(
      value,
      pattern,
    );
    switch (validationState) {
      case ValidationState.formatting:
        return context.translate(LocalizationKeys.required);
      case ValidationState.empty:
      case ValidationState.valid:
        return null;
    }
  }
}

extension ConcatenateAsterisk on String {
  String get concatenateAsterisk {
    return "$this *";
  }
}

extension ConcatenateColumn on String {
  String get concatenateColumn {
    return "$this:";
  }
}

extension ConcatenateExclamation on String {
  String get concatenateExclamation {
    return "$this!";
  }
}

extension ConcatenateComma on String {
  String get concatenateComma {
    return "$this,";
  }
}

extension ConcatenateDash on String {
  String get concatenateDash {
    return "$this-";
  }
}

extension ConcatenateSpace on String {
  String get concatenateSpace {
    return "$this ";
  }
}

extension ConcatenateNewLine on String {
  String get concatenateNewline {
    return "$this\n";
  }
}

extension ConcatenateBrackets on String {
  String get concatenateBrackets {
    return "($this)";
  }
}

extension ConcatenateQuestionMarkEnglish on String {
  String get concatenateQuestionMarkEnglish {
    return "$this?";
  }
}

extension ConcatenateDollarSign on String {
  String get concatenateDollarSign {
    return "\$$this";
  }
}

extension ConcatenateQuestionMarkArabic on String {
  String get concatenateQuestionMarkArabic {
    return "$this؟";
  }
}

extension ConcatenateDot on String {
  String get concatenateDot {
    return "• $this";
  }
}

extension Validation on String? {
  bool get isNullOrEmpty => (this != null && this!.isNotEmpty) ? false : true;

  bool get isNotNullOrNotEmpty =>
      (this != null && this!.isNotEmpty) ? true : false;
}

extension StringExtension on String {
  String get capitalize {
    return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
  }
}

extension RemoveBracket on String {
  String get removeBracket {
    return replaceAll("[", "").replaceAll("]", "");
  }
}

extension RemoveParentheses on String {
  String get removeParentheses {
    return replaceAll("(", "").replaceAll(")", "");
  }
}

extension ArabicNumberConverter on String {
  static const Map<String, String> arabicDigits = <String, String>{
    '0': '\u0660',
    '1': '\u0661',
    '2': '\u0662',
    '3': '\u0663',
    '4': '\u0664',
    '5': '\u0665',
    '6': '\u0666',
    '7': '\u0667',
    '8': '\u0668',
    '9': '\u0669',
  };

  String toArabicDigitsConverter() {
    final String number = toString();
    final StringBuffer sb = StringBuffer();
    for (int i = 0; i < number.length; i++) {
      sb.write(arabicDigits[number[i]] ?? number[i]);
    }
    return sb.toString();
  }
}

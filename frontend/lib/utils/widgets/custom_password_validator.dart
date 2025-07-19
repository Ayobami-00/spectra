class CustomPasswordValidator {
  static bool required(String? value) {
    if (value == null) {
      return false;
    }
    if (value.isEmpty) {
      return false;
    } else {
      return true;
    }
  }

  static bool minLength(int minLength, String? value) {
    if (value == null) {
      return false;
    }
    if (value.isEmpty) return false;

    if (value.length < minLength) {
      return false;
    } else {
      return true;
    }
  }

  static bool patternRegExp(RegExp pattern, String? value) {
    if (value == null) {
      return false;
    }
    if (value.isEmpty) return false;

    if (pattern.hasMatch(value)) {
      return true;
    } else {
      return false;
    }
  }
}

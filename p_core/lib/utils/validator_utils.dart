class ValidatorUtils {
  const ValidatorUtils._();

  static bool isEmail(String text) {
    return isValidEmail(text);
  }

  static bool isValidEmail(String? email) {
    if (email == null) {
      return false;
    }
    const String emailValidationRule =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    final RegExp regExp = RegExp(emailValidationRule);
    return regExp.hasMatch(email);
  }

  static bool isValidPassword(String? password) {
    return (password?.length ?? 0) > 5;
  }

  static bool isValidMfaCode(String? mfaCode) {
    if (mfaCode?.length != 6) {
      return false;
    }

    const String mfaCodeValidationRule = r'^[0-9]{6}$';
    final RegExp regExp = RegExp(mfaCodeValidationRule);
    return regExp.hasMatch(mfaCode!);
  }

  static bool isValidUrl(String? url) {
    if (url == null) {
      return false;
    }
    const String urlValidationRegex = r"^(?:http(s)?:\/\/)?[\w.-]+(?:\.[\w\.-]+)+[\w\-\._~:/?#[\]@!\$&'\(\)\*\+,;=.]+$";
    final RegExp regExp = RegExp(urlValidationRegex, caseSensitive: false);
    return regExp.hasMatch(url);
  }

  static bool isValidPhone(String? phoneNumber) {
    return (phoneNumber?.length ?? 0) > 7 && (phoneNumber?.length ?? 0) < 18;
  }

  static bool isValidRequiredField(String? requiredField) {
    if (requiredField == null) {
      return false;
    }

    if (requiredField.trim().isEmpty) {
      return false;
    }
    return true;
  }
}

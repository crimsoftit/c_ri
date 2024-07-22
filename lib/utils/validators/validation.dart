class CValidator {
  /* ========== empty text validation ========== */
  static String? validateEmptyText(String? fieldName, String? value) {
    if (value == null || value.isEmpty) {
      return '$fieldName field is required!';
    }

    return null;
  }

  /* ========== full name field validation ========== */
  static String? validateFullName(String? fieldName, String? value) {
    if (value == null || value.isEmpty) {
      return '$fieldName field is required!';
    } else if (value.length <= 3) {
      return '$fieldName entry is too short!';
    }

    return null;
  }

  /* ========== validate email ========== */
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'email is required!';
    }

    // -- regular expression for email validation --
    final emailRegExp = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

    if (!emailRegExp.hasMatch(value)) {
      return 'invalid e-mail address!';
    }

    return null;
  }

  /* ========== validate phone number ========== */
  static String? validatePhoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'phone number is required!';
    }

    // -- regular expression for phone number validation (assuming a 10-digits US phone no. format) --
    final phoneNoRegExp = RegExp(r'^\d{10}$');

    if (!phoneNoRegExp.hasMatch(value)) {
      return 'invalid phone no. format (10 digits required)';
    }

    return null;
  }

  /* ========== validate password ========== */
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'password is required!';
    }

    // -- check for minimum password length --
    if (value.length < 6) {
      return 'password must be at least 6 characters long';
    }

    // -- check for uppercase letters --
    if (!value.contains(RegExp(r'[A-Z]'))) {
      return 'password must contain at least one UPPERCASE letter';
    }

    // -- check for numbers --
    if (!value.contains(RegExp(r'[0-9]'))) {
      return 'password must contain at least one number';
    }

    // -- check for special characters --
    if (!value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
      return 'password must contain at least one special character';
    }

    return null;
  }

  static String? validateConfirmPassword(
      String? originalPswdTxt, String? confirmPswdTxt) {
    if (confirmPswdTxt == null || confirmPswdTxt.isEmpty) {
      return 'please retype password!';
    } else if (confirmPswdTxt != originalPswdTxt) {
      return 'passwords do not match!';
    }
    return null;
  }
}

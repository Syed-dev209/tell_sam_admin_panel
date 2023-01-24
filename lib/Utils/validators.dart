class Validators {
  static String? requiredValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'This is a required field*';
    }
    return null;
  }

  static String? lengthValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'This is a required field*';
    }
    if (value.length != 4) {
      return 'Length should be 4';
    }
    return null;
  }
}

class Validators {
  static String? requiredValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'This is a required field*';
    }
    return null;
  }
}

class Validators {
   String? validateUsername(value) {
    if (value!.isEmpty) {
                    return 'please enter your name';
                  }
                  return null;
  }
  String? validateEmail(value) {
    if (value!.isEmpty) {
      return "please enter your password";
    }
    RegExp emailRegExp = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

    if (!emailRegExp.hasMatch(value)) {
      return 'please enter a valid email';
    }
    return null;
  }

  String? validatePhone(String? value) {
    // Check if the value is null or empty
    if (value == null || value.isEmpty) {
      return "Please enter your phone number";
    }

    // Check if the length is exactly 10
    if (value.length != 10) {
      return 'Please enter a 10-digit phone number';
    }

    // Check if the value contains only digits
    if (!RegExp(r'^\d+$').hasMatch(value)) {
      return 'Please enter only digits';
    }

    return null; // Return null if all validations pass
  }
 String?  validatePassword(String? value){
  if(value!.length<8){
    return 'password should be atleast 8 letters';
  }
  return null;
 }
}
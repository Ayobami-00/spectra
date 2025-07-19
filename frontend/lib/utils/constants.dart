import 'package:frontend/utils/index.dart';
import 'package:flutter/material.dart';

class AppConstants {
  // Color Constants
  static Color appWhite = HexColor("#FFFFFF");
  static Color appBlack = HexColor("#000000");
  static Color appPrimaryColor = HexColor("#2FE784");
  static Color appPrimaryColor5 = HexColor("#F9F8F3");
  static Color appPrimaryColor4 = HexColor("#F0CF5F");
  static Color appPrimaryColor3 = HexColor("#F4DB87");
  static Color appPrimaryColor2 = HexColor("#F9EDC3");
  static Color appPrimaryColor1 = HexColor("#FDF9EB");

  static Color appSecondaryColor = HexColor("#141416");
  static Color appSecondaryColor4 = HexColor("#434345");
  static Color appSecondaryColor3 = HexColor("#727273");
  static Color appSecondaryColor2 = HexColor("#B9B9B9");
  static Color appSecondaryColor1 = HexColor("#E7E7E8");

  static Color appErrorColor = HexColor("#EB001B");
  static Color appPasswordValidateSuccesss = HexColor("#70D258");
  static Color appTertiaryColor = HexColor("#FAFAFA");
  static Color splashScreenBackgroundRed = HexColor("#FF0000");
  static Color onboardingPageButtonColor = HexColor("#FF5C5C");
  static Color onboardingPageSelectedPageColor = HexColor("#FF5C5C");
  static Color onboardingPageDeselectedPageColor = HexColor("#E5E5E5");
  static Color appTextFormFieldBackgroundColor = HexColor("#F3F3F3");
  static Color appTextFormFieldHintColor = HexColor("#ACACAC");
  static Color appClickableLinkColor = HexColor('#0000FF');
  static Color appBottomsheetTextColor = HexColor('#828282');
  static Color appBottomsheetBackgroundColor = HexColor('#FDFFE8');
  static Color appPrimaryColorAlternative = HexColor('#83edb8');
  static Color appMenuTextColor = HexColor('#616161');

  static Color appShimmerBaseColor = Colors.grey[300]!;

  static Color appShimmerHighlightColor = Colors.grey[100]!;

  static const defaultErrorMessage =
      "Something went wrong,\n please try again !";

  // OTHER API SERVICES BASE URL
  static const authenticationServiceBaseUrl =
      "https://bridgecard-auth-service-dev-vbdndeke7q-uc.a.run.app";

  static const userManagementServiceBaseUrl =
      "https://user-management-image-vbdndeke7q-uc.a.run.app";

  static double getAppHeight(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }

  static double getWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  static double getUserPreferredFont(BuildContext context) {
    return MediaQuery.of(context).textScaler.scale(3.0);
  }

  static double pageButtonWIdth(BuildContext context) {
    return getWidth(context) * 0.82;
  }

  static double pageButtonHeight(BuildContext context) {
    return getAppHeight(context) * 0.072;
  }

  static double textFieldHeight(BuildContext context) {
    return (getAppHeight(context) * 0.08) * 1.3;
  }

  static double textFieldWidth(BuildContext context) {
    return getWidth(context) * 0.8;
  }

  static const appName = "Spectra";

  static const overviewPageDisplayName = "Overview";

  static const tasksPageDisplayName = "Customer";
  static const auditsPageDisplayName = "Audit";

  static const appLogoImageAssetPath = "icons/app_logo/app_logo.png";
  static const appLogoImagePath = "icons/app_logo/app_logo.png";

  static const signInText = "Sign In";
  static const signUpText = "Sign Up";

  static const confirmText = "Confirm";

  static const firstNameText = "First Name*";

  static const lastNameText = "Last Name*";

  static const workEmailText = "Work Email*";

  static const phoneNumberText = "Phone Number*";

  static const companyNameText = "Company Name*";

  static const passwordText = "Password*";

  static const createAnAccountCaptionText =
      "Create an account to start using Spectra.";

  static const signInCaptionText = "Welcome back, please fill in your details.";

  static const signInNewToBridgecardText = "New to Bridgecard?";

  static const otpVerificationTitleText = "Check your mail!";

  static const otpVerificationCaptionText = "We sent an OTP code to your mail";

  static const otpVerificationResendOtpText = "Resend Otp";

  static const fieldIsRequiredValidatorString = "Field cannot be empty!";

  static const defaultUserFirstNameLength = 2;

  static const defaultPasswordLength = 8;

  static const invalidPasswordValidatorString = "Minimum of eight characters!";

  static const invalidFirstNameValidatorString = "Minimum of two characters!";

  // Regex Constants
  static final atLeastOneNumberRegex = RegExp("(?=.*?[0-9])");
  static final atLeastALowerCaseRegex = RegExp("(?=.*[a-z])");
  static final atLeastASymbolRegex =
      RegExp("(?=.*?[!¿§«»ω⊙¤°@{}%^℃℉€¥£¢¡®©@#\$&*~])");

  // static final atLeastASymbolRegex = RegExp("(?=.*?[`!@#\$&*~/:;()-“.,?’[]{}%^=_])");
  static final atLeastAnUppercaseRegex = RegExp("(?=.*[A-Z])");
  static final validAppEmailRegex = RegExp(
    r"""^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+""",
  );

  // PasswordValidator Texts
  static const atLeast8CharactersPasswordValidatorText = "8 characters";
  static const atLeastOneNumberPasswordValidatorText = "number 1, 2, 3, etc.";
  static const atLeastALowerCasePasswordValidatorText =
      "lowercase character \na, b, c";
  static const atLeastASymbolPasswordValidatorText = "symbol/sign \$&*^%#";
  static const atLeastAnUppercasePasswordValidatorText =
      "uppercase character \nA, B, C";

  static const invaidEmailValueValidatorString =
      "Please enter a valid email address !";

  static const passwordValidatorTitleText =
      'Password should contain at least :';

  static const invaidValueValidatorString = "Invalid Value !";

  static const textFieldEyeCloseIcon = "icons/text_field/eye_close.svg";

  static const textFieldEyeOpenIcon = "icons/text_field/eye_open.svg";

  static const unableToSendOtpErrorMessage =
      "Unable to send otp, please try to resend";

  static const otpSentSuccessfullyMessage = "Otp sent successfully";

  static const nA = "N/A";

  static const whatsAppBotNumber = "+16506487230";

  static const appLogoPath = "icons/app_logo/app_logo.png";

  static const authUsecaseTypeAssignmeProfileSetup = "assignme_profile_setup";

  static const initialTaskDescription =
      "Complete profile setup to unlock tasks";

  static const userMessageRole = "user";
  static const assistantMessageRole = "assistant";

  static const maxMessagesReachedMessage =
      "You have reached the maximum number of messages. Please start a new session.";

  static const maxSessionsReachedMessage =
      "You have reached the maximum number of sessions.";
}

enum PasswordValidatorCases {
  atLeast8Characters,
  atLeastOneNumber,
  atLeastALowerCase,
  atLeastASymbol,
  atLeastAnUppercase,
}

// ignore_for_file: prefer_null_aware_method_calls

import 'dart:async';

import 'package:frontend/utils/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
// ignore: implementation_imports
import 'package:intl_phone_number_input/src/models/country_list.dart';
// ignore: implementation_imports
import 'package:intl_phone_number_input/src/models/country_model.dart';
// ignore: implementation_imports
import 'package:intl_phone_number_input/src/providers/country_provider.dart';
// ignore: implementation_imports
import 'package:intl_phone_number_input/src/utils/formatter/as_you_type_formatter.dart';
// ignore: implementation_imports
import 'package:intl_phone_number_input/src/utils/phone_number.dart';
// ignore: implementation_imports
import 'package:intl_phone_number_input/src/utils/phone_number/phone_number_util.dart';
// ignore: implementation_imports
import 'package:intl_phone_number_input/src/utils/selector_config.dart';
// ignore: implementation_imports
import 'package:intl_phone_number_input/src/utils/test/test_helper.dart';
// ignore: implementation_imports
import 'package:intl_phone_number_input/src/utils/util.dart';
// ignore: implementation_imports
import 'package:intl_phone_number_input/src/utils/widget_view.dart';
// ignore: implementation_imports

/// Enum for [CustomSelectorButton] types.
///
/// Available type includes:
///   * [PhoneInputSelectorType.DROPDOWN]
///   * [PhoneInputSelectorType.BOTTOM_SHEET]
///   * [PhoneInputSelectorType.DIALOG]
// ignore: constant_identifier_names
enum PhoneInputSelectorType { DROPDOWN, BOTTOM_SHEET, DIALOG }

/// A [TextFormField] for [CustomInternationalPhoneInput].
///
/// [initialValue] accepts a [PhoneNumber] this is used to set initial values
/// for phone the input field and the selector button
///
/// [selectorButtonOnErrorPadding] is a double which is used to align the selector
/// button with the input field when an error occurs
///
/// [locale] accepts a country locale which will be used to translation, if the
/// translation exist
///
/// [countries] accepts list of string on Country isoCode, if specified filters
/// available countries to match the [countries] specified.
class CustomInternationalPhoneInput extends StatefulWidget {
  final SelectorConfig selectorConfig;

  final ValueChanged<PhoneNumber>? onInputChanged;
  final ValueChanged<bool>? onInputValidated;

  final VoidCallback? onSubmit;
  final ValueChanged<String>? onFieldSubmitted;
  final String? Function(String?)? validator;
  final ValueChanged<PhoneNumber>? onSaved;

  final TextEditingController? textFieldController;
  final TextInputType keyboardType;
  final TextInputAction? keyboardAction;

  final PhoneNumber? initialValue;
  final String? labelText;
  final String? errorMessage;

  final double selectorButtonOnErrorPadding;

  /// Ignored if [setSelectorButtonAsPrefixIcon = true]
  final double spaceBetweenSelectorAndTextField;
  final int maxLength;

  final bool isEnabled;
  final bool formatInput;
  final bool autoFocus;
  final bool autoFocusSearch;
  final AutovalidateMode autoValidateMode;
  final bool ignoreBlank;
  final bool countrySelectorScrollControlled;

  final String? locale;

  final TextStyle? textStyle;
  final InputBorder? inputBorder;
  final InputDecoration? inputDecoration;
  final InputDecoration? searchBoxDecoration;
  final Color? cursorColor;
  final Color? fillColor;
  final TextAlign textAlign;
  final TextAlignVertical textAlignVertical;
  final EdgeInsets scrollPadding;

  final FocusNode? focusNode;
  final Iterable<String>? autofillHints;

  final List<String>? countries;

  const CustomInternationalPhoneInput({
    super.key,
    this.selectorConfig = const SelectorConfig(),
    required this.onInputChanged,
    this.onInputValidated,
    this.onSubmit,
    this.onFieldSubmitted,
    this.validator,
    this.onSaved,
    this.textFieldController,
    this.keyboardAction,
    this.keyboardType = TextInputType.phone,
    this.initialValue,
    this.labelText = 'Phone number',
    this.errorMessage = 'Invalid phone number',
    this.selectorButtonOnErrorPadding = 24,
    this.spaceBetweenSelectorAndTextField = 0,
    this.maxLength = 15,
    this.isEnabled = true,
    this.formatInput = true,
    this.autoFocus = false,
    this.autoFocusSearch = false,
    this.fillColor,
    this.autoValidateMode = AutovalidateMode.onUserInteraction,
    this.ignoreBlank = false,
    this.countrySelectorScrollControlled = true,
    this.locale,
    this.textStyle,
    this.inputBorder,
    this.inputDecoration,
    this.searchBoxDecoration,
    this.textAlign = TextAlign.start,
    this.textAlignVertical = TextAlignVertical.center,
    this.scrollPadding = const EdgeInsets.all(20.0),
    this.focusNode,
    this.cursorColor,
    this.autofillHints,
    this.countries,
  });

  @override
  State<StatefulWidget> createState() => _InputWidgetState();
}

class _InputWidgetState extends State<CustomInternationalPhoneInput> {
  TextEditingController? controller;
  double selectorButtonBottomPadding = 0;

  Country? country;
  List<Country> countries = [];
  bool isNotValid = true;

  @override
  void initState() {
    super.initState();
    loadCountries();
    controller = widget.textFieldController ?? TextEditingController();
    initialiseWidget();
  }

  @override
  void setState(Function() fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  Widget build(BuildContext context) {
    return _InputWidgetView(
      inputWidgetState: this,
    );
  }

  @override
  void didUpdateWidget(CustomInternationalPhoneInput oldWidget) {
    loadCountries(previouslySelectedCountry: country);
/*     if (oldWidget.initialValue?.hash != widget.initialValue?.hash) {
      if (country!.alpha2Code != widget.initialValue?.isoCode) {
        loadCountries();
      }
      initialiseWidget();
    } */
    super.didUpdateWidget(oldWidget);
  }

  /// [initialiseWidget] sets initial values of the widget
  // ignore: avoid_void_async
  void initialiseWidget() async {
    if (widget.initialValue != null) {
      if (widget.initialValue!.phoneNumber != null &&
          widget.initialValue!.phoneNumber!.isNotEmpty &&
          (await PhoneNumberUtil.isValidNumber(
            phoneNumber: widget.initialValue!.phoneNumber!,
            isoCode: widget.initialValue!.isoCode!,
          ))!) {
        final String phoneNumber =
            await PhoneNumber.getParsableNumber(widget.initialValue!);

        controller!.text = widget.formatInput
            ? phoneNumber
            : phoneNumber.replaceAll(RegExp(r'[^\d+]'), '');

        phoneNumberControllerListener();
      }
    }
  }

  /// loads countries from [Countries.countryList] and selected Country
  void loadCountries({Country? previouslySelectedCountry}) {
    if (mounted) {
      List<Country> countries =
          CountryProvider.getCountriesData(countries: widget.countries);

      final Country country = previouslySelectedCountry ??
          Utils.getInitialSelectedCountry(
            countries,
            widget.initialValue?.isoCode ?? '',
          );

      // Remove potential duplicates
      countries = countries.toSet().toList();

      final CountryComparator? countryComparator =
          widget.selectorConfig.countryComparator;
      if (countryComparator != null) {
        countries.sort(countryComparator);
      }

      setState(() {
        this.countries = countries;
        this.country = country;
      });
    }
  }

  /// Listener that validates changes from the widget, returns a bool to
  /// the `ValueCallback` [widget.onInputValidated]
  void phoneNumberControllerListener() {
    if (mounted) {
      final String parsedPhoneNumberString =
          controller!.text.replaceAll(RegExp(r'[^\d+]'), '');

      getParsedPhoneNumber(parsedPhoneNumberString, country?.alpha2Code)
          .then((phoneNumber) {
        if (phoneNumber == null) {
          final String phoneNumber =
              '${country?.dialCode}$parsedPhoneNumberString';

          if (widget.onInputChanged != null) {
            widget.onInputChanged!(
              PhoneNumber(
                phoneNumber: phoneNumber,
                isoCode: country!.alpha2Code,
                dialCode: country!.dialCode,
              ),
            );
          }

          if (widget.onInputValidated != null) {
            widget.onInputValidated!(false);
          }
          isNotValid = true;
        } else {
          if (widget.onInputChanged != null) {
            widget.onInputChanged!(
              PhoneNumber(
                phoneNumber: phoneNumber,
                isoCode: country?.alpha2Code,
                dialCode: country?.dialCode,
              ),
            );
          }

          if (widget.onInputValidated != null) {
            widget.onInputValidated!(true);
          }
          isNotValid = false;
        }
      });
    }
  }

  /// Returns a formatted String of [phoneNumber] with [isoCode], returns `null`
  /// if [phoneNumber] is not valid or if an [Exception] is caught.
  Future<String?> getParsedPhoneNumber(
    String phoneNumber,
    String? isoCode,
  ) async {
    if (phoneNumber.isNotEmpty && isoCode != null) {
      try {
        final bool? isValidPhoneNumber = await PhoneNumberUtil.isValidNumber(
          phoneNumber: phoneNumber,
          isoCode: isoCode,
        );

        if (isValidPhoneNumber!) {
          return await PhoneNumberUtil.normalizePhoneNumber(
            phoneNumber: phoneNumber,
            isoCode: isoCode,
          );
        }
      } on Exception {
        return null;
      }
    }
    return null;
  }

  /// Creates or Select [InputDecoration]
  InputDecoration getInputDecoration(InputDecoration? decoration) {
    final InputDecoration value = decoration ??
        InputDecoration(
          border: InputBorder.none,
          hintText: widget.labelText,
          hintStyle: Theme.of(context).textTheme.labelSmall!.copyWith(
                fontSize: 5.0.sp,
                color: AppConstants.appSecondaryColor,
                fontWeight: FontWeight.normal,
              ),
          contentPadding: EdgeInsets.only(bottom: 13.0.h),
        );

    if (widget.selectorConfig.setSelectorButtonAsPrefixIcon) {
      return value.copyWith(
        prefixIcon: CustomSelectorButton(
          country: country,
          countries: countries,
          onCountryChanged: onCountryChanged,
          selectorConfig: widget.selectorConfig,
          selectorTextStyle: const TextStyle(fontSize: 15.0),
          searchBoxDecoration: widget.searchBoxDecoration,
          locale: locale,
          isEnabled: widget.isEnabled,
          autoFocusSearchField: widget.autoFocusSearch,
          isScrollControlled: widget.countrySelectorScrollControlled,
        ),
      );
    }

    return value;
  }

  /// Validate the phone number when a change occurs
  void onChanged(String value) {
    phoneNumberControllerListener();
  }

  /// Validate and returns a validation error when [FormState] validate is called.
  ///
  /// Also updates [selectorButtonBottomPadding]
  String? validator(String? value) {
    final bool isValid =
        isNotValid && (value!.isNotEmpty || widget.ignoreBlank == false);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (isValid && widget.errorMessage != null) {
        setState(() {
          selectorButtonBottomPadding = widget.selectorButtonOnErrorPadding;
        });
      } else {
        setState(() {
          selectorButtonBottomPadding = 0;
        });
      }
    });

    return isValid ? widget.errorMessage : null;
  }

  /// Changes Selector Button Country and Validate Change.
  void onCountryChanged(Country? country) {
    setState(() {
      this.country = country;
    });
    phoneNumberControllerListener();
  }

  void _phoneNumberSaved() {
    if (mounted) {
      final String parsedPhoneNumberString =
          controller!.text.replaceAll(RegExp(r'[^\d+]'), '');

      final String phoneNumber =
          (country?.dialCode ?? '') + parsedPhoneNumberString;

      widget.onSaved?.call(
        PhoneNumber(
          phoneNumber: phoneNumber,
          isoCode: country?.alpha2Code,
          dialCode: country?.dialCode,
        ),
      );
    }
  }

  /// Saved the phone number when form is saved
  void onSaved(String? value) {
    _phoneNumberSaved();
  }

  /// Corrects duplicate locale
  String? get locale {
    if (widget.locale == null) return null;

    if (widget.locale!.toLowerCase() == 'nb' ||
        widget.locale!.toLowerCase() == 'nn') {
      return 'no';
    }
    return widget.locale;
  }
}

class _InputWidgetView
    extends WidgetView<CustomInternationalPhoneInput, _InputWidgetState> {
  final _InputWidgetState inputWidgetState;

  const _InputWidgetView({required this.inputWidgetState})
      : super(state: inputWidgetState);

  @override
  Widget build(BuildContext context) {
    final countryCode = state.country?.alpha2Code ?? '';
    final dialCode = state.country?.dialCode ?? '';

    return Container(
      width: AppConstants.textFieldWidth(context),
      height: AppConstants.textFieldHeight(context) * 0.55,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.h),
        border: Border.all(
          color: Colors.black12,
        ),
        color: widget.fillColor ?? AppConstants.appWhite,
      ),
      padding: EdgeInsets.symmetric(horizontal: 10.0.w),
      child: Row(
        textDirection: TextDirection.ltr,
        children: <Widget>[
          const SizedBox(width: 10),
          if (!widget.selectorConfig.setSelectorButtonAsPrefixIcon) ...[
            Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                CustomSelectorButton(
                  country: state.country,
                  countries: state.countries,
                  onCountryChanged: state.onCountryChanged,
                  selectorConfig: widget.selectorConfig,
                  selectorTextStyle: const TextStyle(fontSize: 15.0),
                  searchBoxDecoration: widget.searchBoxDecoration,
                  locale: state.locale,
                  isEnabled: widget.isEnabled,
                  autoFocusSearchField: widget.autoFocusSearch,
                  isScrollControlled: widget.countrySelectorScrollControlled,
                ),
                /*  SizedBox(
                  height: state.selectorButtonBottomPadding,
                ), */
              ],
            ),
            SizedBox(width: widget.spaceBetweenSelectorAndTextField),
          ],
          Flexible(
            child: TextFormField(
              key: const Key(TestHelper.TextInputKeyValue),
              textDirection: TextDirection.ltr,
              controller: state.controller,
              cursorColor: widget.cursorColor,
              focusNode: widget.focusNode,
              enabled: widget.isEnabled,
              autofocus: widget.autoFocus,
              keyboardType: widget.keyboardType,
              textInputAction: widget.keyboardAction,
              style: widget.textStyle,
              decoration: state.getInputDecoration(widget.inputDecoration),
              textAlign: widget.textAlign,
              textAlignVertical: widget.textAlignVertical,
              onEditingComplete: widget.onSubmit,
              onFieldSubmitted: widget.onFieldSubmitted,
              autovalidateMode: widget.autoValidateMode,
              autofillHints: widget.autofillHints,
              validator: widget.validator == null ? null : state.validator,
              onSaved: state.onSaved,
              scrollPadding: widget.scrollPadding,
              inputFormatters: [
                LengthLimitingTextInputFormatter(widget.maxLength),
                // ignore: prefer_if_elements_to_conditional_expressions
                widget.formatInput
                    ? AsYouTypeFormatter(
                        isoCode: countryCode,
                        dialCode: dialCode,
                        onInputFormatted: (TextEditingValue value) {
                          state.controller!.value = value;
                        },
                      )
                    : FilteringTextInputFormatter.digitsOnly,
              ],
              onChanged: state.onChanged,
            ),
          )
        ],
      ),
    );
  }
}

// ignore_for_file: implementation_imports

import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/src/models/country_model.dart';
import 'package:intl_phone_number_input/src/utils/selector_config.dart';
import 'package:intl_phone_number_input/src/utils/test/test_helper.dart';
import 'package:intl_phone_number_input/src/widgets/countries_search_list_widget.dart';
import 'package:intl_phone_number_input/src/widgets/input_widget.dart';
import 'package:intl_phone_number_input/src/widgets/item.dart';

/// [CustomSelectorButton]
class CustomSelectorButton extends StatelessWidget {
  final List<Country> countries;
  final Country? country;
  final SelectorConfig selectorConfig;
  final TextStyle? selectorTextStyle;
  final InputDecoration? searchBoxDecoration;
  final bool autoFocusSearchField;
  final String? locale;
  final bool isEnabled;
  final bool isScrollControlled;

  final ValueChanged<Country?> onCountryChanged;

  const CustomSelectorButton({
    super.key,
    required this.countries,
    required this.country,
    required this.selectorConfig,
    required this.selectorTextStyle,
    required this.searchBoxDecoration,
    required this.autoFocusSearchField,
    required this.locale,
    required this.onCountryChanged,
    required this.isEnabled,
    required this.isScrollControlled,
  });

  @override
  Widget build(BuildContext context) {
    return selectorConfig.selectorType == PhoneInputSelectorType.DROPDOWN
        ? countries.isNotEmpty && countries.length > 1
            ? DropdownButtonHideUnderline(
                child: DropdownButton<Country>(
                  key: const Key(TestHelper.DropdownButtonKeyValue),
                  hint: Item(
                    country: country,
                    showFlag: selectorConfig.showFlags,
                    useEmoji: selectorConfig.useEmoji,
                    leadingPadding: selectorConfig.leadingPadding,
                    trailingSpace: selectorConfig.trailingSpace,
                    textStyle: selectorTextStyle,
                  ),
                  value: country,
                  items: mapCountryToDropdownItem(countries),
                  onChanged: isEnabled ? onCountryChanged : null,
                ),
              )
            : Item(
                country: country,
                showFlag: selectorConfig.showFlags,
                useEmoji: selectorConfig.useEmoji,
                leadingPadding: selectorConfig.leadingPadding,
                trailingSpace: selectorConfig.trailingSpace,
                textStyle: selectorTextStyle,
              )
        : MaterialButton(
            key: const Key(TestHelper.DropdownButtonKeyValue),
            padding: EdgeInsets.zero,
            minWidth: 0,
            onPressed: countries.isNotEmpty && countries.length > 1 && isEnabled
                ? () async {
                    Country? selected;
                    if (selectorConfig.selectorType ==
                        PhoneInputSelectorType.BOTTOM_SHEET) {
                      selected = await showCountrySelectorBottomSheet(
                        context,
                        countries,
                      );
                    } else {
                      selected =
                          await showCountrySelectorDialog(context, countries);
                    }

                    if (selected != null) {
                      onCountryChanged(selected);
                    }
                  }
                : null,
            child: Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Row(
                children: [
                  Item(
                    country: country,
                    showFlag: selectorConfig.showFlags,
                    useEmoji: selectorConfig.useEmoji,
                    leadingPadding: selectorConfig.leadingPadding,
                    trailingSpace: selectorConfig.trailingSpace,
                    textStyle: selectorTextStyle,
                  ),
                  const Icon(Icons.arrow_drop_down),
                ],
              ),
            ),
          );
  }

  /// Converts the list [countries] to `DropdownMenuItem`
  List<DropdownMenuItem<Country>> mapCountryToDropdownItem(
    List<Country> countries,
  ) {
    return countries.map((country) {
      return DropdownMenuItem<Country>(
        value: country,
        child: Item(
          key: Key(TestHelper.countryItemKeyValue(country.alpha2Code)),
          country: country,
          showFlag: selectorConfig.showFlags,
          useEmoji: selectorConfig.useEmoji,
          textStyle: selectorTextStyle,
        ),
      );
    }).toList();
  }

  /// shows a Dialog with list [countries] if the [PhoneInputSelectorType.DIALOG] is selected
  Future<Country?> showCountrySelectorDialog(
    BuildContext context,
    List<Country> countries,
  ) {
    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) => AlertDialog(
        content: SizedBox(
          width: double.maxFinite,
          child: CountrySearchListWidget(
            countries,
            locale,
            searchBoxDecoration: searchBoxDecoration,
            showFlags: selectorConfig.showFlags,
            useEmoji: selectorConfig.useEmoji,
            autoFocus: autoFocusSearchField,
          ),
        ),
      ),
    );
  }

  /// shows a Dialog with list [countries] if the [PhoneInputSelectorType.BOTTOM_SHEET] is selected
  Future<Country?> showCountrySelectorBottomSheet(
    BuildContext context,
    List<Country> countries,
  ) {
    return showModalBottomSheet(
      context: context,
      clipBehavior: Clip.hardEdge,
      isScrollControlled: isScrollControlled,
      backgroundColor: Colors.transparent,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
      ),
      builder: (BuildContext context) {
        return Stack(
          children: [
            GestureDetector(
              onTap: () => Navigator.pop(context),
            ),
            DraggableScrollableSheet(
              builder: (BuildContext context, ScrollController controller) {
                return DecoratedBox(
                  decoration: ShapeDecoration(
                    color: Theme.of(context).canvasColor,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(12),
                        topRight: Radius.circular(12),
                      ),
                    ),
                  ),
                  child: CountrySearchListWidget(
                    countries,
                    locale,
                    searchBoxDecoration: searchBoxDecoration,
                    scrollController: controller,
                    showFlags: selectorConfig.showFlags,
                    useEmoji: selectorConfig.useEmoji,
                    autoFocus: autoFocusSearchField,
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }
}

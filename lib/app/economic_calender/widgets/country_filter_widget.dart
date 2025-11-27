import 'package:piapiri_v2/common/widgets/place_holder/divider.dart';
import 'package:piapiri_v2/common/widgets/buttons/button.dart';
import 'package:piapiri_v2/common/widgets/selection_control/checkbox.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:piapiri_v2/app/economic_calender/bloc/economic_calender_bloc.dart';
import 'package:piapiri_v2/app/economic_calender/bloc/economic_calender_event.dart';
import 'package:piapiri_v2/app/economic_calender/model/calender_countries_model.dart';
import 'package:piapiri_v2/app/economic_calender/model/economic_calender_model.dart';
import 'package:piapiri_v2/core/config/router_locator.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';
import 'package:turkish/turkish.dart';

class ECCountryFilterWidget extends StatefulWidget {
  const ECCountryFilterWidget({
    super.key,
  });

  @override
  State<ECCountryFilterWidget> createState() => _ECCountryFilterWidgetState();
}

class _ECCountryFilterWidgetState extends State<ECCountryFilterWidget> {
  late EconomicCalenderBloc _economicCalenderBloc;
  late List<CalenderCountriesSelectModel> _selectedCountries;
  List<CalendarCountryModel> countries = [];
  List<String> selectedCountries = [];

  @override
  void initState() {
    _economicCalenderBloc = getIt<EconomicCalenderBloc>();
    _selectedCountries = List<CalenderCountriesSelectModel>.from(_economicCalenderBloc.state.calendarFilter.country);
    countries.addAll(_economicCalenderBloc.state.countries);
    countries.sort((a, b) {
      if (a.code == 'TR') {
        return -1;
      } else if (b.code == 'TR') {
        return 1;
      } else {
        return a.trName.compareToTr(b.trName);
      }
    });
    countries.insert(
      0,
      const CalendarCountryModel(
        code: 'All',
        trName: 'Tüm Ülkeler',
        enName: 'All Countries',
        value: false,
      ),
    );

    if (_selectedCountries.isEmpty) {
      _selectedCountries.addAll(
        countries.map(
          (e) => CalenderCountriesSelectModel(
            name: e.trName,
            code: e.code,
            value: true,
          ),
        ),
      );
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.sizeOf(context).height * 0.75,
      ),
      child: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              physics: const ScrollPhysics(),
              itemCount: countries.length,
              itemBuilder: (context, index) {
                bool isSelected = _selectedCountries.any((country) => country.code == countries[index].code);

                return Column(
                  children: [
                    if (index != 0) const PDivider(),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: Grid.m,
                      ),
                      child: PCheckboxRow(
                        value: isSelected,
                        removeCheckboxPadding: true,
                        label: countries[index].trName,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        padding: const EdgeInsets.only(
                          left: Grid.s,
                        ),
                        onChanged: (bool? value) {
                          setState(() {
                            if (index == 0) {
                              _selectedCountries.clear();
                              if (value == true) {
                                _selectedCountries.addAll(
                                  countries.map(
                                    (e) => CalenderCountriesSelectModel(
                                      name: e.trName,
                                      code: e.code,
                                      value: true,
                                    ),
                                  ),
                                );
                              }
                            } else {
                              if (value == true) {
                                _selectedCountries.add(
                                  CalenderCountriesSelectModel(
                                    name: countries[index].trName,
                                    code: countries[index].code,
                                    value: true,
                                  ),
                                );
                              } else {
                                _selectedCountries.removeWhere(
                                  (country) => country.code == countries[index].code || country.code == 'All',
                                );
                              }
                            }
                          });
                        },
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          PButton(
            text: L10n.tr('kaydet'),
            fillParentWidth: true,
            onPressed: () {
              _economicCalenderBloc.add(
                SetCalendarFilterEvent(
                  calendarFilter: CalendarFilterModel(
                    country: _selectedCountries,
                    sort: _economicCalenderBloc.state.calendarFilter.sort,
                  ),
                  selectedCountries: _selectedCountries,
                  isChangedCountries: true,
                ),
              );
              router.maybePop();
            },
          )
        ],
      ),
    );
  }
}

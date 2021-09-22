import 'package:eje/core/utils/injection_container.dart';
import 'package:eje/core/widgets/LoadingIndicator.dart';
import 'package:eje/pages/freizeiten/domain/usecases/get_camps.dart';
import 'package:eje/pages/freizeiten/presentation/bloc/bloc.dart';
import 'package:eje/pages/freizeiten/presentation/widgets/camp_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_swiper_plus/flutter_swiper_plus.dart';
import 'package:intl/intl.dart';

import 'domain/entities/camp.dart';

class Camps extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<CampsBloc>(),
      child: BlocConsumer<CampsBloc, CampState>(
        listener: (context, state) {
          if (state is Error) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is Empty) {
            BlocProvider.of<CampsBloc>(context).add(RefreshCamps());
            return Center();
          }
          if (state is Loading) {
            return LoadingIndicator();
          } else if (state is LoadedCamps) {
            return CampsPageViewer(state.freizeiten);
          } else {
            BlocProvider.of<CampsBloc>(context).add(RefreshCamps());
            return LoadingIndicator();
          }
        },
      ),
    );
  }
}

class CampsPageViewer extends StatelessWidget {
  final List<Camp> camps;
  CampsPageViewer(this.camps);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          Camp filterCampDummy = await createFilterDialog(context: context);
          List<Camp> filteredCamps = camps;
          // Filtering by start and end date
          if (filterCampDummy.startDate != null &&
              filterCampDummy.endDate != null) {
            filteredCamps = filteredCamps
                .where((element) =>
                    element.startDate.isAfter(filterCampDummy.startDate))
                .toList();
            filteredCamps = filteredCamps
                .where((element) =>
                    element.endDate.isBefore(filterCampDummy.endDate))
                .toList();
          }
          // Filtering by age
          if (filterCampDummy.age != 0) {
            filteredCamps = filteredCamps
                .where((element) => element.age <= filterCampDummy.age)
                .toList();
          }
          // Filtering by price
          if (filterCampDummy.price != 0) {
            filteredCamps = filteredCamps
                .where((element) => element.price <= filterCampDummy.price)
                .toList();
          }

          BlocProvider.of<CampsBloc>(context)
              .add(FilteringCamps(filteredCamps));
        },
        child: Icon(
          Icons.search,
        ),
      ),
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: RefreshIndicator(
          color: Theme.of(context).colorScheme.secondary,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: 400),
                  child: camps.length != 0
                      ? Swiper(
                          itemBuilder: (BuildContext context, int index) {
                            return CampCard(camp: camps[index]);
                          },
                          itemCount: camps.length,
                          itemHeight: 350,
                          itemWidth: 325,
                          layout: SwiperLayout.STACK,
                          loop: true,
                        )
                      // Return placeholder if no camps are available to display
                      : Container(),
                  // TODO implement Card if no camps are available
                ),
              ),
            ],
          ),
          onRefresh: () async {
            BlocProvider.of<CampsBloc>(context).add(RefreshCamps());
          }),
    );
  }
}

Future<Camp> createFilterDialog({BuildContext context}) {
  const String dialogTitle = "Freizeiten filtern";
  const String ageFilterLable = "Alter";
  const String ageFilterHelper = "Alter des anzumeldenden Teilnehmers";
  const String priceFilterLable = "Preis";
  const String priceFilterHelper = "Maximal möglicher Preis";
  const String dateFilterLable = "Zeitraum auswählen";

  TextEditingController datetimeRangeController = TextEditingController();
  const double height = 20;

  // Values that can be filtered
  int age = 0;
  int price = 0;
  DateTimeRange date = null;

  return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(dialogTitle),
          content: ListView(
            shrinkWrap: true,
            children: [
              // Age
              TextField(
                controller: TextEditingController(),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  age = int.parse(value);
                },
                decoration: InputDecoration(
                  floatingLabelStyle:
                      TextStyle(color: Theme.of(context).colorScheme.secondary),
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Theme.of(context).colorScheme.secondary,
                      width: 2.0,
                    ),
                  ),
                  labelText: ageFilterLable,
                  helperText: ageFilterHelper,
                ),
              ),
              SizedBox(height: height),
              // Price
              TextField(
                controller: TextEditingController(),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  price = int.parse(value);
                },
                decoration: InputDecoration(
                  floatingLabelStyle:
                      TextStyle(color: Theme.of(context).colorScheme.secondary),
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Theme.of(context).colorScheme.secondary,
                      width: 2.0,
                    ),
                  ),
                  labelText: priceFilterLable,
                  helperText: priceFilterHelper,
                ),
              ),
              SizedBox(height: height),
              TextField(
                controller: datetimeRangeController,
                decoration: InputDecoration(
                  icon: Icon(Icons.calendar_today_outlined),
                  labelText: dateFilterLable,
                  floatingLabelStyle:
                      TextStyle(color: Theme.of(context).colorScheme.secondary),
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Theme.of(context).colorScheme.secondary,
                      width: 2.0,
                    ),
                  ),
                ),
                readOnly: true,
                onTap: () async {
                  date = await showDateRangePicker(
                    context: context,
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(Duration(days: 365)),
                    helpText: dateFilterLable,
                    cancelText: "Abbrechen",
                    saveText: "Bestätigen",
                  );
                  datetimeRangeController.text =
                      DateFormat('dd.MM.yyyy').format(date.start) +
                          " - " +
                          DateFormat('dd.MM.yyyy').format(date.end);
                },
              ),
            ],
          ),
          actions: <Widget>[
            MaterialButton(
              onPressed: () {
                Navigator.of(context).pop(new Camp(
                  age: 0,
                  price: 0,
                  startDate: null,
                  endDate: null,
                ));
              },
              child: Text("Abbrechen"),
            ),
            MaterialButton(
              onPressed: () {
                Navigator.of(context).pop(
                  new Camp(
                    age: age,
                    price: price,
                    startDate: date != null ? date.start : null,
                    endDate: date != null ? date.end : null,
                  ),
                );
              },
              child: Text("Bestätigen"),
            ),
          ],
        );
      });
}

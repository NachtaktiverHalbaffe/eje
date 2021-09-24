import 'package:eje/core/utils/injection_container.dart';
import 'package:eje/core/widgets/LoadingIndicator.dart';
import 'package:eje/pages/freizeiten/presentation/bloc/bloc.dart';
import 'package:eje/pages/freizeiten/presentation/widgets/camp_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_swiper_plus/flutter_swiper_plus.dart';
import 'package:get_storage/get_storage.dart';
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
          } else if (state is FilteredCamps) {
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
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: RefreshIndicator(
          color: Theme.of(context).colorScheme.secondary,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              FilterCard(),
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
                          loop: camps.length == 1 ? false : true,
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

  TextEditingController datetimeRangeController = TextEditingController(
    text: GetStorage().read("campFilterStartDate") != ""
        ? DateFormat('dd.MM.yyyy').format(
                DateTime.tryParse(GetStorage().read("campFilterStartDate"))) +
            " - " +
            DateFormat('dd.MM.yyyy').format(
                DateTime.tryParse(GetStorage().read("campFilterEndDate")))
        : "",
  );
  const double height = 20;

  // Values that can be filtered
  int age = 0;
  int price = 0;
  DateTimeRange date;

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
                controller: TextEditingController(
                    text: GetStorage().read("campFilterAge") != 0
                        ? GetStorage().read("campFilterAge").toString()
                        : ""),
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
                controller: TextEditingController(
                    text: GetStorage().read("campFilterPrice") != 0
                        ? GetStorage().read("campFilterPrice").toString()
                        : ""),
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
                Navigator.of(context).pop();
              },
              child: Text("Abbrechen"),
            ),
            MaterialButton(
              onPressed: () {
                final prefs = GetStorage();
                print("Age" + age.toString());
                if (age != 0) {
                  prefs.write("campFilterAge", age);
                }
                if (price != 0) {
                  prefs.write("campFilterPrice", price);
                }
                if (date != null) {
                  prefs.write("campFilterStartDate", date.start.toString());
                  prefs.write("campFilterEndDate", date.end.toString());
                }
                Navigator.of(context).pop();
              },
              child: Text("Bestätigen"),
            ),
          ],
        );
      });
}

class FilterCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6.0,
      child: Column(
        children: [
          ListTile(
            leading: Text(
              "Filter",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            trailing: IconButton(
              onPressed: () async {
                await createFilterDialog(context: context);
                BlocProvider.of<CampsBloc>(context).add(FilteringCamps());
              },
              icon: Icon(
                Icons.add,
              ),
            ),
          ),
          ChipsRow(),
        ],
      ),
    );
  }
}

class ChipsWrap extends StatelessWidget {
  final prefs = GetStorage();
  final double elevation = 4;

  @override
  Widget build(BuildContext context) {
    List<Widget> chips = List.empty(growable: true);
    // Read filters from storage and create chip if filter is active
    if (prefs.read("campFilterAge") != 0) {
      chips.add(
        _filterChip(
          dataLabel: prefs.read("campFilterAge").toString(),
          icon: Icons.cake,
          onDeleted: () {
            prefs.write("campFilterAge", 0);
            BlocProvider.of<CampsBloc>(context).add(FilteringCamps());
          },
        ),
      );
    }
    if (prefs.read("campFilterPrice") != 0) {
      chips.add(
        _filterChip(
          dataLabel: prefs.read("campFilterPrice").toString(),
          icon: Icons.euro,
          onDeleted: () {
            prefs.write("campFilterPrice", 0);
            BlocProvider.of<CampsBloc>(context).add(FilteringCamps());
          },
        ),
      );
    }
    if (prefs.read("campFilterStartDate") != "" &&
        prefs.read("campFilterEndDate") != "") {
      chips.add(
        _filterChip(
          dataLabel: DateFormat('dd.MM.yyyy').format(
                  DateTime.tryParse(prefs.read("campFilterStartDate"))) +
              " - " +
              DateFormat('dd.MM.yyyy')
                  .format(DateTime.tryParse(prefs.read("campFilterEndDate"))),
          icon: Icons.calendar_today,
          onDeleted: () {
            prefs.write("campFilterStartDate", "");
            prefs.write("campFilterEndDate", "");
            BlocProvider.of<CampsBloc>(context).add(FilteringCamps());
          },
        ),
      );
    }

    return Wrap(
      children: chips,
    );
  }
}

class ChipsRow extends StatelessWidget {
  final prefs = GetStorage();
  final double elevation = 4;

  @override
  Widget build(BuildContext context) {
    List<Widget> chips = List.empty(growable: true);
    // Read filters from storage and create chip if filter is active
    if (prefs.read("campFilterAge") != 0) {
      chips.add(
        _filterChip(
          dataLabel: prefs.read("campFilterAge").toString(),
          icon: Icons.cake,
          onDeleted: () {
            prefs.write("campFilterAge", 0);
            BlocProvider.of<CampsBloc>(context).add(FilteringCamps());
          },
        ),
      );
    }
    if (prefs.read("campFilterPrice") != 0) {
      chips.add(
        _filterChip(
          dataLabel: prefs.read("campFilterPrice").toString(),
          icon: Icons.euro,
          onDeleted: () {
            prefs.write("campFilterPrice", 0);
            BlocProvider.of<CampsBloc>(context).add(FilteringCamps());
          },
        ),
      );
    }
    if (prefs.read("campFilterStartDate") != "" &&
        prefs.read("campFilterEndDate") != "") {
      chips.add(
        _filterChip(
          dataLabel: DateFormat('dd.MM.yyyy').format(
                  DateTime.tryParse(prefs.read("campFilterStartDate"))) +
              " - " +
              DateFormat('dd.MM.yyyy')
                  .format(DateTime.tryParse(prefs.read("campFilterEndDate"))),
          icon: Icons.calendar_today,
          onDeleted: () {
            prefs.write("campFilterStartDate", "");
            prefs.write("campFilterEndDate", "");
            BlocProvider.of<CampsBloc>(context).add(FilteringCamps());
          },
        ),
      );
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: chips,
      ),
    );
  }
}

class _filterChip extends StatelessWidget {
  final onDeleted;
  final dataLabel;
  final icon;

  const _filterChip({Key key, this.onDeleted, this.dataLabel, this.icon})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 6.0),
      child: Chip(
        padding: EdgeInsets.symmetric(horizontal: 3.0),
        backgroundColor: Theme.of(context).colorScheme.secondary,
        elevation: 3,
        avatar: Icon(
          icon,
          color: Colors.white,
        ),
        label: Text(
          dataLabel,
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        onDeleted: onDeleted,
        deleteIcon: Icon(
          Icons.highlight_remove,
          color: Colors.white,
        ),
      ),
    );
  }
}

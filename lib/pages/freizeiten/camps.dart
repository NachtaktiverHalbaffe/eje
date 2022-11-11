import 'package:eje/core/utils/injection_container.dart';
import 'package:eje/core/widgets/alert_snackbar.dart';
import 'package:eje/core/widgets/loading_indicator.dart';
import 'package:eje/core/widgets/no_result_card.dart';
import 'package:eje/pages/freizeiten/presentation/bloc/bloc.dart';
import 'package:eje/pages/freizeiten/presentation/widgets/camp_card.dart';
import 'package:flutter/material.dart';
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
            AlertSnackbar(context).showErrorSnackBar(label: state.message);
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
          } else if (state is DeletedFilter) {
            return CampsPageViewer(state.freizeiten);
          } else if (state is Error) {
            return NoResultCard(
              label: "Fehler beim Laden der Freizeiten",
              isError: true,
              onRefresh: () async {
                BlocProvider.of<CampsBloc>(context).add(RefreshCamps());
              },
            );
          } else {
            return Center();
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
      resizeToAvoidBottomInset: false,
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: RefreshIndicator(
        color: Theme.of(context).colorScheme.secondary,
        onRefresh: () async {
          BlocProvider.of<CampsBloc>(context).add(RefreshCamps());
        },
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          child: ConstrainedBox(
            constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height - 50),
            child: camps.isNotEmpty
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: 65),
                      Container(
                        height: 400,
                        child: Swiper(
                          itemBuilder: (BuildContext context, int index) {
                            return CampCard(camp: camps[index]);
                          },
                          itemCount: camps.length,
                          itemHeight: 350,
                          itemWidth: 325,
                          layout: SwiperLayout.STACK,
                          loop: true,
                        ),
                      ),
                      FilterCard(),
                    ],
                  )
                // Return placeholder if no camps are available to display
                : Stack(
                    alignment: AlignmentDirectional.bottomCenter,
                    children: [
                      NoResultCard(
                        label: "Keine Freizeiten gefunden",
                        isError: false,
                        onRefresh: () async {
                          BlocProvider.of<CampsBloc>(context)
                              .add(RefreshCamps());
                        },
                      ),
                      Column(
                        children: [
                          FilterCard(),
                          SizedBox(
                            height: 40,
                          )
                        ],
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}

Future<dynamic> createFilterDialog({required BuildContext context}) {
  const String dialogTitle = "Freizeiten filtern";
  const String ageFilterLable = "Alter";
  const String ageFilterHelper = "Alter des anzumeldenden Teilnehmers";
  const String priceFilterLable = "Preis";
  const String priceFilterHelper = "Maximal möglicher Preis";
  const String dateFilterLable = "Zeitraum auswählen";

  TextEditingController datetimeRangeController = TextEditingController(
    text: GetStorage().read("campFilterStartDate") != ""
        ? "${DateFormat('dd.MM.yyyy').format(DateTime.tryParse(GetStorage().read("campFilterStartDate")) ?? DateTime.now())} - ${DateFormat('dd.MM.yyyy').format(DateTime.tryParse(GetStorage().read("campFilterEndDate")) ?? DateTime.now())}"
        : "",
  );
  const double height = 20;

  // Values that can be filtered
  int age = 0;
  int price = 0;
  DateTimeRange? date;

  return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(dialogTitle),
          content: SingleChildScrollView(
            child: Column(
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
                    floatingLabelStyle: TextStyle(
                        color: Theme.of(context).colorScheme.secondary),
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
                    floatingLabelStyle: TextStyle(
                        color: Theme.of(context).colorScheme.secondary),
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
                    floatingLabelStyle: TextStyle(
                        color: Theme.of(context).colorScheme.secondary),
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
                    date = (await showDateRangePicker(
                      context: context,
                      firstDate: DateTime.now(),
                      lastDate: DateTime.now().add(Duration(days: 365)),
                      helpText: dateFilterLable,
                      cancelText: "Abbrechen",
                      saveText: "Bestätigen",
                    ));
                    datetimeRangeController.text =
                        "${DateFormat('dd.MM.yyyy').format(date!.start)} - ${DateFormat('dd.MM.yyyy').format(date!.end)}";
                  },
                ),
              ],
            ),
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
                if (age != 0) {
                  if (age >= 0 && age < 130) {
                    prefs.write("campFilterAge", age);
                  } else {
                    AlertSnackbar(context).showWarningSnackBar(
                        label: "Ein Mensch kann nicht so Jung/Alt sein");
                  }
                }

                if (price >= 0) {
                  prefs.write("campFilterPrice", price);
                } else {
                  AlertSnackbar(context).showWarningSnackBar(
                      label: "Preis kann nicht negativ sein");
                }

                if (date != null) {
                  prefs.write("campFilterStartDate", date!.start.toString());
                  prefs.write("campFilterEndDate", date!.end.toString());
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
    return Column(
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
        ChipsWrap(),
      ],
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
          onDeleted: () async {
            await prefs.write("campFilterAge", 0);
            BlocProvider.of<CampsBloc>(context).add(DeletingCampsFilter());
          },
        ),
      );
    }
    if (prefs.read("campFilterPrice") != 0) {
      chips.add(
        _filterChip(
          dataLabel: prefs.read("campFilterPrice").toString(),
          icon: Icons.euro,
          onDeleted: () async {
            await prefs.write("campFilterPrice", 0);
            BlocProvider.of<CampsBloc>(context).add(DeletingCampsFilter());
          },
        ),
      );
    }
    if (prefs.read("campFilterStartDate") != "" &&
        prefs.read("campFilterEndDate") != "") {
      chips.add(
        _filterChip(
          dataLabel:
              "${DateFormat('dd.MM.yyyy').format(DateTime.tryParse(prefs.read("campFilterStartDate")) ?? DateTime.now())} - ${DateFormat('dd.MM.yyyy').format(DateTime.tryParse(prefs.read("campFilterEndDate")) ?? DateTime.now())}",
          icon: Icons.calendar_today,
          onDeleted: () async {
            await prefs.write("campFilterStartDate", "");
            await prefs.write("campFilterEndDate", "");
            BlocProvider.of<CampsBloc>(context).add(DeletingCampsFilter());
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
          onDeleted: () async {
            await prefs.write("campFilterAge", 0);
            print(prefs.read("campFilterAge"));
            BlocProvider.of<CampsBloc>(context).add(DeletingCampsFilter());
          },
        ),
      );
    }
    if (prefs.read("campFilterPrice") != 0) {
      chips.add(
        _filterChip(
          dataLabel: prefs.read("campFilterPrice").toString(),
          icon: Icons.euro,
          onDeleted: () async {
            await prefs.write("campFilterPrice", 0);
            BlocProvider.of<CampsBloc>(context).add(DeletingCampsFilter());
          },
        ),
      );
    }
    if (prefs.read("campFilterStartDate") != "" &&
        prefs.read("campFilterEndDate") != "") {
      chips.add(
        _filterChip(
          dataLabel:
              "${DateFormat('dd.MM.yyyy').format(DateTime.tryParse(prefs.read("campFilterStartDate")) ?? DateTime.now())} - ${DateFormat('dd.MM.yyyy').format(DateTime.tryParse(prefs.read("campFilterEndDate")) ?? DateTime.now())}",
          icon: Icons.calendar_today,
          onDeleted: () async {
            await prefs.write("campFilterStartDate", "");
            await prefs.write("campFilterEndDate", "");
            BlocProvider.of<CampsBloc>(context).add(DeletingCampsFilter());
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

// ignore: camel_case_types
class _filterChip extends StatelessWidget {
  final VoidCallback onDeleted;
  final String dataLabel;
  final IconData icon;

  const _filterChip(
      {required this.onDeleted, required this.dataLabel, required this.icon})
      : super();

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

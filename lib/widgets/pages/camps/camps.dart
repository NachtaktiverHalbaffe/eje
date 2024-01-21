import 'package:eje/models/camp.dart';
import 'package:eje/utils/injection_container.dart';
import 'package:eje/widgets/alert_snackbar.dart';
import 'package:eje/widgets/loading_indicator.dart';
import 'package:eje/widgets/no_result_card.dart';
import 'package:eje/widgets/pages/camps/bloc/camps_bloc.dart';
import 'package:eje/widgets/pages/camps/bloc/camps_event.dart';
import 'package:eje/widgets/pages/camps/bloc/camps_state.dart';
import 'package:eje/widgets/pages/camps/camp_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_swiper_plus/flutter_swiper_plus.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';

class Camps extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (_) => diContainer<CampsBloc>(),
        child: BlocConsumer<CampsBloc, CampState>(
          listener: (context, state) {
            if (state is Error) {
              AlertSnackbar(context).showErrorSnackBar(label: state.message);
            } else if (state is NetworkError) {
              AlertSnackbar(context).showWarningSnackBar(label: state.message);
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
                label: state.message,
                onRefresh: () async {
                  BlocProvider.of<CampsBloc>(context).add(RefreshCamps());
                },
              );
            } else if (state is NetworkError) {
              BlocProvider.of<CampsBloc>(context).add(GetCachedCamps());
              return LoadingIndicator();
            } else {
              return Center();
            }
          },
        ),
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
                  ? Center(
                      child: Column(
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
                              autoplay: false,
                              autoplayDisableOnInteraction: true,
                              autoplayDelay: 5000,
                            ),
                          ),
                          FilterCard(),
                        ],
                      ),
                    )
                  // Return placeholder if no camps are available to display
                  : Center(
                      child: Stack(
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
                              FilterCard(
                                hideWhenEmpy: true,
                              ),
                              SizedBox(
                                height: 40,
                              )
                            ],
                          ),
                        ],
                      ),
                    )),
        ),
      ),
    );
  }
}

Future<dynamic> createFilterDialog({required BuildContext parentContext}) {
  const String ageFilterLable = "Alter";
  const String ageFilterHelper = "Alter des anzumeldenden Teilnehmers";
  const String priceFilterLable = "Preis";
  const String priceFilterHelper = "Maximal möglicher Preis";
  const String dateFilterLable = "Zeitraum auswählen";
  const String dateFilterHelper = "Zeitraum, in der die Freizeit stattfindet";

  TextEditingController datetimeRangeController = TextEditingController(
    text: GetStorage().read("campFilterStartDate") != ""
        ? "${DateFormat('dd.MM.yyyy').format(DateTime.tryParse(GetStorage().read("campFilterStartDate")) ?? DateTime.now())} - ${DateFormat('dd.MM.yyyy').format(DateTime.tryParse(GetStorage().read("campFilterEndDate")) ?? DateTime.now())}"
        : "",
  );
  TextEditingController ageTextController = TextEditingController(
      text: GetStorage().read("campFilterAge") >= 0
          ? GetStorage().read("campFilterAge").toString()
          : "");
  TextEditingController priceEditingController = TextEditingController(
      text: GetStorage().read("campFilterPrice") >= 0
          ? GetStorage().read("campFilterPrice").toString()
          : "");
  const double height = 20;

  // Values that can be filtered
  int age = -1;
  int price = -1;
  DateTimeRange? date;

  return showModalBottomSheet(
      context: parentContext,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (context) {
        return SingleChildScrollView(
          padding: EdgeInsets.only(
              left: 20,
              right: 20,
              bottom: MediaQuery.of(context).viewInsets.bottom + height),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Text(
              //   "Freizeiten filtern",
              //   textAlign: TextAlign.center,
              //   style: TextStyle(
              //     fontSize: 20,
              //     fontWeight: FontWeight.bold,
              //     // color: Theme.of(context).colorScheme.primary,
              //   ),
              // ),
              // SizedBox(height: height),
              // Age
              TextField(
                controller: ageTextController,
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  ageTextController.text = value;
                  if (value.isNotEmpty) {
                    age = int.parse(value);
                  }
                },
                decoration: InputDecoration(
                  icon: Icon(Icons.cake),
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
                controller: priceEditingController,
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  priceEditingController.text = value;
                  if (value.isNotEmpty) {
                    price = int.parse(value);
                  }
                },
                decoration: InputDecoration(
                  icon: Icon(Icons.euro),
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
                  helperText: dateFilterHelper,
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
              SizedBox(height: height),
              OutlinedButton(
                onPressed: () {
                  final prefs = GetStorage();
                  if (age != -1) {
                    if (age >= -1 && age < 130) {
                      prefs.write("campFilterAge", age);
                    } else if (age != -1) {
                      AlertSnackbar(context).showWarningSnackBar(
                          label: "Ein Mensch kann nicht so Jung/Alt sein");
                    }
                  }

                  if (price > -1) {
                    prefs.write("campFilterPrice", price);
                  } else if (price != -1) {
                    AlertSnackbar(context).showWarningSnackBar(
                        label: "Preis kann nicht negativ sein");
                  }

                  if (date != null) {
                    prefs.write("campFilterStartDate", date!.start.toString());
                    prefs.write("campFilterEndDate", date!.end.toString());
                  }
                  BlocProvider.of<CampsBloc>(parentContext)
                      .add(FilteringCamps());
                  Navigator.of(context).pop();
                },
                child: Text("Bestätigen"),
              ),
            ],
          ),
        );
      });
}

class FilterCard extends StatelessWidget {
  final bool hideWhenEmpy;
  const FilterCard({this.hideWhenEmpy = false});

  @override
  Widget build(BuildContext context) {
    ChipsWrap chipsWidget = ChipsWrap(context);

    if (hideWhenEmpy && chipsWidget.length == 0) {
      return Container();
    } else {
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
                await createFilterDialog(parentContext: context);
              },
              icon: Icon(
                Icons.add,
              ),
            ),
          ),
          chipsWidget,
        ],
      );
    }
  }
}

class ChipsWrap extends StatelessWidget {
  final prefs = GetStorage();
  final double elevation = 4;
  late final BuildContext parentContext;
  late final List<Widget> chips;
  late final int length;

  ChipsWrap(this.parentContext) {
    chips = generateChips();
    length = chips.length;
  }

  List<Widget> generateChips() {
    List<Widget> chips = List.empty(growable: true);
    // Read filters from storage and create chip if filter is active
    if (prefs.read("campFilterAge") >= 0) {
      chips.add(
        _filterChip(
          dataLabel: prefs.read("campFilterAge").toString(),
          icon: Icons.cake,
          onDeleted: () async {
            await prefs.write("campFilterAge", -1);
            BlocProvider.of<CampsBloc>(parentContext)
                .add(DeletingCampsFilter());
          },
        ),
      );
    }
    if (prefs.read("campFilterPrice") >= 0) {
      chips.add(
        _filterChip(
          dataLabel: prefs.read("campFilterPrice").toString(),
          icon: Icons.euro,
          onDeleted: () async {
            await prefs.write("campFilterPrice", -1);
            BlocProvider.of<CampsBloc>(parentContext)
                .add(DeletingCampsFilter());
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
            BlocProvider.of<CampsBloc>(parentContext)
                .add(DeletingCampsFilter());
          },
        ),
      );
    }
    return chips;
  }

  @override
  Widget build(BuildContext context) {
    if (length != 0) {}
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

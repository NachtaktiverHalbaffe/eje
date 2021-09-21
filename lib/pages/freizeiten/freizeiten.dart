import 'package:eje/core/utils/injection_container.dart';
import 'package:eje/core/widgets/LoadingIndicator.dart';
import 'package:eje/pages/freizeiten/presentation/bloc/bloc.dart';
import 'package:eje/pages/freizeiten/presentation/widgets/freizeit_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_swiper_plus/flutter_swiper_plus.dart';
import 'package:intl/intl.dart';

import 'domain/entities/Freizeit.dart';

class Freizeiten extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<FreizeitenBloc>(),
      child: BlocConsumer<FreizeitenBloc, FreizeitenState>(
        listener: (context, state) {
          if (state is Error) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
              ),
            );
          }
        },
        // ignore: missing_return
        builder: (context, state) {
          if (state is Empty) {
            BlocProvider.of<FreizeitenBloc>(context).add(RefreshFreizeiten());
            return Center();
          }
          if (state is Loading) {
            return LoadingIndicator();
          } else if (state is LoadedFreizeiten) {
            return FreizeitenPageViewer(state.freizeiten);
          }
        },
      ),
    );
  }
}

class FreizeitenPageViewer extends StatelessWidget {
  final List<Freizeit> freizeiten;
  FreizeitenPageViewer(this.freizeiten);

  @override
  Widget build(BuildContext context) {
    List<Freizeit> filteredFreizeiten = freizeiten;
    return Scaffold(
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
                  child: Swiper(
                    itemBuilder: (BuildContext context, int index) {
                      return FreizeitCard(freizeit: filteredFreizeiten[index]);
                    },
                    itemCount: filteredFreizeiten.length,
                    itemHeight: 350,
                    itemWidth: 325,
                    layout: SwiperLayout.STACK,
                    loop: true,
                  ),
                ),
              ),
              SizedBox(height: 12),
              OutlinedButton(
                  onPressed: () async {
                    Freizeit filterFreizeitDummy =
                        await createFilterDialog(context: context);
                  },
                  child: Text("Filtern")),
            ],
          ),
          onRefresh: () async {
            BlocProvider.of<FreizeitenBloc>(context).add(RefreshFreizeiten());
          }),
    );
  }
}

Future<Freizeit> createFilterDialog({BuildContext context}) {
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
  DateTimeRange date =
      DateTimeRange(start: DateTime.now(), end: DateTime.now());

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
                onSubmitted: (value) => age,
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
                onSubmitted: (value) => price,
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
                Navigator.of(context).pop(new Freizeit(
                  alter: "0",
                  preis: "0",
                  datum: DateTime.now().toString() + DateTime.now().toString(),
                ));
              },
              child: Text("Abbrechen"),
            ),
            MaterialButton(
              onPressed: () {
                Navigator.of(context).pop(new Freizeit(
                  alter: age.toString(),
                  preis: price.toString(),
                  datum: date.start.toString() + date.end.toString(),
                ));
              },
              child: Text("Bestätigen"),
            ),
          ],
        );
      });
}

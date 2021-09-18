import 'package:eje/pages/eje/arbeitsfelder/presentation/bloc/arbeitsbereiche_bloc.dart';
import 'package:eje/pages/eje/arbeitsfelder/presentation/bloc/arbeitsbereiche_event.dart';
import 'package:eje/pages/eje/bak/presentation/bloc/bak_bloc.dart';
import 'package:eje/pages/eje/bak/presentation/bloc/bak_event.dart';
import 'package:eje/pages/eje/hauptamtlichen/hauptamtliche.dart';
import 'package:eje/pages/eje/hauptamtlichen/presentation/bloc/bloc.dart';
import 'package:eje/pages/eje/services/services.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'arbeitsfelder/arbeitsbereiche.dart';
import 'bak/bak.dart';
import 'services/presentation/bloc/services_bloc.dart';

class eje extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
        color: Theme.of(context).colorScheme.secondary,
        child: ListView(
          physics: ScrollPhysics(
            parent: RangeMaintainingScrollPhysics(),
          ),
          children: <Widget>[
            SizedBox(height: 20),
            Hauptamtliche(),
            SizedBox(height: 20),
            BAK(),
            SizedBox(height: 20),
            Arbeitsbereiche(),
            SizedBox(height: 20),
            Services(),
            SizedBox(height: 20),
          ],
        ),
        onRefresh: () async {
          // TODO Fix Reloading
          BlocProvider.of<ArbeitsbereicheBloc>(context)
              .add(RefreshArbeitsbereiche());
          BlocProvider.of<HauptamtlicheBloc>(context)
              .add(RefreshHauptamtliche());
          BlocProvider.of<BakBloc>(context).add(RefreshBAK());
          BlocProvider.of<ServicesBloc>(context).add(RefreshServices());
        });
  }
}

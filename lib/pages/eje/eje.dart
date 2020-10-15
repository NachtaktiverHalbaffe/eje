import 'dart:developer';

import 'package:eje/pages/eje/arbeitsfelder/presentation/bloc/arbeitsbereiche_bloc.dart';
import 'package:eje/pages/eje/arbeitsfelder/presentation/bloc/arbeitsbereiche_event.dart';
import 'package:eje/pages/eje/bak/presentation/bloc/bak_bloc.dart';
import 'package:eje/pages/eje/bak/presentation/bloc/bak_event.dart';
import 'package:eje/pages/eje/hauptamtlichen/hauptamtliche.dart';
import 'package:eje/pages/eje/hauptamtlichen/presentation/bloc/bloc.dart';
import 'package:eje/pages/eje/services/services.dart';
import 'package:eje/pages/neuigkeiten/presentation/bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'arbeitsfelder/arbeitsbereiche.dart';
import 'bak/bak.dart';

class eje extends StatelessWidget {
  final bool isCacheEnabled;
  eje(this.isCacheEnabled);

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
        child: ListView(
          physics: ScrollPhysics(
            parent: BouncingScrollPhysics(),
          ),
          children: <Widget>[
            SizedBox(height: 20),
            Hauptamtliche(context, isCacheEnabled),
            SizedBox(height: 20),
            BAK(context, isCacheEnabled),
            SizedBox(height: 20),
            Arbeitsbereiche(context, isCacheEnabled),
            SizedBox(height: 20),
            Services(context, isCacheEnabled),
            SizedBox(height: 20),
          ],
        ),
        onRefresh: () {
          BlocProvider.of<ArbeitsbereicheBloc>(context)
              .add(RefreshArbeitsbereiche());
          BlocProvider.of<HauptamtlicheBloc>(context)
              .add(RefreshHauptamtliche());
          BlocProvider.of<BakBloc>(context).add(RefreshBAK());
        });
  }
}

import 'package:eje/core/utils/injection_container.dart';
import 'package:eje/pages/einstellungen/presentation/bloc/bloc.dart';
import 'package:eje/pages/einstellungen/presentation/bloc/einstellung_bloc.dart';
import 'package:eje/pages/einstellungen/presentation/widgets/einstellung_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Einstellungen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(create: (_) => sl<EinstellungBloc>(),
    child: BlocConsumer(
      listener:(context,state){
        if (state is Error) {
          print("Build Page: Error");
          Scaffold.of(context).showSnackBar(
            SnackBar(
              content: Text(state.toString()),
            ),
          );
        }
      },
      builder:(context,state){
          if(state is Empty){
            BlocProvider.of<EinstellungBloc>(context).add(GettingPreferences());
            return EinstellungenPage();
          }
          if(state is LoadedPreferences){
            return EinstellungenPage();
          }
          if(state is StoringPreferences){
          return EinstellungenPage();
        } else  return EinstellungenPage();
      },
    ),
    );
  }
}




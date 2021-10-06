import 'package:eje/core/utils/injection_container.dart';
import 'package:eje/core/widgets/alert_snackbar.dart';
import 'package:eje/core/widgets/loading_indicator.dart';
import 'package:eje/pages/einstellungen/presentation/bloc/bloc.dart';
import 'package:eje/pages/einstellungen/presentation/bloc/einstellung_bloc.dart';
import 'package:eje/pages/einstellungen/presentation/widgets/einstellung_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Einstellungen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<EinstellungBloc>(),
      child: BlocConsumer<EinstellungBloc, EinstellungState>(
        listener: (context, state) {
          if (state is Error) {
            print("Build Page: Error");
            AlertSnackbar(context).showErrorSnackBar(label: state.message);
          } else if (state is ChangedPreferences) {
            BlocProvider.of<EinstellungBloc>(context).add(GettingPreferences());
          }
        },
        // ignore: missing_return
        builder: (context, state) {
          if (state is Empty) {
            BlocProvider.of<EinstellungBloc>(context).add(GettingPreferences());
            return LoadingIndicator();
          } else if (state is LoadedPreferences) {
            return EinstellungenPage();
          }
        },
      ),
    );
  }
}

import 'package:eje/core/utils/injection_container.dart';
import 'package:eje/core/widgets/LoadingIndicator.dart';
import 'package:eje/pages/freizeiten/presentation/bloc/bloc.dart';
import 'package:eje/pages/freizeiten/presentation/widgets/freizeit_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_swiper_plus/flutter_swiper_plus.dart';

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
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: RefreshIndicator(
          color: Theme.of(context).colorScheme.secondary,
          child: SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                  minHeight: MediaQuery.of(context).size.height - 48),
              child: Swiper(
                itemBuilder: (BuildContext context, int index) {
                  return FreizeitCard(freizeit: freizeiten[index]);
                },
                itemCount: freizeiten.length,
                itemHeight: 350,
                itemWidth: 325,
                layout: SwiperLayout.STACK,
                loop: true,
              ),
            ),
          ),
          onRefresh: () async {
            BlocProvider.of<FreizeitenBloc>(context).add(RefreshFreizeiten());
          }),
    );
  }
}

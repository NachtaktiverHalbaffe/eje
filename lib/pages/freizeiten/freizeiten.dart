import 'package:eje/core/utils/injection_container.dart';
import 'package:eje/core/widgets/LoadingIndicator.dart';
import 'package:eje/pages/freizeiten/presentation/bloc/bloc.dart';
import 'package:eje/pages/freizeiten/presentation/widgets/freizeit_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

import 'domain/entities/Freizeit.dart';

class Freizeiten extends StatelessWidget {
  final bool isCacheEnabled;

  Freizeiten(this.isCacheEnabled);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<FreizeitenBloc>(),
      child: BlocConsumer<FreizeitenBloc, FreizeitenState>(
        listener: (context, state) {
          if (state is Error) {
            Scaffold.of(context).showSnackBar(
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
            return FreizeitenPageViewer(
                state.freizeiten, context, isCacheEnabled);
          }
        },
      ),
    );
  }
}

Widget FreizeitenPageViewer(
    List<Freizeit> freizeiten, BuildContext context, bool isCacheEnabled) {
  return RefreshIndicator(
      child: SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        child: ConstrainedBox(
          constraints:
              BoxConstraints(minHeight: MediaQuery.of(context).size.height),
          child: Swiper(
            itemBuilder: (BuildContext context, int index) {
              return FreizeitCard(freizeiten[index], context, isCacheEnabled);
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
      });
}

// ignore_for_file: camel_case_types

import 'package:eje/pages/articles/presentation/widgets/details_page.dart';
import 'package:eje/core/widgets/loading_indicator.dart';
import 'package:eje/pages/articles/domain/entity/Hyperlink.dart';
import 'package:eje/pages/eje/hauptamtlichen/domain/entitys/employee.dart';
import 'package:eje/pages/eje/hauptamtlichen/presentation/bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class EmployeeDetails extends StatelessWidget {
  final Employee employee;
  EmployeeDetails(this.employee);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<EmployeesBloc, EmployeesState>(
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
            BlocProvider.of<EmployeesBloc>(context)
                .add(GettingEmployee(employee.name));
            print("Build Page EmployeeDetail: Empty");
            return LoadingIndicator();
          }
          if (state is Loading) {
            print("Build Page EmployeeDetail: Loading");
            return LoadingIndicator();
          } else if (state is LoadedEmployee) {
            print("Build Page EmployeeDetail: LoadedEmployee");
            return EmployeeDetailsCard(employee: state.employee);
          } else {
            print("Build Page EmployeeDetail: Undefined");
            return LoadingIndicator();
          }
        },
      ),
    );
  }
}

class EmployeeDetailsCard extends StatelessWidget {
  final Employee employee;
  const EmployeeDetailsCard({Key key, this.employee}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<String> bilder = List.empty(growable: true);
    bilder.add(employee.image);
    return DetailsPage(
        titel: employee.name,
        untertitel: employee.function,
        bilder: bilder,
        pictureHeight: 400,
        text: employee.introduction,
        hyperlinks: [Hyperlink(link: "", description: "")],
        childWidget: _childEmployeeDetails(hauptamtlicher: employee));
  }
}

class _childEmployeeDetails extends StatelessWidget {
  final Employee hauptamtlicher;
  const _childEmployeeDetails({Key key, this.hauptamtlicher}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 12,
        ),
        Divider(),
        hauptamtlicher.threema != ''
            ? ListTile(
                leading: Image(
                  image: ExactAssetImage("assets/images/icons8_threema_48.png"),
                  width: 24,
                  height: 24,
                  color: Theme.of(context).dividerColor,
                ),
                title: Text(
                  hauptamtlicher.threema,
                  style: TextStyle(
                    fontSize: 42 / MediaQuery.of(context).devicePixelRatio,
                    color: Theme.of(context).dividerColor,
                  ),
                ),
                trailing: GestureDetector(
                  child: Icon(
                    MdiIcons.messageReplyText,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                  onTap: () async {
                    if (await canLaunch(
                        "https://threema.id/" + hauptamtlicher.threema)) {
                      await launch(
                          "https://threema.id/" + hauptamtlicher.threema);
                    } else {
                      throw 'Could not open Threema';
                    }
                  },
                ),
              )
            : SizedBox(
                height: 12,
              ),
        hauptamtlicher.email != ''
            ? ListTile(
                leading: Icon(
                  MdiIcons.email,
                  color: Theme.of(context).dividerColor,
                  size: 24,
                ),
                title: Text(
                  hauptamtlicher.email,
                  style: TextStyle(
                    fontSize: 42 / MediaQuery.of(context).devicePixelRatio,
                    color: Theme.of(context).dividerColor,
                  ),
                ),
                dense: true,
                trailing: GestureDetector(
                  child: Icon(
                    MdiIcons.emailEdit,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                  onTap: () async {
                    if (await canLaunch("mailto:" + hauptamtlicher.email)) {
                      await launch("mailto:" + hauptamtlicher.email);
                    } else {
                      throw 'Could not open Email';
                    }
                  },
                ),
              )
            : SizedBox(
                height: 12,
              ),
        hauptamtlicher.telefon != ''
            ? ListTile(
                leading: Icon(
                  MdiIcons.phone,
                  color: Theme.of(context).dividerColor,
                  size: 24,
                ),
                title: Text(
                  hauptamtlicher.telefon,
                  style: TextStyle(
                    fontSize: 42 / MediaQuery.of(context).devicePixelRatio,
                    color: Theme.of(context).dividerColor,
                  ),
                ),
                dense: true,
                trailing: GestureDetector(
                  child: Icon(
                    MdiIcons.phoneOutgoing,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                  onTap: () async {
                    if (await canLaunch("tel:" + hauptamtlicher.telefon)) {
                      await launch("tel:" + hauptamtlicher.telefon);
                    } else {
                      throw 'Could not open telephone';
                    }
                  },
                ),
              )
            : SizedBox(
                height: 12,
              ),
        hauptamtlicher.handy != ''
            ? ListTile(
                leading: Icon(
                  MdiIcons.cellphone,
                  color: Theme.of(context).dividerColor,
                  size: 24,
                ),
                title: Text(
                  hauptamtlicher.handy,
                  style: TextStyle(
                    fontSize: 42 / MediaQuery.of(context).devicePixelRatio,
                    color: Theme.of(context).dividerColor,
                  ),
                ),
                dense: true,
                trailing: GestureDetector(
                  child: Icon(
                    MdiIcons.phoneOutgoing,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                  onTap: () async {
                    if (await canLaunch("tel:" + hauptamtlicher.handy)) {
                      await launch("tel:" + hauptamtlicher.handy);
                    } else {
                      throw 'Could not open telephone';
                    }
                  },
                ))
            : SizedBox(
                height: 12,
              ),
        SizedBox(
          height: 14,
        )
      ],
    );
  }
}

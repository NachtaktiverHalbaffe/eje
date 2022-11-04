import 'dart:convert';
import 'package:flutter/services.dart';

class AppConfig {
  // * Remote data sources
  // Top level domain
  final String domain;
  // Endpoint for RSS-feed to feed "Neuigkeiten"
  final String newsEndpoint;
  // Endpoint for WebScraper to feed "Hauptamtliche"
  final String employeesEndpoint;
  // Endpoint for WebScraper to feed "BAK"
  final String bakEndpoint;
  // Endpoint for WebScraper to feed "Arbeitsbereiche"
  final String fieldOfWorkEndpoint;
  // ID of html element "header" which should not be webscraped
  final String idHeader;
  // ID of html element "contacts" which should not be webscraped
  final String idContact;
  // ID of html element "adress" which should not be webscraped
  final String idAdress;
  // Source uri for banner picture which is displayed at top of homepage
  final String bannerPicture;
// Source uri for picture displayed in contacts section of website
  final String contactPicture;

  // * Local data sources. Local data is stored in boxes which are identified by keys (box names)
  // Box name for "Neuigkeiten"
  final String newsBox;
  // Box name for "Articles"
  final String articlesBox;
  // Box name for "Arbeitsbereiche"
  final String fieldOfWorkBox;
  // Box name for "BAK"
  final String bakBox;
  // Box name for "Hauptamtliche"
  final String employeesBox;
  // Box name for "Services"
  final String servicesBox;
  // Box name for "Freizeiten"
  final String campsBox;
  //  Box name for "Veranstaltungen"
  final String eventsBox;

  AppConfig({
    this.domain = "",
    this.newsEndpoint = "",
    this.employeesEndpoint = "",
    this.bakEndpoint = "",
    this.fieldOfWorkEndpoint = "",
    this.idHeader = "",
    this.idContact = "",
    this.idAdress = "",
    this.bannerPicture = "",
    this.contactPicture = "",
    this.newsBox = "",
    this.articlesBox = "",
    this.fieldOfWorkBox = "",
    this.bakBox = "",
    this.employeesBox = "",
    this.servicesBox = "",
    this.campsBox = "",
    this.eventsBox = "",
  });

  // Loads config either from dev configuration or from production configuration
  // @param:
  //    env: specified which configuration should be loaded (configuration must be named same as env)
  // @return:
  //    AppConfig: Configuration for app
  static Future<AppConfig> loadConfig() async {
    // set default to dev if nothing was passed
    final String env = 'prod';

    // load the json file
    final contents = await rootBundle.loadString(
      'assets/config/$env.json',
    );

    // decode our json
    final json = jsonDecode(contents);

    // convert our JSON into an instance of our AppConfig class
    return AppConfig(
        domain: json['domain'],
        newsEndpoint: json['newsEndpoint'],
        employeesEndpoint: json['employeesEndpoint'],
        bakEndpoint: json['bakEndpoint'],
        fieldOfWorkEndpoint: json['fieldOfWorkEndpoint'],
        idHeader: json["idHeader"],
        idContact: json["idContact"],
        idAdress: json["idAdress"],
        bannerPicture: json["bannerPicture"],
        contactPicture: json["contactPicture"],
        newsBox: "News",
        articlesBox: "Articles",
        fieldOfWorkBox: "FieldsOfWork",
        bakBox: "BAK",
        employeesBox: "Employees",
        servicesBox: "Services",
        campsBox: "Camps",
        eventsBox: "Events");
  }
}

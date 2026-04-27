import 'package:advertising_user/seller_sb/features/setting/controller/setting_controller.dart';
import 'package:advertising_user/seller_sb/main.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:advertising_user/main.dart';

class Language {
  final String name;
  final String languageCode;
  final String imageName;
  Language(this.name, this.languageCode, this.imageName);
}

// ignore: use_key_in_widget_constructors
class LanguageBottomSheet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Container(
            width: 200,
            height: 50,
            decoration: BoxDecoration(
              color: appTheme.primaryBackground,
              borderRadius: BorderRadius.circular(8),
            ),
            child: dropDown(context),
          ),
        ],
      ),
    );
  }
}

Widget dropDown(BuildContext context) {
  List<Language> languages = [
    Language('English', 'en', 'assets/images/united kindom flag.jpg'),
    Language('العربية', 'ar', 'assets/images/arab language flag.webp'),
  ];
  Language selectedLanguage =
      Get.find<SettingController>().language.languageCode == 'ar'
          ? languages[1]
          : languages[0];
  return DropdownButtonHideUnderline(
      child: DropdownButton<Language>(
    isExpanded: true,
    hint: Text(
      selectedLanguage.name.toString(),
      style: TextStyle(
        color: appTheme.primaryText, // your theme color here
        fontWeight: FontWeight.normal,
        fontSize: 13,
      ),
    ),
    value: selectedLanguage,
    onChanged: (Language? newValue) async {
      Get.find<SettingController>().changeLanguage(newValue!.languageCode);
    },
    items: languages.map<DropdownMenuItem<Language>>((Language language) {
      return DropdownMenuItem<Language>(
        value: language,
        child: Container(
          color: appTheme.primaryBackground,
          constraints: const BoxConstraints(),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                        width: 30,
                        height: 25,
                        child: Image.asset(language.imageName)),
                  ),
                  Text(
                    language.name,
                    style: TextStyle(
                      color: appTheme.info, // your theme color here
                      fontWeight: FontWeight.normal,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    }).toList(),
  ));
}

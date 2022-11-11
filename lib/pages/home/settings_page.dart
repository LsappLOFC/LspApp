// ignore_for_file: constant_identifier_names, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:lspapp/utilities/constraints.dart';
import 'package:lspapp/utilities/widgets.dart';
import 'package:lspapp/pages/settings/indications_page.dart';
import 'package:lspapp/pages/settings/recommendations_page.dart';
import 'package:lspapp/pages/settings/suggestions_page.dart';
import 'package:lspapp/utilities/variables.dart' as variables;
import 'package:lspapp/services/user_service.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

enum RadioValues {
  Lento,
  Normal,
  Rapido,
}

class _SettingsPageState extends State<SettingsPage> {
  RadioValues? values;
  @override
  void initState() {
    if (variables.selectedRadioValue == 0) {
      values = RadioValues.Lento;
    } else if (variables.selectedRadioValue == 1) {
      values = RadioValues.Normal;
    } else {
      values = RadioValues.Rapido;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: mySecundaryColor,
      padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width * 0.1),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          signSpeed(),
          indications(context),
          recommendations(context),
          suggestions(context),
          signOut(context),
        ],
      ),
    );
  }

  Column signSpeed() {
    return Column(
      children: [
        Text(
          "Velocidad de señas",
          style: myTitleStyle(),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                Radio(
                    value: RadioValues.Lento,
                    groupValue: values,
                    activeColor: myMainColor,
                    onChanged: (value) {
                      setState(() {
                        variables.selectedRadioValue = 0;
                        values = value as RadioValues?;
                      });
                    }),
                Text(
                  "Lento",
                  style: mySubTitleStyle(),
                ),
              ],
            ),
            Row(
              children: [
                Radio(
                    value: RadioValues.Normal,
                    groupValue: values,
                    activeColor: myMainColor,
                    onChanged: (value) {
                      setState(() {
                        variables.selectedRadioValue = 1;
                        values = value as RadioValues?;
                      });
                    }),
                Text(
                  "Normal",
                  style: mySubTitleStyle(),
                ),
              ],
            ),
            Row(
              children: [
                Radio(
                    value: RadioValues.Rapido,
                    groupValue: values,
                    activeColor: myMainColor,
                    onChanged: (value) {
                      setState(() {
                        variables.selectedRadioValue = 2;
                        values = value as RadioValues?;
                      });
                    }),
                Text(
                  "Rápido",
                  style: mySubTitleStyle(),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Column indications(BuildContext context) {
    return Column(
      children: [
        myDivider(),
        ListTile(
          title: Text(
            "Indicaciones de uso",
            style: myTitleStyle(),
          ),
          trailing: Icon(
            Icons.navigate_next_sharp,
            size: 40.0,
            color: myMainColor,
          ),
          onTap: () {
            Navigator.pushNamed(context, IndicationsPage.id);
          },
        ),
      ],
    );
  }

  Column recommendations(BuildContext context) {
    return Column(
      children: [
        myDivider(),
        ListTile(
          title: Text("Recomendaciones", style: myTitleStyle()),
          trailing: Icon(
            Icons.navigate_next_sharp,
            size: 40.0,
            color: myMainColor,
          ),
          onTap: () {
            Navigator.pushNamed(context, RecommendationsPage.id);
          },
        ),
      ],
    );
  }

  Column suggestions(BuildContext context) {
    return Column(
      children: [
        myDivider(),
        ListTile(
          title: Text("Sugerencias", style: myTitleStyle()),
          trailing: Icon(
            Icons.navigate_next_sharp,
            size: 40.0,
            color: myMainColor,
          ),
          onTap: () {
            Navigator.pushNamed(context, SuggestionsPage.id);
          },
        ),
      ],
    );
  }

  Column signOut(BuildContext context) {
    return Column(
      children: [
        myDivider(),
        ListTile(
          title: Text("Cerrar sesión", style: myTitleStyle()),
          trailing: Icon(
            Icons.output_sharp,
            size: 30.0,
            color: myMainColor,
          ),
          onTap: () async {
            UserService userService = UserService();
            userService.signOut(context);
          },
        ),
      ],
    );
  }
}

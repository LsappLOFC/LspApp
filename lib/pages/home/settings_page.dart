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
          vertical: MediaQuery.of(context).size.height * 0.1,
          horizontal: MediaQuery.of(context).size.width * 0.1),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          signSpeed(),
          myDivider(),
          indications(context),
          myDivider(),
          recommendations(context),
          myDivider(),
          suggestions(context),
          myDivider(),
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
          style: mySubTitleStyle(),
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
                  style: myRadiusTextStyle(),
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
                  style: myRadiusTextStyle(),
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
                  style: myRadiusTextStyle(),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  ListTile indications(BuildContext context) {
    return ListTile(
      title: Text(
        "Indicaciones de uso",
        style: mySubTitleStyle(),
      ),
      trailing: Icon(
        Icons.navigate_next_sharp,
        size: 40.0,
        color: myMainColor,
      ),
      onTap: () {
        Navigator.pushNamed(context, IndicationsPage.id);
      },
    );
  }

  ListTile recommendations(BuildContext context) {
    return ListTile(
      title: Text("Recomendaciones", style: mySubTitleStyle()),
      trailing: Icon(
        Icons.navigate_next_sharp,
        size: 40.0,
        color: myMainColor,
      ),
      onTap: () {
        Navigator.pushNamed(context, RecommendationsPage.id);
      },
    );
  }

  ListTile suggestions(BuildContext context) {
    return ListTile(
      title: Text("Sugerencias", style: mySubTitleStyle()),
      trailing: Icon(
        Icons.navigate_next_sharp,
        size: 40.0,
        color: myMainColor,
      ),
      onTap: () {
        Navigator.pushNamed(context, SuggestionsPage.id);
      },
    );
  }

  ListTile signOut(BuildContext context) {
    return ListTile(
      title: Text("Cerrar sesión", style: mySubTitleStyle()),
      trailing: Icon(
        Icons.output_sharp,
        size: 30.0,
        color: myMainColor,
      ),
      onTap: () async {
        UserService userService = UserService();
        userService.signOut(context);
      },
    );
  }
}

// ignore_for_file: constant_identifier_names, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:lspapp/constants/constraints.dart';
import 'package:lspapp/constants/widgets.dart';
import 'package:lspapp/pages/home/indicaciones_page.dart';
import 'package:lspapp/pages/settings/recommendations_page.dart';
import 'package:lspapp/pages/settings/suggestions_page.dart';
import 'package:lspapp/pages/home/variables.dart' as variables;
import 'package:lspapp/services/user_service.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  static String id = '/settings';
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
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Configuración",
          style: myAppBarTitleStyle(),
        ),
        centerTitle: true,
        backgroundColor: myMainColor,
        automaticallyImplyLeading: false,
      ),
      backgroundColor: mySecundaryColor,
      body: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width * 0.1),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            signSpeed(),
            SizedBox(height: MediaQuery.of(context).size.height * 0.05),
            indications(context),
            recommendations(context),
            suggestions(context),
            signOut(context),
          ],
        ),
      ),
    );
  }

  Column signSpeed() {
    return Column(
      children: [
        Text(
          "Velocidad de señas",
          style: mySettingTitleStyle(),
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
                Text("Lento"),
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
                Text("Normal"),
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
                Text("Rápido"),
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
            style: mySettingTitleStyle(),
          ),
          trailing: Icon(
            Icons.navigate_next_sharp,
            size: 40.0,
            color: Colors.blue,
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const IndicacionesPage()),
            );
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
          title: Text("Recomendaciones", style: mySettingTitleStyle()),
          trailing: const Icon(
            Icons.navigate_next_sharp,
            size: 40.0,
            color: Colors.blue,
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const RecommendationsPage()),
            );
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
          title: Text("Sugerencias", style: mySettingTitleStyle()),
          trailing: const Icon(
            Icons.navigate_next_sharp,
            size: 40.0,
            color: Colors.blue,
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const SuggestionsPage()),
            );
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
          title: Text("Cerrar sesión", style: mySettingTitleStyle()),
          trailing: const Icon(
            Icons.output_sharp,
            size: 30.0,
            color: Colors.blue,
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

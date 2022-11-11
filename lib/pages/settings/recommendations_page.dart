// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:lspapp/utilities/constraints.dart';
import 'package:lspapp/utilities/widgets.dart';

class RecommendationsPage extends StatefulWidget {
  const RecommendationsPage({Key? key}) : super(key: key);

  static String id = '/recommendations';

  @override
  State<RecommendationsPage> createState() => _RecommendationsPageState();
}

class _RecommendationsPageState extends State<RecommendationsPage> {
  final _textRecommendation = TextEditingController();

  final _keyForm = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: mySecundaryAppBar(context, ''),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Container(
          color: mySecundaryColor,
          child: Form(
            key: _keyForm,
            child: Center(
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width * 0.1),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    //!Title
                    Text(
                      "Recomendaciones",
                      style: myTitleStyle(),
                      textAlign: TextAlign.start,
                    ),
                    myDivider(),
                    //!Subtitle
                    Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: MediaQuery.of(context).size.height * 0.05),
                      child: Text(
                        "Envíanos tus recomendaciones sobre el uso de la Lengua de Señas Peruanas (LSP)",
                        textAlign: TextAlign.justify,
                        style: mySubTitleStyle(),
                      ),
                    ),
                    //!Comment Body
                    Container(
                      margin: EdgeInsets.zero,
                      child: TextFormField(
                        maxLength: 200,
                        minLines: 7,
                        maxLines: 7,
                        controller: _textRecommendation,
                        validator: (value) {
                          return validateComment(value!.trim());
                        },
                        decoration: myInputDecoration(
                            'Ingrese sus recomendaciones aquí'),
                        style: myContentTextStyle(),
                      ),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                    //!Send Button
                    InkWell(
                      onTap: () {
                        if (_keyForm.currentState!.validate()) {
                          popUpSendComment(context, _textRecommendation.text,
                              'recomendacion');
                        }
                      },
                      child: sendButton(context),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

String? validateComment(String value) {
  if (value.isEmpty) {
    return 'La recomendación no puede estar vacia';
  }
  if (value.length < 5) {
    return 'La recomendación es demasiado corta.';
  }
  return null;
}

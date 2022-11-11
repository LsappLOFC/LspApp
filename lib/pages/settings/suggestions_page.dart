// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:lspapp/utilities/constraints.dart';
import 'package:lspapp/utilities/widgets.dart';

class SuggestionsPage extends StatefulWidget {
  const SuggestionsPage({Key? key}) : super(key: key);

  static String id = '/suggestions';

  @override
  State<SuggestionsPage> createState() => _SuggestionsPageState();
}

class _SuggestionsPageState extends State<SuggestionsPage> {
  final _textRecommendation = TextEditingController();

  final _keyForm = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: mySecundaryAppBar(context, ''),
        body: Container(
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
                      "Sugerencias",
                      style: myTitleStyle(),
                      textAlign: TextAlign.start,
                    ),
                    myDivider(),
                    //!Subtitle
                    Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: MediaQuery.of(context).size.height * 0.05),
                      child: Text(
                        "Envíanos tus sugerencias sobre el uso de la Lengua de Señas Peruanas (LSP)",
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
                        decoration:
                            myInputDecoration('Ingrese sus sugerencias aquí'),
                        style: myContentTextStyle(),
                      ),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                    //!Send Button
                    InkWell(
                      onTap: () {
                        if (_keyForm.currentState!.validate()) {
                          popUpSendComment(
                              context, _textRecommendation.text, 'sugerencia');
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
    return 'La sugerencia no puede estar vacia';
  }
  if (value.length < 5) {
    return 'La sugerencia es demasiado corta.';
  }
  return null;
}

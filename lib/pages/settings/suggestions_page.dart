// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:lspapp/constants/constraints.dart';
import 'package:lspapp/constants/widgets.dart';

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
        appBar: myAppBar(context),
        body: Form(
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
                    style: myCommentTitleStyle(),
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
                      style: myCommentSubTitleStyle(),
                    ),
                  ),
                  //!Comment Body
                  Container(
                    margin: EdgeInsets.zero,
                    child: TextFormField(
                      maxLength: 160,
                      maxLines: 5,
                      controller: _textRecommendation,
                      validator: (value) {
                        return validateComment(value!.trim());
                      },
                      decoration: myCommentDecoration('sugerencias'),
                      style: myCommentBodyStyle(),
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

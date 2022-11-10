// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:lspapp/constants/constraints.dart';
import 'package:lspapp/constants/widgets.dart';

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
                    "Recomendaciones",
                    style: myCommentTitleStyle(),
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
                      decoration: myCommentDecoration('recomendaciones'),
                      style: myCommentBodyStyle(),
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                  //!Send Button
                  InkWell(
                    onTap: () {
                      if (_keyForm.currentState!.validate()) {
                        popUpSendComment(
                            context, _textRecommendation.text, 'recomendacion');
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
    return 'La recomendación no puede estar vacia';
  }
  if (value.length < 5) {
    return 'La recomendación es demasiado corta.';
  }
  return null;
}

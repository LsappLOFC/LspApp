import 'dart:io';
import 'package:flutter/material.dart';

class Files extends StatefulWidget {
  const Files({super.key});

  @override
  State<Files> createState() => _FilesState();
}

class _FilesState extends State<Files> {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        "FILES",
        style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
      ),
    );
  }
}

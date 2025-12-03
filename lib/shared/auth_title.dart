import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AuthPageTitle extends StatelessWidget {
  final String title;

  const AuthPageTitle(this.title, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 32),
      child: Text(
        title,
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: const Color(0xFFFEE440),
        ),
      ),
    );
  }
}
import 'package:contact_card/cards/mecard.dart';
import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

const mecardText =
    'MECARD:N:Doe,John;ORG:ABC Company;TEL:+123456789;TEL:+987654321;EMAIL:john.doe@abccompany.com;ADR:123 Main St, Anytown, CA 12345;NOTE:This is a note;BDAY:1970-01-01;URL:http://www.abccompany.com;TITLE:Marketing Director;NICKNAME:Johnny;X-SOCIALPROFILE;type=twitter:http://twitter.com/johndoe;X-SOCIALPROFILE;type=linkedin:http://www.linkedin.com/in/johndoe;;';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: Theme.of(context).copyWith(useMaterial3: true),
      title: 'Contact Card App',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Contact Card App'),
          centerTitle: true,
        ),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton(
                child: const Text('MeCard'),
                onPressed: () {
                  final card = MeCard.fromPlainText(mecardText);
                  debugPrint(card.toString());
                  debugPrint(card.toPlainText());
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

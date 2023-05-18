import 'package:contact_card/cards/mecard.dart';
import 'package:contact_card/cards/vcard.dart';
import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

const mecardText =
    'MECARD:N:Doe,John;ORG:ABC Company;TEL:+123456789;TEL:+987654321;EMAIL:john.doe@abccompany.com;ADR:123 Main St, Anytown, CA 12345;NOTE:This is a note;BDAY:1970-01-01;URL:http://www.abccompany.com;TITLE:Marketing Director;NICKNAME:Johnny;X-SOCIALPROFILE;type=twitter:http://twitter.com/johndoe;X-SOCIALPROFILE;type=linkedin:http://www.linkedin.com/in/johndoe;;';

const vcard1Text = '''
BEGIN:VCARD
VERSION:1.0
N:Gonzalez;Juan;;;
FN:Juan Gonzalez
TEL:555-1234
TEL;HOME:555-5678
ADR;WORK:;;123 Main St.;Anytown;CA;12345;USA
ADR;HOME:;;456 Oak St.;Othertown;CA;67890;USA
EMAIL:juan.gonzalez@work.com
EMAIL:juan.gonzalez@gmail.com
ORG:Acme Inc.;Sales Department
TITLE:Sales Representative
ROLE:Sales
URL:http://www.johndoe.com
PHOTO;JPEG:http://www.example.com/photo.jpg
LOGO;GIF:http://www.example.com/logo.gif
LABEL;WORK;ENCODING=QUOTED-PRINTABLE:Acme Inc.=0D=0ASales Department=0D=0A123 Main St.=0D=0AAnytown, CA 12345=0D=0AUSA
LABEL;HOME;ENCODING=QUOTED-PRINTABLE:456 Oak St.=0D=0AOthertown, CA 67890=0D=0AUSA
END:VCARD''';

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
              ElevatedButton(
                child: const Text('vCard 1.0'),
                onPressed: () {
                  final card = VCard1.fromPlainText(vcard1Text);
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

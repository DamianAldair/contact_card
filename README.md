# Contact Card

by [Damian Aldair](https://github.com/DamianAldair)

A dart library to work with MeCard and vCard in their different versions. Create MeCard or vCard objects from text and vice versa.

Ideal for working in applications using QR readers.

## Features

| Format     | Text to Object | Object to Text |
|:----------:|:--------------:|:--------------:|
| MeCard 2.1 |       ✅       |       ✅       |
| vCard 1.0  |       ✅       |       ✅       |
| vCard 2.1  |       ⌛       |       ⌛       |
| vCard 3.0  |       ⌛       |       ⌛       |
| vCard 4.0  |       ⌛       |       ⌛       |

For vCards, the following fields are missing to be implemented:
- CLIENTPIDMAP
- KEY
- LABEL
- LOGO
- MEMBER
- NAME
- PHOTP
- PRODID
- RELATED
- SOUND
- TZ
- UID

## Getting started

Just import this library in the pubspec.yaml.

```yaml
dependencies:
  contact_card:
```

All done.

## Usage

```dart
final MeCard card1 = MeCard.fromPlainText(sampleText1);
final String plainText1 = card1.toPlainText();

final VCard1 card2 = MeCard.fromPlainText(sampleText2);
final String plainText2 = card2.toPlainText();
```


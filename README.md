# Contact Card

by [Damian Aldair](https://github.com/DamianAldair)

A dart library to work with MeCard and vCard in their different versions. Create MeCard or vCard objects from text and vice versa.

Ideal for working in applications using QR readers.

## Features

| Format    | Text to Object | Object to Text |
|:---------:|:--------------:|:--------------:|
| MeCard    |       ✅       |       ✅       |
| vCard 1.0 |       ⌛       |       ⌛       |
| vCard 2.1 |       ⌛       |       ⌛       |
| vCard 3.0 |       ⌛       |       ⌛       |
| vCard 4.0 |       ⌛       |       ⌛       |

## Getting started

Just import this library in the pubspec.yaml.

```yaml
dependencies:
  contact_card:
```

All done.

## Usage

```dart
final MeCard card = MeCard.fromPlainText(sampleText);
final String plainText = card.toPlainText();
```


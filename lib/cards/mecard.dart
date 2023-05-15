import 'package:contact_card/errors.dart';

class MeCard {
  final String name;
  final String? lastName;
  final String? nickname;
  final String? organization;
  final String? role;
  final List<String>? telephones;
  final List<String>? emails;
  final List<String>? addresses;
  final List<String>? urls;
  final DateTime? birthday;
  final List<MeCardSocialProfile>? socialProfiles;
  final String? note;

  MeCard({
    required this.name,
    this.lastName,
    this.nickname,
    this.organization,
    this.role,
    this.telephones,
    this.emails,
    this.addresses,
    this.urls,
    this.birthday,
    this.socialProfiles,
    this.note,
  });

  factory MeCard.fromPlainText(String plainText) {
    String text = plainText.replaceAll('\n', '');
    if (!text.startsWith('MECARD:') || !text.endsWith(';;')) {
      throw MeCardParsingError('MeCard must start with "MECARD:" and end with ";;".');
    }
    text = text.substring(7, text.length - 2).trim();
    final texts = text.split(';');
    String name = '';
    String? lastName;
    String? nickname;
    String? organization;
    String? role;
    List<String> telephones = [];
    List<String> emails = [];
    List<String> addresses = [];
    List<String> urls = [];
    DateTime? birthday;
    List<MeCardSocialProfile> socialProfiles = [];
    String? note;

    for (int i = 0; i < texts.length; i++) {
      final t = texts[i];
      if (t.contains('N:')) {
        final temp = t.substring(2).split(',');
        name = temp[1].trim();
        if (name.isEmpty) {
          throw MeCardParsingError('The "N" field, for "name", is mandatory.');
        }
        if (temp[0].trim().isNotEmpty) {
          lastName = temp[0].trim();
        }
      } else if (t.contains('NICKNAME:')) {
        nickname = t.substring(9).trim();
      } else if (t.contains('ORG:')) {
        organization = t.substring(4).trim();
      } else if (t.contains('TITLE:')) {
        role = t.substring(6).trim();
      } else if (t.contains('TEL:')) {
        telephones.add(t.substring(4).trim());
      } else if (t.contains('EMAIL:')) {
        emails.add(t.substring(6).trim());
      } else if (t.contains('ADR:')) {
        addresses.add(t.substring(4).trim());
      } else if (t.contains('URL:')) {
        urls.add(t.substring(4).trim());
      } else if (t.contains('BDAY:')) {
        birthday = DateTime.tryParse(t.substring(5).trim());
      } else if (t.contains('X-SOCIALPROFILE')) {
        i++;
        final tt = texts[i].replaceFirst(':', ';').split(';');
        socialProfiles.add(MeCardSocialProfile(
          type: tt.first.trim().substring(5),
          url: tt[1],
        ));
      } else if (t.contains('NOTE:')) {
        note = t.substring(5);
      }
    }
    return MeCard(
      name: name,
      lastName: lastName,
      nickname: nickname,
      organization: organization,
      role: role,
      telephones: telephones,
      emails: emails,
      addresses: addresses,
      urls: urls,
      birthday: birthday,
      socialProfiles: socialProfiles,
      note: note,
    );
  }

  MeCard copyWith({
    String? name,
    String? lastName,
    String? nickname,
    String? organization,
    String? role,
    List<String>? telephones,
    List<String>? emails,
    List<String>? addresses,
    List<String>? urls,
    DateTime? birthday,
    List<MeCardSocialProfile>? socialProfiles,
    String? note,
  }) =>
      MeCard(
        name: name ?? this.name,
        lastName: lastName ?? this.lastName,
        nickname: nickname ?? this.nickname,
        organization: organization ?? this.organization,
        role: role ?? this.role,
        telephones: telephones ?? this.telephones,
        emails: emails ?? this.emails,
        addresses: addresses ?? this.addresses,
        urls: urls ?? this.urls,
        birthday: birthday ?? this.birthday,
        socialProfiles: socialProfiles ?? this.socialProfiles,
        note: note ?? this.note,
      );

  @override
  String toString() {
    final buffer = StringBuffer();
    buffer.writeln('Name: $name');
    buffer.writeln('Last name: $lastName');
    buffer.writeln('Nickname: $nickname');
    buffer.writeln('Organization: $organization');
    buffer.writeln('Role: $role');
    buffer.writeln('Phones: ${telephones.toString()}');
    buffer.writeln('Emails: ${emails.toString()}');
    buffer.writeln('Addresses: ${addresses.toString()}');
    buffer.writeln('URLs: ${urls.toString()}');
    buffer.writeln('Birthday: ${birthday?.toIso8601String()}');
    buffer.writeln('Social profiles: ${socialProfiles.toString()}');
    buffer.writeln('Note: $note');
    return buffer.toString();
  }

  String toPlainText() {
    final buffer = StringBuffer();
    buffer.write('MECARD:');
    buffer.write('N:');
    if (lastName != null && lastName!.isNotEmpty) buffer.write(lastName);
    buffer.write(',$name;');
    if (organization != null) buffer.write('ORG:$organization;');
    if (telephones != null) {
      for (String t in telephones!) {
        buffer.write('TEL:$t;');
      }
    }
    if (emails != null) {
      for (String e in emails!) {
        buffer.write('EMAIL:$e;');
      }
    }
    if (addresses != null) {
      for (String a in addresses!) {
        buffer.write('ADR:$a;');
      }
    }
    if (note != null) buffer.write('NOTE:$note;');
    if (birthday != null) {
      buffer.write('BDAY:${birthday!.toIso8601String().split('T').first};');
    }
    if (urls != null) {
      for (String u in urls!) {
        buffer.write('URL:$u;');
      }
    }
    if (role != null) buffer.write('TITLE:$role;');
    if (nickname != null) buffer.write('NICKNAME:$nickname;');
    if (socialProfiles != null) {
      for (MeCardSocialProfile s in socialProfiles!) {
        buffer.write('X-SOCIALPROFILE;${s.toPlainText()};');
      }
    }
    buffer.write(';');
    return buffer.toString();
  }
}

class MeCardSocialProfile {
  final String type;
  final String url;

  MeCardSocialProfile({
    required this.type,
    required this.url,
  });

  String toPlainText() => 'type=$type:$url';

  @override
  String toString() => '$type: $url';
}

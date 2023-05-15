import 'package:contact_card/errors/errors.dart';

/// MeCard is a data file similar to vCard
/// but used by NTT DoCoMo in Japan in QR code format
/// for use with Cellular Phones.
///
/// Example: MECARD:N:Doe,John;TEL:13035551212;EMAIL:john.doe@example.com;;
///
/// https://en.wikipedia.org/wiki/MeCard_(QR_code)
class MeCard {
  /// A structured representation of the name of the person.
  /// When a field is divided by a comma (,),
  /// the first half is treated as the last name
  /// and the second half is treated as the first name.
  final String name;

  /// A structured representation of the name of the person.
  /// When a field is divided by a comma (,),
  /// the first half is treated as the last name
  /// and the second half is treated as the first name.
  final String? lastName;

  /// Familiar name for the object represented by this MeCard.
  final String? nickname;

  /// The name of the contact organization.
  final String? organization;

  /// Job title of contact.
  final String? role;

  /// List of contact telephone numbers.
  ///
  /// The canonical number string for a telephone number for telephony communication.
  final List<String>? telephones;

  /// List of contact telephone numbers.
  ///
  /// The canonical string for a videophone number communication.
  final List<String>? videophones;

  /// List of contact emails.
  ///
  /// The address for electronic mail communication.
  final List<String>? emails;

  /// List of contact addresses.
  ///
  /// The physical delivery address.
  /// The fields divided by commas (,)
  /// denote PO box, room number, house number, city, prefecture, zip code and country, in order.
  final List<String>? addresses;

  /// List of contact URLs.
  ///
  /// A URL pointing to a website that represents the person in some way.
  final List<String>? urls;

  /// 8 digits for date of birth: year (4 digits), month (2 digits) and day (2 digits), in order.
  final DateTime? birthday;

  /// List of contact Social Profiles.
  ///
  /// In addition to the type of profile, the URL of the profile is indicated.
  final List<MeCardSocialProfile>? socialProfiles;

  /// Specifies supplemental information to be set as memo in the phonebook.
  final String? note;

  /// Default constructor. Only `name` is required.
  MeCard({
    required this.name,
    this.lastName,
    this.nickname,
    this.organization,
    this.role,
    this.telephones,
    this.videophones,
    this.emails,
    this.addresses,
    this.urls,
    this.birthday,
    this.socialProfiles,
    this.note,
  });

  /// Constructor from the plain text of the MeCard.
  ///
  /// It is important to respect the format of the `MeCard`.
  /// The `MeCard` format starts with the tag "MECARD:" and ends with a colon (";;").
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
    List<String> videophones = [];
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
      } else if (t.contains('TEL-AV:')) {
        videophones.add(t.substring(7).trim());
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
      videophones: videophones,
      emails: emails,
      addresses: addresses,
      urls: urls,
      birthday: birthday,
      socialProfiles: socialProfiles,
      note: note,
    );
  }

  /// Creates a copy of this `MeCard` but with the given fields replaced with the new values.
  MeCard copyWith({
    String? name,
    String? lastName,
    String? nickname,
    String? organization,
    String? role,
    List<String>? telephones,
    List<String>? videophones,
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
        videophones: videophones ?? this.videophones,
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
    buffer.writeln('Telephones: ${telephones.toString()}');
    buffer.writeln('Videophones: ${videophones.toString()}');
    buffer.writeln('Emails: ${emails.toString()}');
    buffer.writeln('Addresses: ${addresses.toString()}');
    buffer.writeln('URLs: ${urls.toString()}');
    buffer.writeln('Birthday: ${birthday?.toIso8601String()}');
    buffer.writeln('Social profiles: ${socialProfiles.toString()}');
    buffer.writeln('Note: $note');
    return buffer.toString();
  }

  /// A plain text representation of the `MeCard`.
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
    if (videophones != null) {
      for (String v in videophones!) {
        buffer.write('TEL-AV:$v;');
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

/// Represents a social profile within `MeCard`.
class MeCardSocialProfile {
  /// Profile type. It can be `youtube`, `twitter`, `linkedin`, etc.
  final String type;

  /// Profile URL.
  final String url;

  MeCardSocialProfile({
    required this.type,
    required this.url,
  });

  /// A plain text representation of how the social profile is displayed within the `MeCard`.
  String toPlainText() => 'type=$type:$url';

  @override
  String toString() => '$type: $url';
}

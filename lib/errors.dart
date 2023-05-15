class CardParsingError extends Error {}

class MeCardParsingError extends CardParsingError {
  final Object? message;
  MeCardParsingError([this.message]);
}

class VCardParsingError extends CardParsingError {
  final Object? message;
  VCardParsingError([this.message]);
}

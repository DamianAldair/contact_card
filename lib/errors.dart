class CardParsingError extends Error {
  final Object? message;
  CardParsingError([this.message]);
}

class MeCardParsingError extends CardParsingError {
  MeCardParsingError([super.message]);
}

class VCardParsingError extends CardParsingError {
  VCardParsingError([super.message]);
}

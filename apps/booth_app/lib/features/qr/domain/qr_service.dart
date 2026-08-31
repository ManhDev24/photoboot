import 'package:uuid/uuid.dart';

class QRService {
  static const String baseUrl = 'https://photobooth.app/q';

  static String generateToken() {
    return const Uuid().v4().replaceAll('-', '').substring(0, 12);
  }

  static String buildGuestGalleryUrl(String token) {
    return '$baseUrl/$token';
  }
}

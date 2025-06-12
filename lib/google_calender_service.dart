import 'package:googleapis/calendar/v3.dart' as calendar;
import 'package:google_sign_in/google_sign_in.dart';
import 'google_http_client.dart';

class GoogleCalendarService {
  final GoogleSignInAccount user;

  GoogleCalendarService(this.user);

  Future<void> insertEvent(
    String title,
    DateTime startTime, {
    Duration duration = const Duration(hours: 1),
    String timeZone = "Asia/Jakarta",
  }) async {
    try {
      final authHeaders = await user.authHeaders;
      final httpClient = GoogleHttpClient(authHeaders);
      final calendarApi = calendar.CalendarApi(httpClient);

      final event = calendar.Event(
        summary: title,
        start: calendar.EventDateTime(dateTime: startTime, timeZone: timeZone),
        end: calendar.EventDateTime(
          dateTime: startTime.add(duration),
          timeZone: timeZone,
        ),
      );

      await calendarApi.events.insert(event, "primary");
    } catch (e) {
      print('Error inserting event: $e');
      rethrow;
    }
  }

  Future<List<String>> getTodayEvents() async {
    try {
      final authHeaders = await user.authHeaders;
      final httpClient = GoogleHttpClient(authHeaders);
      final calendarApi = calendar.CalendarApi(httpClient);

      final now = DateTime.now();
      final startOfDay = DateTime(now.year, now.month, now.day);
      final endOfDay = startOfDay.add(const Duration(days: 1));

      final events = await calendarApi.events.list(
        "primary",
        timeMin: startOfDay.toUtc(),
        timeMax: endOfDay.toUtc(),
        singleEvents: true,
        orderBy: 'startTime',
      );

      return events.items
              ?.where((event) => event.summary != null)
              .map((event) => event.summary!)
              .toList() ??
          [];
    } catch (e) {
      print('Error fetching today\'s events: $e');
      rethrow;
    }
  }
}

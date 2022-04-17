import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:code_karo/ui/screens/utils.dart';

class LocalNotifs {
  static Future<void> createDummyNotif() async {
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: createUniqueId(),
        channelKey: 'scheduled_channel',
        title:
            '${Emojis.computer_desktop_computer + Emojis.time_seven_o_clock} Time to code!!!',
        body: 'Its been so long since you last coded :)',
        bigPicture: 'asset://assets/images/alarm-icon.png',
        notificationLayout: NotificationLayout.BigPicture,
      ),
    );
  }

  static Future<void> createWaterReminderNotification(
      NotificationWeekAndTime notificationSchedule) async {
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: createUniqueId(),
        channelKey: 'scheduled_channel',
        title: '${Emojis.wheater_droplet} Add some water to your plant!',
        body: 'Water your plant regularly to keep it healthy.',
        notificationLayout: NotificationLayout.Default,
      ),
      actionButtons: [
        NotificationActionButton(
          key: 'MARK_DONE',
          label: 'Mark Done',
        ),
      ],
      schedule: NotificationCalendar(
        weekday: notificationSchedule.dayOfTheWeek,
        hour: notificationSchedule.timeOfDay.hour,
        minute: notificationSchedule.timeOfDay.minute,
        second: 0,
        millisecond: 0,
      ),
    );
  }

  static Future<void> cancelScheduledNotifications() async {
    await AwesomeNotifications().cancelAllSchedules();
  }
}

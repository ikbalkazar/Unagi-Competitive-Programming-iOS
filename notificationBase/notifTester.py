from notificationSender import NotificationSender as sender

ns = sender("Merhaba", ["ikbalRating"])

print(ns.send())
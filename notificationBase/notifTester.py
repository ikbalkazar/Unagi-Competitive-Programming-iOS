from notificationSender import NotificationSender as sender

ns = sender("Rating Test", ["ikbalRating"])

print(ns.send())
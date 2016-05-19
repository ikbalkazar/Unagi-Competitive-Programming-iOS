from notificationSender import NotificationSender as sender

ns = sender("Rating Test", ["hexorRating"])

print(ns.send())
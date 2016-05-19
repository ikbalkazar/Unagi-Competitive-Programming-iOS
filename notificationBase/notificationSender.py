import json,httplib

class NotificationSender(object):
  def __init__(self, text, channels):
    self.text = text 
    self.channels = channels

  def send(self):
    connection = httplib.HTTPSConnection('api.parse.com', 443)
    connection.connect()

    connection.request('POST', '/1/push', json.dumps({
           "channels": self.channels,
           "data": {
             "alert": self.text
           }
         }), {
           "X-Parse-Application-Id": "8xMwvCqficeHwkS7Ag5PQWdlw1q91ujGcXVRgUnG",
           "X-Parse-REST-API-Key": "utzFK6Be6yOJBeNF6KoeJIsSONxfnLoZIeyQuopK",
           "Content-Type": "application/json"
         })

    result = json.loads(connection.getresponse().read())
    return result


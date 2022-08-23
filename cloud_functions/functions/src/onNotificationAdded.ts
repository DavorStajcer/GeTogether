import * as admin from "firebase-admin";
import * as functions from "firebase-functions";

export enum NotificationType { info, join, leave }

export const onJoinNotificationCreated = async (senderId: string, eventId: string) => {
  await admin.firestore()
    .collection("users")
    .doc(senderId)
    .collection("sent_requests")
    .doc(eventId)
    .set({
      "timestamp": admin.firestore.FieldValue.serverTimestamp()
    })
}

export const incrementUnreadNotifications = async (receiverId: string, eventId: string) => {
  functions.logger.log(`STARTING THE INCREMENT,receiverId -> ${receiverId}, eventid -> ${eventId}`)

  let unreadNotificationsReference = admin.firestore()
    .collection("users")
    .doc(receiverId)
    .collection("unread_data")
    .doc("notifications")
    ;
  let unreadDocData = await unreadNotificationsReference.get()
  functions.logger.log(`DOES DATA EXIST -> ${unreadDocData.exists}`)
  if (unreadDocData.exists)
    await unreadNotificationsReference.update({
      "unreadNotifications": admin.firestore.FieldValue.increment(1),
    })
  else
    await unreadNotificationsReference.set({
      "unreadNotifications": 1,
    })

}


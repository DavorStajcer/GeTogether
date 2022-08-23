import * as admin from "firebase-admin";
import * as functions from "firebase-functions";
import { NotificationType } from "./onNotificationAdded";


export enum NotificationResolved { pending, accepted, rejected }


export const sendAcceptedNoitifcation = async (senderId: string, eventName: string, eventId: string) => {
  await admin.firestore()
    .collection("users")
    .doc(senderId)
    .collection("user_notifications")
    .add({
      "type": NotificationType.info.valueOf(),
      "content": `Your request to join event "${eventName}" is Accepted`,
      "timestamp": admin.firestore.FieldValue.serverTimestamp()
    })
}

export const sendRejectedNoitifcation = async (senderId: string, eventName: string, eventId: string) => {
  await admin.firestore()
    .collection("users")
    .doc(senderId)
    .collection("user_notifications")
    .add({
      "type": NotificationType.info.valueOf(),
      "content": `Your request to join event "${eventName}" is Rejected`,
      "timestamp": admin.firestore.FieldValue.serverTimestamp()
    })
}

export const deleteResolvedRequest = async (senderId: string, eventId: string) => {
  functions.logger.log(`DELETING RESOLVED REQUEST,SENDER ID -> ${senderId}, eventId -> ${eventId}`)
  await admin.firestore()
    .collection("users")
    .doc(senderId)
    .collection("sent_requests")
    .doc(eventId)
    .delete()
}
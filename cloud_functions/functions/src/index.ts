import * as functions from "firebase-functions";
import * as admin from "firebase-admin";
import { addEventIdToAdmin, mapEvents, createEventGroupChat } from "./onEventCreated";
import { updateEventsAdminData } from "./updateEventsDataForAdminId";
import { NotificationType, onJoinNotificationCreated, incrementUnreadNotifications } from "./onNotificationAdded";
import { NotificationResolved, sendAcceptedNoitifcation, sendRejectedNoitifcation, deleteResolvedRequest } from "./onJoinNotificationResolved";
import { getAddedOrRemovedEventMember, removeEventIdFromUser, deleteEventGroupChat, incrementNumOfPeople, addEventIdToUser, UserEventsOperationData, UserEventsOperation, sendUserLeftNotification } from "./onEventDataChanged";
import { checkShouldAddNewPage, addMessageToUnreadMessages, updateChatSnippet } from "./onMessageCreated";

admin.initializeApp()


export const onUserDataChaneUpdateEventsWhereUserIsAdmin = functions.firestore
    .document("users/{userId}")
    .onUpdate(async (change, context) => {
        let userAfter = change.after.data()
        let dataToUpdate: FirebaseFirestore.UpdateData = {
            "adminImageUrl": userAfter.imageUrl,
            "adminRating": userAfter.rating,
            "adminUsername": userAfter.username,
        }
        let docCityEvents = await change.after.ref.collection("user_events").listDocuments()
        let userEvents: Map<string, string[]> = new Map()
        await mapEvents(docCityEvents, userEvents)
        updateEventsAdminData(userEvents, dataToUpdate)
    }
    )

export const onEventCreated = functions.firestore
    .document("events/{eventCity}/city_events/{eventId}")
    .onCreate(async (docSnapshot, context) => {
        await addEventIdToAdmin(context.params.eventCity, context.params.eventId, docSnapshot.data().adminId)
        await createEventGroupChat(context.params.eventId, docSnapshot, context.params.eventCity)
    })

export const onEventDataChanged = functions.firestore
    .document("events/{city}/city_events/{eventId}")
    .onUpdate(async (change, context) => {
        let dataBefore = change.before.data()
        let dataAfter = change.after.data()
        let userEventsOperation: UserEventsOperationData = getAddedOrRemovedEventMember(dataBefore, dataAfter)
        if (userEventsOperation.userId == null) return
        if (userEventsOperation.operation == UserEventsOperation.add) {
            await addEventIdToUser(userEventsOperation.userId!, context.params.eventId, context.params.city, dataAfter.eventName)
            await incrementNumOfPeople(1, context.params.eventId, context.params.city)
        }
        else {
            await removeEventIdFromUser(userEventsOperation.userId!, context.params.eventId, context.params.city, dataAfter.eventName, dataAfter.adminId)
            await sendUserLeftNotification(userEventsOperation.userId!, dataAfter.adminId, dataAfter.eventName)
            await incrementNumOfPeople(-1, context.params.eventId, context.params.city)
        }

    })

export const onEventDeleted = functions.firestore
    .document("events/{city}/city_events/{eventId}")
    .onDelete(async (snapshot, context) => {
        let eventData: FirebaseFirestore.DocumentData = snapshot.data()
        functions.logger.log(`chat id -> ${context.params.eventId}`)
        await deleteEventGroupChat(context.params.eventId)
        let idPicMap = eventData.peopleImageUrls as Map<string, any>
        functions.logger.log(`id Pic map -> ${Object.entries(idPicMap).keys}`)
        let eventUserIds : Array<string> = Array();
        Object.entries(idPicMap).forEach(([userId, imageUrl]) => {
            eventUserIds.push(userId)
        })
        eventUserIds.push(eventData.adminId)
        for(var userId of eventUserIds){
            await removeEventIdFromUser(userId, context.params.eventId, context.params.city, eventData.eventName, eventData.adminId)
            await admin.firestore()
            .collection("users")
            .doc(userId)
            .collection("unread_data")
            .doc("chats")
            .update({
                "newlyMessagedChats" : admin.firestore.FieldValue.arrayRemove(userId),
                "number" : admin.firestore.FieldValue.increment(-1),
            })

        }
        functions.logger.log(`admin id -> ${eventData.adminId}`)
    })

export const onMessageCreated = functions.firestore
    .document("chats/{chatId}/messages/{page}/page_messages/{messageId}")
    .onCreate(async (change, context) => {
        await updateChatSnippet(change, context)
        await checkShouldAddNewPage(change, context);
        //New messages in one group chat cooresponds to 1 new message notification
        //In other words, it counts in how many group chats there are new messages
        await addMessageToUnreadMessages(change, context)
    })

export const onUnreadChatsDataChanged = functions.firestore
    .document("users/{userId}/unread_data/chats")
    .onUpdate(async (change, context) => {
        let dataBefore = change.before.data()
        let dataAfter = change.after.data()
        let chatsArrayLenghtBefore = dataBefore.newlyMessagedChats == undefined ? 0 : (dataBefore.newlyMessagedChats as Array<string>).length
        let chatsArrayLenghtAfter = dataAfter.newlyMessagedChats == undefined ? 0 : (dataAfter.newlyMessagedChats as Array<string>).length
        if (chatsArrayLenghtBefore == chatsArrayLenghtAfter) return
        await admin.firestore()
            .collection("users")
            .doc(context.params.userId)
            .collection("unread_data")
            .doc("chats")
            .update({
                "number": chatsArrayLenghtAfter,
            }
            )
    })

export const onNotificationAdded = functions.firestore
    .document("users/{userId}/user_notifications/{notificationId}")
    .onCreate(async (change, context) => {
        functions.logger.log(`NOTIFICATION ADDED`)
        let notificationData = change.data()
        let notificationType: number = notificationData.type
        if (notificationType == null) return
        await incrementUnreadNotifications(context.params.userId, notificationData.eventId)
        if (notificationType == NotificationType.join.valueOf())
            await onJoinNotificationCreated(notificationData.senderId, notificationData.eventId)

    })

export const onJoinNotificationResolved = functions.firestore
    .document("users/{userId}/user_notifications/{notificationId}")
    .onUpdate(async (change, context) => {
        let notificationDataBefore = change.before.data()
        let notificationDataAfter = change.after.data()
        functions.logger.log(`NOTIFICATION MODIFIED TO RESOLVED STATUS -> ${notificationDataAfter.resolvedStatus}, BEFORE -> ${notificationDataBefore.resolvedStatus}`)
        if (notificationDataBefore.resolvedStatus != NotificationResolved.pending.valueOf()) return
        if (notificationDataAfter.resolvedStatus == NotificationResolved.accepted.valueOf())
            await sendAcceptedNoitifcation(notificationDataAfter.senderId, notificationDataAfter.eventName, notificationDataAfter.eventId)
        else
            await sendRejectedNoitifcation(notificationDataAfter.senderId, notificationDataAfter.eventName, notificationDataAfter.eventId)
        await deleteResolvedRequest(notificationDataAfter.senderId, notificationDataAfter.eventId)

    })










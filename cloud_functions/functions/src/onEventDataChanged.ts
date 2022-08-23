import * as admin from "firebase-admin";
import * as functions from "firebase-functions";
import { NotificationType } from "./onNotificationAdded";



export enum UserEventsOperation {
    add, remove
}

export class UserEventsOperationData {
    userId: string | null;
    operation: UserEventsOperation | null;
    constructor(userId: string | null, operation: UserEventsOperation | null) {
        this.userId = userId;
        this.operation = operation;
    }
}

export const getAddedOrRemovedEventMember = (dataBefore: FirebaseFirestore.DocumentData, dataAfter: FirebaseFirestore.DocumentData): UserEventsOperationData => {
    let idPicMapBefore = dataBefore.peopleImageUrls as Map<string, any>
    let idPicMapAfter = dataAfter.peopleImageUrls as Map<string, any>

    var addedOrRemovedUserId: string | null = null
    var operation: UserEventsOperation | null = null


    if (getSizeOfMap(idPicMapAfter) == getSizeOfMap(idPicMapBefore)) {
        addedOrRemovedUserId = null
        operation = null
    }
    else if (getSizeOfMap(idPicMapAfter) > getSizeOfMap(idPicMapBefore)) {
        operation = UserEventsOperation.add
        Object.entries(idPicMapAfter).forEach(([userId, imageUrl]) => {
            let doesHaveUid = false
            Object.entries(idPicMapBefore).forEach(([beforeUserId, imageUrl]) => {
                if (beforeUserId == userId)
                    doesHaveUid = true
            })
            if (doesHaveUid == false)
                addedOrRemovedUserId = userId
        })
    }
    else {
        operation = UserEventsOperation.remove
        Object.entries(idPicMapBefore).forEach(([userId, imageUrl]) => {
            let doesHaveUid = false
            Object.entries(idPicMapAfter).forEach(([afterUserId, imageUrl]) => {
                if (afterUserId == userId)
                    doesHaveUid = true
            })
            if (doesHaveUid == false)
                addedOrRemovedUserId = userId
        })
    }
    return new UserEventsOperationData(addedOrRemovedUserId, operation);
}

export const  getSizeOfMap = (map: Map<string, any>): number => {
    let size: number = 0
    Object.entries(map).forEach(([userId, imageUrl]) => {
        size++
    })
    return size
}



export const addEventIdToUser = async (userId: string, eventId: string, eventCity: string, eventName: string) => {
    let cityDocReference =
        admin
            .firestore()
            .collection("users")
            .doc(userId)
            .collection("user_events")
            .doc(eventCity)
    let snapshot = await cityDocReference.get()
    if (snapshot.exists) {
        await cityDocReference
            .update({
                "eventIds": admin.firestore.FieldValue.arrayUnion(eventId)
            })
    } else {
        await cityDocReference
            .set({
                "adminIds": [],
                "eventIds": [eventId]
            })
    }
/*     await admin
    .firestore()
    .collection("events")
    .doc(eventCity)
    .collection("city_events")
    .doc(eventId)
    .update({
        "numberOfPeople" : admin.firestore.FieldValue.increment(1),
    }) */
}

export const removeEventIdFromUser = async (userId: string, eventId: string, eventCity: string, eventName: string, adminId: string) => {
    let cityDocReference =
        admin
            .firestore()
            .collection("users")
            .doc(userId)
            .collection("user_events")
            .doc(eventCity)
    let snapshot = await cityDocReference.get()
    functions.logger.log(`removing event id from user -> ${userId}`)
    if (snapshot.exists) {
        await cityDocReference
            .update({
                "eventIds": admin.firestore.FieldValue.arrayRemove(eventId),
                "adminIds": admin.firestore.FieldValue.arrayRemove(eventId)
            })
        //await sendUserLeftNotification(userId,adminId, eventName)
    }
/*     await admin
    .firestore()
    .collection("events")
    .doc(eventCity)
    .collection("city_events")
    .doc(eventId)
    .update({
        "numberOfPeople" : admin.firestore.FieldValue.increment(-1),
    }) */
}

export const incrementNumOfPeople = async (increment : number, eventId: string, eventCity: string,) => {
    await admin
    .firestore()
    .collection("events")
    .doc(eventCity)
    .collection("city_events")
    .doc(eventId)
    .update({
        "numberOfPeople" : admin.firestore.FieldValue.increment(-1),
    }) 
}

export const sendUserLeftNotification = async (userId:string,adminId: string, eventName: string) => {

    let userSnapshot = await admin.firestore()
    .collection("users")
    .doc(userId)
    .get()

    let userData = userSnapshot.data()
    if(userData == undefined) return
    let leftUsername = userData.username
    let leftImageUrl = userData.imageUrl

    await admin.firestore()
        .collection("users")
        .doc(adminId)
        .collection("user_notifications")
        .add({
            "type": NotificationType.leave.valueOf(),
            "senderImageUrl": leftImageUrl,
            "content": `${leftUsername} has left your event "${eventName}"`,
            "timestamp": admin.firestore.FieldValue.serverTimestamp(),

        })
}

export const deleteEventGroupChat = async (chatId : string) => {
    await admin.firestore()
    .collection("chats")
    .doc(chatId)
    .delete()
}


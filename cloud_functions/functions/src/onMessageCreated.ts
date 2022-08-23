import * as functions from "firebase-functions";
import * as admin from "firebase-admin";

export const checkShouldAddNewPage = async (
    change: functions.firestore.QueryDocumentSnapshot,
    context: functions.EventContext) => {
    let eventChatRef = admin.firestore()
        .collection("chats")
        .doc(`${context.params.chatId}`);
    let messages = await change.ref.parent.listDocuments()
    if (messages.length >= 10) {
        admin.firestore().runTransaction(async (transaction) => {
            transaction.update(eventChatRef, "lastPageNum", admin.firestore.FieldValue.increment(1))
        })
    }
}
export const updateChatSnippet = async (
    change: functions.firestore.QueryDocumentSnapshot,
    context: functions.EventContext
) => {
    functions.logger.log(`STARTING TO UPDATE CHAT SNIPPET`)
    let messageData = change.data();
    let chatId = context.params.chatId
    let eventId = chatId

    let memberIds = await getEventMembersIdsExceptMessageSender(messageData.eventCity, eventId, messageData.senderId)   
    functions.logger.log(`GOT MEMBER IDS -> ${memberIds.length}`)
    
        await admin
        .firestore()
        .collection("chats")
        .doc(chatId)
        .update({
            "adminImageUrl": messageData.userImageUrl,
            "lastMessageDate": messageData.timestamp,
            "unreadFor": memberIds.length > 0 ? admin.firestore.FieldValue.arrayUnion(...memberIds) : [],
            "lastMessageSnippet": messageData.content,
        })
}

//When user leaves the chat messages screen on client side he resets the unread messages
export const addMessageToUnreadMessages = async (
    change: functions.firestore.QueryDocumentSnapshot,
    context: functions.EventContext
) => {
    functions.logger.log(`ADDING MESSAGE TO UNREAD MESSAGES`)
    let messageData = change.data();
    //chat id = eventId in firestore
    let eventId = context.params.chatId
    let memberIds: Array<string> = await getEventMembersIdsExceptMessageSender(messageData.eventCity, eventId, messageData.senderId)
    
    functions.logger.log(`MEMBER IDs lenght -> ${memberIds.length}`)
    for (let i = 0; i < memberIds.length; i++) {
        let unreadChatsRef = admin.firestore()
            .collection("users")
            .doc(memberIds[i])
            .collection("unread_data")
            .doc("chats")
        let unreadChatsSnapshot = await unreadChatsRef
            .get()
        let unreadData = unreadChatsSnapshot.data()
        if (!unreadChatsSnapshot.exists) await createUnreadChatsData(memberIds[i], eventId);
        else if (unreadData == undefined) await createUnreadChatsData(memberIds[i], eventId);
        else
            await updateUnreadChatsData(memberIds[i], eventId)

    }
}

const getEventMembersIdsExceptMessageSender = async (eventCity: string, eventId: string, senderId: string): Promise<Array<string>> => {
    functions.logger.log(`GETTING EVENT MEMBER IDs`)
    let eventDataSnapshot = await admin.firestore()
        .collection("events")
        .doc(eventCity)
        .collection("city_events")
        .doc(eventId)
        .get()
    if (!eventDataSnapshot.exists) return [];
    let eventData = eventDataSnapshot.data()
    if (eventData == undefined) return [];
    let peopleImageUrls: Map<string, any> = eventData["peopleImageUrls"]
    let memeberIds: Array<string> = []
    Object.entries(peopleImageUrls).forEach(([userId, imageUrl]) => {
        if (senderId != userId)
            memeberIds.push(userId)
    })
    if (senderId != eventData.adminId)
        memeberIds.push(eventData.adminId)    
    return memeberIds;
}

const createUnreadChatsData = async (userId: string, eventId: string) => {
    functions.logger.log(`CREATING UNREAD CHAT DATA FOR userId -> ${userId},eventid -> ${eventId}`)
    await admin.firestore()
        .collection("users")
        .doc(userId)
        .collection("unread_data")
        .doc("chats")
        .set(
            {
                "newlyMessagedChats": [eventId],
                "number": 1,
            }
        )
}
const updateUnreadChatsData = async (userId: string, eventId: string) => {
    functions.logger.log(`UPDATING UNREAD CHAT DATA FOR userId -> ${userId},eventid -> ${eventId}`)
    await admin.firestore()
        .collection("users")
        .doc(userId)
        .collection("unread_data")
        .doc("chats")
        .update(
            "newlyMessagedChats", admin.firestore.FieldValue.arrayUnion(eventId)
        )
}



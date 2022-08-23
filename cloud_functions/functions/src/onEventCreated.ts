import * as admin from "firebase-admin";
import * as functions from "firebase-functions";


export async function addEventIdToAdmin(city: string, eventId: string, adminId: string) {
    let cityDocReference = admin
        .firestore()
        .collection("users")
        .doc(adminId)
        .collection("user_events")
        .doc(city)
    let snapshot = await cityDocReference.get()
    if (snapshot.exists)
        await cityDocReference
            .update({
                "adminIds": admin.firestore.FieldValue.arrayUnion(eventId)
            })
    else
        await cityDocReference
            .set({
                "adminIds": [eventId],
                "eventIds": []
            })
}

export const mapEvents = async (docCityList: FirebaseFirestore.DocumentReference<FirebaseFirestore.DocumentData>[], map: Map<string, string[]>) => {
    for (const docRef of docCityList) {
        let docSnapshot = await docRef.get()
        if (docSnapshot.data() == undefined) throw new URIError(`Document snapshot in city ${docRef.id} is undentified !`)
        else
            map.set(docRef.id, (docSnapshot.data()!.adminIds as string[]))

    }
}

export async function createEventGroupChat(eventId: string, eventDocSnapshot: functions.firestore.QueryDocumentSnapshot,eventCity:string) {

    await admin
        .firestore()
        .collection("chats")
        .doc(eventId)
        .set({
            "adminImageUrl": eventDocSnapshot.data().adminImageUrl,
            "eventName": eventDocSnapshot.data().eventName,
            "eventCity":eventCity,
            "lastMessageDate": null,
            "lastMessageSnippet": null,
            "unreadFor" : [],
            "createDate" : admin.firestore.FieldValue.serverTimestamp(),
            "lastPageNum": 1
        })

}
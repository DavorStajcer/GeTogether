import * as admin from "firebase-admin";

export async function updateEventsAdminData( userEvents: Map<string, Array<string>>, updatedUserData: {}) {
    userEvents.forEach((eventIdList, city, map) => {
        eventIdList.forEach(async (eventId, index) => {
           await admin
                .firestore()
                .collection("events")
                .doc(city)
                .collection("city_events")
                .doc(eventId)
                .update(updatedUserData)
        })
    })
}
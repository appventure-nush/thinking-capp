import * as functions from "firebase-functions";
import * as admin from "firebase-admin";

admin.initializeApp();

export const sendNotification = functions.https.onRequest(async (request, response) => {
  const db = admin.firestore();
  const token = "redacted";
  const payload = {
    token,
    notification: {
      title: "test",
      body: "Test Body"
    }
  }
  const res = await admin.messaging().send(payload);
  console.log(res);
  response.send(JSON.stringify({ ok: true }));
});

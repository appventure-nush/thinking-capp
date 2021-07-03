import * as functions from "firebase-functions";
import * as admin from "firebase-admin";
import { BasicNotification, User } from "./types";

admin.initializeApp();

export const sendNotification = functions.https.onCall(
  async (data, context) => {

    if (!context.auth) {
      throw new functions.https.HttpsError('failed-precondition', 'The function must be called ' +
          'while authenticated.');
    }

    const notification = data as BasicNotification;

    const users = await getUsers(notification);
    if (!users.length) {
      return { ok: false, error: "No applicable users" };
    }

    users.map((user: User) => {
      user.fcmTokens.map((token: string) => {
        const payload = {
          token,
          notification: renderNotification(notification),
        };
        admin.messaging().send(payload);
      });
    });
    return { ok: true };
  }
);

async function getUsers(notification: BasicNotification): Promise<User[]> {
  const db = admin.firestore();
  const usersCollection = db.collection("emails");
  const users = await Promise.all(
    (
      await usersCollection.where("email", "!=", notification.authorEmail).get()
    ).docs.map(async (doc) => {
      return (await doc.data()) as User;
    })
  );
  return users.filter((user: User) => user.fcmTokens && user.fcmTokens.length > 0);
}

function renderNotification(notification: BasicNotification): {
  title: string;
  body: string;
} {
  const title =
    notification.type == "new_answer"
      ? `${notification.authorUsername} answered "${notification.questionTitle}"`
      : `${notification.authorUsername} asked "${notification.questionTitle}"`;
  const body = "Click here to view";
  return {
    title: title,
    body: body,
  };
}

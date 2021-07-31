export type NotificationType = "new_question" | "new_answer";

export interface User {
    email: string;
    username: string;
    fcmTokens: string[];
}

export interface BasicNotification {
    type: NotificationType;
    authorEmail: string;
    authorUsername: string;
    questionTitle: string;
    questionID: string;
}
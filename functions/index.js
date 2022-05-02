const functions = require("firebase-functions");

const admin = require("firebase-admin");
admin.initializeApp();

exports.messageFunction = functions.firestore
    .document("Chats/{chatid}/Messages/{messageid}")
    .onCreate((snap, context) => {
      console.log(snap.data());
      const newData = snap.data();
      const chatid = context.params.chatid;
      const type = newData.type;
      const bodyContent = newData.content;
      let titleType;

      if (type === "text") {
        titleType = "New Message";
      } else if (type === "media") {
        titleType = "New Media";
      } else {
        titleType = "New Location Update";
      }

      return admin
          .messaging()
          .sendToTopic(chatid, {
            notification: {
              title: titleType,
              body: bodyContent,
            },
          });
    }
    );

exports.dateTimeNotificationFunction = functions.firestore
    .document("Dates/{userid}/DateDetails/{dateid}")
    .onWrite((change, context) => {
      const after = change.after.data();
      const dateid = context.params.dateid;
      const dateStarted = after.dateStarted;
      let bodyContent;

      if (dateStarted === true) {
        bodyContent = "A Date Has Started";
      } else {
        bodyContent = "A Date Has Ended";
      }

      return admin
          .messaging()
          .sendToTopic(dateid, {
            notification: {
              title: "Cherub - Date Update",
              body: bodyContent,
            },
          });
    }
    );

exports.newFriendRequestAlertFunction = functions.firestore
    .document("Friends/{userid}/UserRequests/{requestid}")
    .onCreate((snap, context) => {
      console.log(snap.data());
      const userid = context.params.userid;

      return admin
          .messaging()
          .sendToTopic(userid, {
            notification: {
              title: "New Friend Request",
              body: "Someone has added you on Cherub, " +
              "make sure you know them before accepting any requests",
            },
          });
    }
    );

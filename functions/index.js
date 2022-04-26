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

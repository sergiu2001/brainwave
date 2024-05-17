/**
 * Import function triggers from their respective submodules:
 *
 * const {onCall} = require("firebase-functions/v2/https");
 * const {onDocumentWritten} = require("firebase-functions/v2/firestore");
 *
 * See a full list of supported triggers at https://firebase.google.com/docs/functions
 */

const { onRequest } = require("firebase-functions/v2/https");
const logger = require("firebase-functions/logger");
const { onDocumentCreated } = require("firebase-functions/v2/firestore");

const { initializeApp } = require("firebase-admin/app");
const { getFirestore, DocumentReference, CollectionReference, Timestamp } = require("firebase-admin/firestore");

const functions = require("firebase-functions");
const { user } = require("firebase-functions/v1/auth");
const { app } = require("firebase-admin");

initializeApp();

exports.createAccount = functions.auth.user().onCreate((user) => {

    const userUid = user.uid;
    const userEmail = user.email;

    const db = getFirestore();
    const usersCollection = db.collection("users");
    const userDoc = usersCollection.doc(userUid);
    return userDoc.set({ email: userEmail, firstName: "", lastName: "", dob: "", sex: "", weight: "", height: ""});
});

exports.updateAccount = functions.https.onCall(async (data, context) =>{

    const userUid = data.uid;
    const firstName = data.firstName;
    const lastName = data.lastName;
    const dob = data.dob;
    const sex = data.sex;
    const weight = data.weight;
    const height = data.height;
    const db = getFirestore();
    const userRef = db.collection("users").doc(userUid);
    console.log(data.uid);

    userRef.update({
        firstName: firstName,
        lastName: lastName,
        dob: dob,
        sex: sex,
        weight: weight,
        height: height
    });
});

exports.deleteAccount = functions.auth.user().onDelete((user) => {
    const userUid = user.uid;

    const db = getFirestore();
    const usersCollection = db.collection("users");
    const userDoc = usersCollection.doc(userUid);
    userDoc.collection("apps").doc("apps_usage").delete();
    return userDoc.delete();
});

exports.sendAppUsage = functions.https.onCall(async (data, context) => {
    const userUid = data.uid;
    const appList = data.appList;
    const db = getFirestore();
    const userRef = db.collection("users").doc(userUid);

    console.log(appList);
    console.log(userRef.path);
        appList.forEach((app) => {
            userRef.collection("apps").doc(app[1]).set({appName: app[0], appType: app[2], appUsage: app[3]}, {merge: true});
        });
});
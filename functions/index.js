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

exports.getUser = functions.https.onCall(async (data, context) => {
    const userUid = data.uid;
    
    const db = getFirestore();
    const userRef = db.collection("users").doc(userUid);

    try {
        const userDoc = await userRef.get();
        if (!userDoc.exists) {
            throw new functions.https.HttpsError('not-found', 'User profile not found');
        }
        const userProfile = userDoc.data();
        return userProfile;
    } catch (error) {
        throw new functions.https.HttpsError('internal', 'Unable to retrieve user profile', error);
    }
});

exports.sendAppUsage = functions.https.onCall(async (data, context) => {
    const userUid = data.uid;
    const appList = data.appList;
    const db = getFirestore();
    const userRef = db.collection("users").doc(userUid);

    console.log(appList);
    console.log(userRef.path);
        appList.forEach((app) => {
            userRef.collection("apps").doc(app[1]).set({appName: app[0], appPackageName: app[1], appType: app[2], appUsage: app[3], appDate: app[4]}, {merge: true});
        });
});

exports.getAppUsage = functions.https.onCall(async (data, context) => {
    const userUid = data.uid;
    const db = getFirestore();
    const userRef = db.collection("users").doc(userUid);

    const appUsage = [];
    const appUsageRef = await userRef.collection("apps").get();
    appUsageRef.forEach((doc) => {
        appUsage.push(doc.data());
    });
    return appUsage;
});

exports.sendReport = functions.https.onCall(async (data, context) => {
    const userUid = data.uid;
    const db = getFirestore();
    const apps = data.apps;
    const dailyActivities = data.dailyActivities;
    const mentalHealth = data.mentalHealth;
    const predictions = data.predictions;

    const userRef = db.collection("users").doc(userUid);

    console.log(apps);
    console.log(dailyActivities);
    console.log(mentalHealth);
    console.log(predictions);
    console.log(userRef.path);

    try {
        const reportRef = userRef.collection("reports").doc();
        const timestamp = Timestamp.now();

        await reportRef.set({
            apps: apps,
            dailyActivities: dailyActivities,
            mentalHealth: mentalHealth,
            timestamp: timestamp
        });

        const responseRef = userRef.collection("responses").doc();
        await responseRef.set({
            predictions: predictions,
            timestamp: timestamp
        });

        return { result: 'Report and predictions saved successfully' };
    } catch (error) {
        console.error("Error saving report: ", error);
        throw new functions.https.HttpsError('unknown', 'Error saving report', error);
    }
});

exports.getReport = functions.https.onCall(async (data, context) => {
    const userUid = data.uid;
    const db = getFirestore();
    const userRef = db.collection("users").doc(userUid);

    try {
        const reportsSnapshot = await userRef.collection("reports").get();
        const responsesSnapshot = await userRef.collection("responses").get();

        const reports = [];
        const responses = [];

        reportsSnapshot.forEach((doc) => {
            reports.push({ id: doc.id, ...doc.data() });
        });

        responsesSnapshot.forEach((doc) => {
            responses.push({ id: doc.id, ...doc.data() });
        });

        const matchedReportsAndResponses = reports.map((report) => {
            const matchingResponse = responses.find((response) => {
                return report.timestamp.isEqual(response.timestamp);
            });
            return {
                report,
                response: matchingResponse || null,
            };
        });

        return { matchedReportsAndResponses };
    } catch (error) {
        console.error("Error getting report and response: ", error);
        throw new functions.https.HttpsError('unknown', 'Error getting report and response', error);
    }
});
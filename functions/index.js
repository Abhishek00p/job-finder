const functions = require('firebase-functions');
const admin = require('firebase-admin');
const axios = require('axios');

admin.initializeApp();

exports.triggerN8nWorkflow = functions.https.onRequest(async (req, res) => {
  const { userId, filterId } = req.body;

  if (!userId || !filterId) {
    res.status(400).send('Missing userId or filterId');
    return;
  }

  try {
    const db = admin.firestore();
    const userDoc = await db.collection('users').doc(userId).get();
    const filterDoc = await db.collection('users').doc(userId).collection('filters').doc(filterId).get();

    if (!userDoc.exists || !filterDoc.exists) {
      res.status(404).send('User or filter not found');
      return;
    }

    const userData = userDoc.data();
    const filterData = filterDoc.data();

    const n8nWebhookUrl = functions.config().n8n.webhook_url;

    await axios.post(n8nWebhookUrl, {
      resumeUrl: userData.resumeUrl,
      ...filterData,
    });

    res.status(200).send('Workflow triggered successfully');
  } catch (error) {
    console.error('Error triggering n8n workflow:', error);
    res.status(500).send('Internal Server Error');
  }
});

const moongoose = require('mongoose');
const env = require('dotenv');


env.config();


const mongodb = process.env.MONGODB_URL;
moongoose.connect(mongodb, { useNewUrlParser: true, useUnifiedTopology: true, });


const db = moongoose.connection;

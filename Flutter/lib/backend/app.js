const express = require('express');
const path = require('path');
const BodyParser = require('body-parser');
const morgan = require('morgan');
const cors = require('cors');
const mongoose = require('mongoose');

require('dotenv/config');

const app = express();
const env = process.env;

app.use(BodyParser.json());
app.use(morgan('tiny'));
app.use(cors());
app.options('*',cors());

const authRouter = require('./routes/auth');
const productsRouter = require('./routes/products');

app.use(authRouter);
app.use(productsRouter);

const authorization = (req,res,next) => {
    const isAuthorized = true;
    if (isAuthorized) {
        console.log("User is Authorized");
        return next();
    } else {
        return res.status(401).send("User Unauthorized");
    }
};

// Middle ware -  executes for every oad of end point
app.use((req,res,next) => {
    console.log("Request made to the server");
    return next();
});

// GET method which displays string in html format
app.get('/',(req,res) => {
   return res.status(200).send("<h1>Ping Successful</h1>")
});

// GET method which returns json object
app.get('/dashboard/:id',authorization,(req,res) => {
   return res.json({cardId: req.params.id});
});

// GET method which sends file
app.get('/file', (req, res)=>{
    res.sendFile(path.join(__dirname,'image.jpg'));
});

const PORT = env.PORT;
const HOST = env.HOST;
const uri = env.MONGOSTR;
const clientOptions = { serverApi: { version: '1', strict: true, deprecationErrors: true } };
mongoose.connect(uri, clientOptions).then(() =>{
    console.log("Connected to MongoDB");
}).catch((error) =>{
    console.error(error);
});
app.listen(PORT, HOST, (error) => {
    if(!error)
        console.log(`Server running on http://${HOST}:${PORT}`);
    else
        console.log("Error occurred, server can't start", error);
});
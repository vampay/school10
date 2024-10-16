const express = require('express');
const mongoose = require('mongoose');
const dotenv = require('dotenv');
const cors = require('cors');
const bcrypt = require('bcrypt');
const User = require('../models/User'); 
dotenv.config(); // Load environment variables

const app = express();
app.use(cors());
app.use(express.json());

mongoose.connect(process.env.MONGO_DB_URL, {})
    .then(() => console.log('MongoDB connected'))
    .catch(err => console.log(err));

const authRoute = require('./routes/auth');
app.use('/api/auth', authRoute);
app.post('/api/auth/login', async (req, res) => {
    try {
        // Authentication logic here
    } catch (error) {
        console.error('Login Error:', error); // Log the error
        res.status(500).json({ message: 'Internal server error' });
    }
});

const PORT = process.env.PORT || 3000;

app.listen(PORT, () => console.log(`Server running on port ${PORT}`));

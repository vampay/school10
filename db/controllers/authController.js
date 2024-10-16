const User = require('../models/User'); // Adjust the path as necessary
const bcrypt = require('bcrypt');
const jwt = require('jsonwebtoken'); // For generating tokens

exports.register = async (req, res) => {
    const { username, password, name, role, email } = req.body;

    try {
        // Hash the password before saving
        const hashedPassword = await bcrypt.hash(password, 10);
        const newUser = new User({ username, password: hashedPassword, name, role, email });
        await newUser.save();
        res.status(201).json({ message: 'User registered successfully' });
    } catch (error) {
        res.status(500).json({ message: 'Error registering user' });
    }
};

exports.login = async (req, res) => {
    const { email, password } = req.body;

    try {
        const user = await User.findOne({ email });
        if (!user) {
            return res.status(400).json({ message: 'Invalid credentials' });
        }

        const isMatch = await bcrypt.compare(password, user.password);
        if (!isMatch) {
            return res.status(400).json({ message: 'Invalid credentials' });
        }

        // Generate tokens
        const accessToken = jwt.sign({ id: user._id }, process.env.ACCESS_TOKEN_SECRET, { expiresIn: '1h' });
        const refreshToken = jwt.sign({ id: user._id }, process.env.REFRESH_TOKEN_SECRET, { expiresIn: '7d' });

        res.json({ user, accessToken, refreshToken });
    } catch (error) {
        res.status(500).json({ message: 'Server error' });
    }
};

exports.refresh = async (req, res) => {
    const refreshToken = req.body.token;
    if (!refreshToken) return res.sendStatus(401);

    try {
        const user = jwt.verify(refreshToken, process.env.REFRESH_TOKEN_SECRET);
        const accessToken = jwt.sign({ id: user.id }, process.env.ACCESS_TOKEN_SECRET, { expiresIn: '1h' });
        res.json({ accessToken });
    } catch (error) {
        res.sendStatus(403);
    }
};

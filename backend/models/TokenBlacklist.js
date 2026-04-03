const mongoose = require('mongoose');

const tokenBlacklistSchema = new mongoose.Schema({
    token: { type: String, required: true },
    createdAt: { type: Date, default: Date.now, expires: 36000 } // Auto-remove after 10 hours
});

module.exports = mongoose.model('TokenBlacklist', tokenBlacklistSchema);

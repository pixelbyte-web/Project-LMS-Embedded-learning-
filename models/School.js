const mongoose = require('mongoose');

const schoolSchema = new mongoose.Schema({
    name: { type: String, required: true },
    schoolCode: { type: String, required: true, unique: true, minlength: 8, maxlength: 8 }
}, { timestamps: true });

module.exports = mongoose.model('School', schoolSchema);

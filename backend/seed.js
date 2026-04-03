const mongoose = require('mongoose');
const School = require('./models/School');
const dotenv = require('dotenv');

dotenv.config();

const seedDatabase = async () => {
    try {
        await mongoose.connect(process.env.MONGO_URI);
        console.log('MongoDB Connected for Seeding...');

        // Clear existing data for fresh testing
        // await School.deleteMany({});

        // 1. Create a dummy school (8 digit code)
        try {
            const school = new School({
                name: "Springfield High",
                schoolCode: "12345678"
            });
            await school.save();
            console.log('✅ Dummy School Created: Name="Springfield High", Code="12345678"');
        } catch(err) { console.log('⚠️ School possibly exists already.'); }

        console.log('\nSeed Complete! You can now use these credentials to test the API.');
        process.exit();
    } catch (err) {
        console.error(err);
        process.exit(1);
    }
};

seedDatabase();

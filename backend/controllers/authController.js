const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');
const Student = require('../models/Student');
const Instructor = require('../models/Instructor');
const School = require('../models/School');
const TokenBlacklist = require('../models/TokenBlacklist');

// Default Admin Credentials (can be moved to .env later)
const ADMIN_EMAIL = process.env.ADMIN_EMAIL || 'admin@lms.com';
const ADMIN_PASSWORD = process.env.ADMIN_PASSWORD || 'adminpassword123';

// Helper function to generate JWT
const generateToken = (userId, role) => {
    const payload = {
        user: {
            id: userId,
            role: role
        }
    };
    return jwt.sign(payload, process.env.JWT_SECRET, { expiresIn: '10h' });
};

// @desc    Register Student
exports.registerStudent = async (req, res) => {
    const { name, email, password, schoolCode } = req.body;
    try {
        const school = await School.findOne({ schoolCode });
        if (!school) {
            return res.status(400).json({ msg: 'Invalid School Code' });
        }

        let student = await Student.findOne({ email });
        if (student) {
            return res.status(400).json({ msg: 'Student email already exists' });
        }

        student = new Student({
            name,
            email,
            password,
            school: school._id
        });

        const salt = await bcrypt.genSalt(10);
        student.password = await bcrypt.hash(password, salt);

        await student.save();

        const token = generateToken(student._id, 'student');
        res.status(201).json({ token, role: 'student' });

    } catch (err) {
        console.error(err.message);
        res.status(500).send('Server Error');
    }
};

// @desc    Register Instructor
exports.registerInstructor = async (req, res) => {
    const { name, email, password, schoolCode } = req.body;
    try {
        const school = await School.findOne({ schoolCode });
        if (!school) {
            return res.status(400).json({ msg: 'Invalid School Code' });
        }

        let instructor = await Instructor.findOne({ email });
        if (instructor) {
            return res.status(400).json({ msg: 'Instructor email already exists' });
        }

        instructor = new Instructor({
            name,
            email,
            password,
            school: school._id,
            approved: false // Pending Approval
        });

        const salt = await bcrypt.genSalt(10);
        instructor.password = await bcrypt.hash(password, salt);

        await instructor.save();

        res.status(201).json({ msg: 'Registration successful. Waiting for admin approval.' });

    } catch (err) {
        console.error(err.message);
        res.status(500).send('Server Error');
    }
};

// @desc    Login for Student, Instructor, Admin
exports.login = async (req, res) => {
    const { email, password } = req.body;
    try {
        // 1. Check if Admin
        if (email === ADMIN_EMAIL && password === ADMIN_PASSWORD) {
            const token = generateToken('admin-default-id', 'admin');
            return res.json({ token, role: 'admin', name: 'Super Admin' });
        }

        // 2. Check if Student
        let student = await Student.findOne({ email }).populate('school');
        if (student) {
            const isMatch = await bcrypt.compare(password, student.password);
            if (!isMatch) return res.status(400).json({ msg: 'Invalid Credentials' });
            
            if (!student.school) {
                return res.status(403).json({ msg: 'School affiliation not found or invalid.' });
            }

            const token = generateToken(student._id, 'student');
            return res.json({ token, role: 'student', name: student.name });
        }

        // 3. Check if Instructor
        let instructor = await Instructor.findOne({ email }).populate('school');
        if (instructor) {
            const isMatch = await bcrypt.compare(password, instructor.password);
            if (!isMatch) return res.status(400).json({ msg: 'Invalid Credentials' });
            
            if (!instructor.approved) {
                return res.status(403).json({ msg: 'Waiting for admin approval' });
            }

            const token = generateToken(instructor._id, 'instructor');
            return res.json({ token, role: 'instructor', name: instructor.name });
        }

        // If not found in any
        return res.status(400).json({ msg: 'Invalid Credentials' });

    } catch (err) {
        console.error(err.message);
        res.status(500).send('Server Error');
    }
};

// @desc    Logout Feature
exports.logout = async (req, res) => {
    try {
        const authHeader = req.header('Authorization');
        if (authHeader && authHeader.startsWith('Bearer ')) {
            const token = authHeader.split(' ')[1];
            await TokenBlacklist.create({ token });
        }
        res.json({ msg: 'Logged out successfully.' });
    } catch (err) {
        console.error(err.message);
        res.status(500).send('Server Error');
    }
};

// @desc    Delete permanently signed-in user account
exports.deleteAccount = async (req, res) => {
    try {
        const { id, role } = req.user;

        // Ensure the Super Admin cannot delete their hardcoded environment configurations
        if (role === 'admin') {
            return res.status(403).json({ msg: 'Cannot delete the Super Admin account via API.' });
        }

        if (role === 'student') {
            const deleted = await Student.findByIdAndDelete(id);
            if (!deleted) return res.status(404).json({ msg: 'Student not found.' });
        } else if (role === 'instructor') {
            const deleted = await Instructor.findByIdAndDelete(id);
            if (!deleted) return res.status(404).json({ msg: 'Instructor not found.' });
        }

        // Blacklist their active token so it is destroyed instantly
        const authHeader = req.header('Authorization');
        if (authHeader && authHeader.startsWith('Bearer ')) {
            const token = authHeader.split(' ')[1];
            await TokenBlacklist.create({ token });
        }

        res.json({ msg: 'Account permanently deleted from database and session terminated.' });
    } catch (err) {
        console.error(err.message);
        res.status(500).send('Server Error');
    }
};

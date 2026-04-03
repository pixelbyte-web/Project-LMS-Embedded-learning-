const express = require('express');
const router = express.Router();
const { registerStudent, registerInstructor, login, logout, deleteAccount } = require('../controllers/authController');
const auth = require('../middleware/auth');

// @route   POST /api/auth/register/student
// @desc    Register a student
// @access  Public
router.post('/register/student', registerStudent);

// @route   POST /api/auth/register/instructor
// @desc    Register an instructor
// @access  Public
router.post('/register/instructor', registerInstructor);

// @route   POST /api/auth/login
// @desc    Login for all roles
// @access  Public
router.post('/login', login);

// @route   POST /api/auth/logout
// @desc    Logout user
// @access  Private
router.post('/logout', auth, logout);

// @route   DELETE /api/auth/delete
// @desc    Delete user account securely
// @access  Private
router.delete('/delete', auth, deleteAccount);

module.exports = router;

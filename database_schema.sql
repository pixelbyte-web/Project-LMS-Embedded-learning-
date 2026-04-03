-- Course Enrollment System Database Schema
-- MySQL Implementation

CREATE DATABASE IF NOT EXISTS course_enrollment_system;
USE course_enrollment_system;

-- Courses Table
CREATE TABLE courses (
    id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(200) NOT NULL,
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_title (title)
);

-- Students Table
CREATE TABLE IF NOT EXISTS students (
    id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Enrollments Table
CREATE TABLE enrollments (
    id INT AUTO_INCREMENT PRIMARY KEY,
    student_id INT NOT NULL,
    course_id INT NOT NULL,
    enrolled_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (student_id) REFERENCES students(id) ON DELETE CASCADE,
    FOREIGN KEY (course_id) REFERENCES courses(id) ON DELETE CASCADE,
    UNIQUE KEY unique_enrollment (student_id, course_id),
    INDEX idx_student (student_id),
    INDEX idx_course (course_id)
);

-- Sample Data: Students
INSERT INTO students (first_name, last_name, email) VALUES
('Alice', 'Johnson', 'alice.j@student.edu'),
('Bob', 'Miller', 'bob.m@student.edu'),
('Carol', 'White', 'carol.w@student.edu'),
('David', 'Taylor', 'david.t@student.edu'),
('Emma', 'Brown', 'emma.b@student.edu');

-- Sample Data: Courses
INSERT INTO courses (title, description) VALUES
('Introduction to Programming', 'Learn the fundamentals of programming using Python. Perfect for beginners with no prior coding experience.'),
('Web Development Fundamentals', 'Build modern websites using HTML, CSS, and JavaScript. Create responsive and interactive web applications.'),
('Database Management Systems', 'Master SQL and database design principles. Learn to create efficient and scalable database solutions.'),
('Data Structures and Algorithms', 'Deep dive into essential data structures and algorithms used in software development.'),
('Mobile App Development', 'Create native mobile applications for iOS and Android platforms using modern frameworks.'),
('Machine Learning Basics', 'Introduction to machine learning concepts, algorithms, and practical applications using Python.'),
('Cybersecurity Fundamentals', 'Learn essential security principles, threat detection, and protection strategies for modern systems.'),
('Cloud Computing with AWS', 'Master cloud infrastructure, deployment, and management using Amazon Web Services.');

-- Sample Data: Enrollments
INSERT INTO enrollments (student_id, course_id) VALUES
(1, 1), (1, 2),
(2, 1), (2, 3),
(3, 2), (3, 4),
(4, 1),
(5, 5);

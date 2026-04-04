# Course Enrollment System

## Features

✨ **Student Management** - Register and manage student profiles
📚 **Course Catalog** - Browse available courses with detailed descriptions
✅ **Enrollment System** - Enroll and unenroll from courses
📊 **Progress Tracking** - Track lesson completion and course progress
🎯 **Learning Paths** - Structured IoT Engineering learning journey
🔍 **Search & Filter** - Find courses by level, keywords, and enrollment status

## Project Structure

```
Course enrollment/
├── backend_api.py              # Flask REST API backend
├── course_enrollment_ui.html   # Full-stack frontend (HTML/CSS/JavaScript)
├── database_schema.sql         # Database schema reference (MySQL)
├── course_enrollment.db        # SQLite database (auto-generated)
└── README.md                   # This file
```

## Tech Stack

- **Backend**: Flask, Flask-CORS, SQLite3
- **Frontend**: HTML5, CSS3, Vanilla JavaScript (ES6+)
- **Database**: SQLite (development), MySQL (schema reference)

## Prerequisites

- Python 3.7+
- Flask
- Flask-CORS

## Installation & Setup

### 1. Install Dependencies

```bash
pip install flask flask-cors
```

### 2. Run the Backend API

Navigate to the project directory and start the Flask server:

```bash
python backend_api.py
```

The API will be available at `http://localhost:5000`

**Expected output:**
```
 * Running on http://127.0.0.1:5000
 * Running on http://192.168.1.4:5000
```

### 3. Open the Frontend

- Open `course_enrollment_ui.html` in your web browser, or
- Use a local file server: `python -m http.server 8000` and navigate to `http://localhost:8000`

The database (`course_enrollment.db`) will be automatically created on first run.

## Usage

### Select a Student
1. Use the student dropdown in the top navigation bar
2. Choose from: Alice Johnson, Bob Miller, Carol White, David Taylor, Emma Brown

### Browse Courses
1. Go to the **Catalog** tab
2. Search, filter by level, or filter by enrollment status
3. Click **"Enroll Now"** to register for a course

### View Your Learning
1. Go to the **My Learning** tab
2. Select a course from the left panel
3. Choose a lesson from the sidebar
4. Mark lessons as complete by clicking "Mark as complete"

## API Endpoints

### Health Check
```
GET /health
Response: {"status": "ok", "message": "API is running"}
```

### Students
```
GET /students
Response: {"success": true, "students": [...], "count": N}
```

### Courses
```
GET /courses
Response: {"success": true, "courses": [...], "count": N}
```

### Course Details
```
GET /courses/<course_id>
Response: {"success": true, "course": {...}}
```

## Sample Data

### Courses (8 available)
1. Introduction to Programming
2. Web Development Fundamentals
3. Database Management Systems
4. Data Structures and Algorithms
5. Mobile App Development
6. Machine Learning Basics
7. Cybersecurity Fundamentals
8. Cloud Computing with AWS

### Students (5 available)
- Alice Johnson (alice.j@student.edu)
- Bob Miller (bob.m@student.edu)
- Carol White (carol.w@student.edu)
- David Taylor (david.t@student.edu)
- Emma Brown (emma.b@student.edu)

### Initial Enrollments
- Alice: Introduction to Programming, Web Development Fundamentals
- Bob: Introduction to Programming, Database Management Systems
- Carol: Web Development Fundamentals, Data Structures and Algorithms
- David: Introduction to Programming
- Emma: Machine Learning Basics

## Database Schema

### Tables

**students**
- `id` (INTEGER PRIMARY KEY)
- `first_name`, `last_name` (VARCHAR)
- `email` (VARCHAR UNIQUE)
- `created_at` (TIMESTAMP)

**courses**
- `id` (INTEGER PRIMARY KEY)
- `title` (VARCHAR)
- `description` (TEXT)
- `created_at` (TIMESTAMP)

**enrollments**
- `id` (INTEGER PRIMARY KEY)
- `student_id` (FOREIGN KEY)
- `course_id` (FOREIGN KEY)
- `enrolled_at` (TIMESTAMP)
- Unique constraint on (student_id, course_id)

## Configuration

Edit the following in `backend_api.py` or `course_enrollment_ui.html` to customize:

- **API_BASE_URL**: Change from `http://localhost:5000` to match your backend
- **USE_API**: In HTML, set to `true` to use API, `false` for offline mode
- **DB_FILE**: Default is `course_enrollment.db` in the current directory

## Features in Development

Frontend supports advanced features with local data:
- Lesson content and learning paths
- Progress tracking and completion status
- Course material with different lesson types (reading, lab, project)
- Detailed IoT Engineering curriculum

## Troubleshooting

**Port 5000 already in use:**
```bash
# Windows: Find and kill the process
netstat -ano | findstr :5000
taskkill /PID <PID> /F
```

**CORS errors in browser:**
Ensure Flask-CORS is installed and the backend is running

**Database not initializing:**
Delete `course_enrollment.db` and restart the backend to recreate it

## Development Mode

The Flask backend runs in debug mode by default:
- Auto-reloads on file changes
- Provides detailed error messages
- Enables Flask debugger

⚠️ **Do not use debug mode in production**

## Future Enhancements

- User authentication & authorization
- Progress persistence to database
- Lesson content from database
- Enrollment history & analytics
- Email notifications
- Admin dashboard for course management



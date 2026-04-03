# Course Enrollment System

A web-based course enrollment management system built with Flask backend and HTML/CSS/JavaScript frontend. Students can enroll in and unenroll from courses with a modern, interactive user interface.

## Features

- ✓ **Student Management** - View all enrolled students with their enrollment counts
- ✓ **Course Catalog** - Browse all available courses with descriptions
- ✓ **Enrollment Management** - Enroll and unenroll students from courses
- ✓ **Real-time Updates** - Live enrollment count updates
- ✓ **Responsive Design** - Beautiful modern UI with gradient theme
- ✓ **REST API** - Full-featured backend API with error handling
- ✓ **Database** - SQLite database with sample data included
- ✓ **CORS Support** - Cross-origin requests enabled for API

## Project Structure

```
Course enrollment/
├── src/
│   ├── main.js              # Main JavaScript application logic
│   ├── style.css            # Global styles
│   └── index.html           # (internal) HTML template for Vite
├── dist/                    # Production build output (created by npm run build)
├── backend_api.py           # Flask backend API server
├── course_enrollment_ui.html # Static HTML version (legacy)
├── database_schema.sql      # Database schema (reference)
├── course_enrollment.db     # SQLite database (auto-created)
├── package.json             # Node.js configuration
├── vite.config.js           # Vite configuration
├── index.html               # Root HTML entry point for Vite
├── .env                     # Environment variables
├── .gitignore               # Git ignore rules
└── README.md                # This file
```

## Prerequisites

- Python 3.7 or higher
- pip (Python package manager)
- Web browser (Chrome, Firefox, Safari, Edge, etc.)

## Installation & Setup

### Step 1: Install Python Dependencies

Open PowerShell/Command Prompt and run:

```bash
cd "c:\Users\kalpe\OneDrive\Desktop\Course enrollment"
python -m pip install flask flask-cors requests
```

**Packages installed:**
- `flask` - Web framework for the backend API
- `flask-cors` - Enable cross-origin requests
- `requests` - HTTP client library (optional, for testing)

### Step 2: Install Node.js Dependencies

Install Node.js dependencies for Vite:

```bash
cd "c:\Users\kalpe\OneDrive\Desktop\Course enrollment"
npm install
```

**This installs:**
- `vite` - Modern frontend build tool with HMR (Hot Module Replacement)

### Step 3: Verify Installation

```bash
python -c "import flask; print(f'Flask {flask.__version__} installed successfully')"
npm --version
node --version
```

## Running the Application

### Option 1: Run with Vite (Development - Recommended)

**Terminal 1 - Start Backend API:**
```bash
cd "c:\Users\kalpe\OneDrive\Desktop\Course enrollment"
python backend_api.py
```

Expected output:
```
 * Serving Flask app 'backend_api'
 * Debug mode: on
 * Running on http://127.0.0.1:5000
```

**Terminal 2 - Start Vite Dev Server:**
```bash
cd "c:\Users\kalpe\OneDrive\Desktop\Course enrollment"
npm run dev
```

Expected output:
```
VITE v5.4.21  ready in 699 ms
➜  Local:   http://localhost:5173/
```

The browser will automatically open with HMR (Hot Module Replacement) enabled. Any changes you make to the code will instantly reflect in the browser.

### Option 2: Build for Production

**Build the frontend:**
```bash
cd "c:\Users\kalpe\OneDrive\Desktop\Course enrollment"
npm run build
```

This creates an optimized `dist/` folder.

**Serve production build:**
```bash
npm run preview
```

Or use Python's HTTP server:
```bash
python -m http.server 8000
```

### Option 3: Run Both Servers (Legacy - Static Files)

**Terminal 1 - Start Backend API:**
```bash
cd "c:\Users\kalpe\OneDrive\Desktop\Course enrollment"
python backend_api.py
```

Expected output:
```
 * Serving Flask app 'backend_api'
 * Debug mode: on
 * Running on http://127.0.0.1:5000
```

**Terminal 2 - Start Frontend Web Server:**
```bash
cd "c:\Users\kalpe\OneDrive\Desktop\Course enrollment"
python -m http.server 8000
```

Expected output:
```
Serving HTTP on :: port 8000 (http://[::]:8000/) ...
```

### Step 3: Access the Application

For **Vite development**: http://localhost:5173/
For **Production build**: http://localhost:8000/
For **Static files**: http://localhost:8000/course_enrollment_ui.html

## Using the Application

### View Courses
1. The main page displays all 8 available courses
2. Each course shows the title, description, and number of enrolled students
3. Click "View Details" to see more information about a course

### View Students
1. Switch to the "Students" tab to see all registered students
2. Each student shows their name, email, and total number of enrollments
3. View individual student enrollments by clicking on a student

### Enroll a Student
1. Select a student from the dropdown
2. Select a course from the available courses list
3. Click "Enroll" button
4. Success message will appear with confirmation

### Unenroll a Student
1. View student enrollments in the "Students" section
2. Click "Unenroll" next to the course
3. Confirmation message will appear

## API Endpoints

All requests should be made to `http://127.0.0.1:5000`

### Health Check
```
GET /health
Response: {"status": "ok", "message": "API is running"}
```

### Students
```
GET /students
Response: {
  "success": true,
  "count": 5,
  "students": [
    {
      "id": 1,
      "first_name": "Alice",
      "last_name": "Johnson",
      "email": "alice.j@student.edu",
      "enrolled_courses": 2
    }
  ]
}
```

### Courses
```
GET /courses
Response: {
  "success": true,
  "count": 8,
  "courses": [
    {
      "id": 1,
      "title": "Introduction to Programming",
      "description": "Learn Python...",
      "created_at": "2026-04-03 16:47:10",
      "enrolled_students": 3
    }
  ]
}
```

### Get Single Course
```
GET /courses/<course_id>
Example: GET /courses/1
```

### Student Enrollments
```
GET /enrollments/<student_id>
Example: GET /enrollments/1
Response: {
  "success": true,
  "count": 2,
  "enrollments": [
    {
      "enrollment_id": 1,
      "enrolled_at": "2026-04-03 16:47:10",
      "course_id": 1,
      "title": "Introduction to Programming",
      "description": "..."
    }
  ]
}
```

### Enroll Student
```
POST /enroll
Body: {
  "student_id": 1,
  "course_id": 2
}
Response: {
  "success": true,
  "message": "Alice Johnson enrolled in Web Development Fundamentals",
  "enrollment_id": 10,
  "student": {"id": 1, "first_name": "Alice", "last_name": "Johnson"},
  "course": {"id": 2, "title": "Web Development Fundamentals"}
}
```

### Unenroll Student
```
DELETE /unenroll
Body: {
  "student_id": 1,
  "course_id": 2
}
Response: {
  "success": true,
  "message": "Successfully unenrolled"
}
```

## Sample Data

### Students (5 total)
1. Alice Johnson - alice.j@student.edu
2. Bob Miller - bob.m@student.edu
3. Carol White - carol.w@student.edu
4. David Taylor - david.t@student.edu
5. Emma Brown - emma.b@student.edu

### Courses (8 total)
1. Introduction to Programming
2. Web Development Fundamentals
3. Database Management Systems
4. Data Structures and Algorithms
5. Mobile App Development
6. Machine Learning Basics
7. Cybersecurity Fundamentals
8. Cloud Computing with AWS

### Initial Enrollments
- Alice: Courses 1 & 2
- Bob: Courses 1 & 3
- Carol: Courses 2 & 4
- David: Course 1
- Emma: Course 5

## Available npm Scripts

Run these commands from the project root directory:

```bash
# Start Vite development server with HMR (Hot Module Replacement)
npm run dev

# Build for production (creates optimized dist/ folder)
npm run build

# Preview production build locally
npm run preview

# Start production preview server on port 8000
npm run serve
```

## Development Workflow

1. **Start Backend API:**
   ```bash
   python backend_api.py
   ```

2. **Start Vite Dev Server:**
   ```bash
   npm run dev
   ```

3. **Open Browser:**
   - Visit `http://localhost:5173/`

4. **Make Changes:**
   - Edit files in `src/` directory
   - Changes are automatically reflected (HMR)
   - No page refresh needed!

5. **Check Backend Logs:**
   - Monitor Flask terminal for API requests
   - Check browser console for frontend errors

## Production Deployment

1. **Build the project:**
   ```bash
   npm run build
   ```

2. **Upload dist/ to server:**
   - Deploy to your web hosting
   - Ensure backend API is accessible from frontend

3. **Configure API URL:**
   - Update `.env` with production API URL
   - Or hardcode in `src/main.js`

## Database

The application uses **SQLite** for data persistence. The database file `course_enrollment.db` is automatically created when you first run `backend_api.py`.

### Reset Database
To reset the database and start fresh, delete the `course_enrollment.db` file:
```bash
del course_enrollment.db
```

Then restart the backend API to recreate it with sample data.

## Troubleshooting

### Issue: "Address already in use"
If port 5000, 5173, or 8000 is already in use, you can:
1. Change the port in the respective configuration files
2. Kill existing processes using the port

**To find and kill Python processes:**
```bash
Get-Process python | Stop-Process -Force
```

**To find and kill Node processes:**
```bash
Get-Process node | Stop-Process -Force
```

### Issue: "ENOENT: no such file or directory" during npm install
Try clearing cache and reinstalling:
```bash
npm cache clean --force
rm node_modules
rm package-lock.json
npm install
```

### Issue: "Connection refused" or "Cannot GET /"
Ensure both servers are running:
- Backend API on port 5000
- Vite dev server on port 5173 (or Python HTTP server on 8000)

### Issue: CORS errors in console
This means the frontend can't communicate with the backend. Make sure:
1. Backend API is running on `http://127.0.0.1:5000`
2. Frontend is accessing via correct URL (5173 for Vite, 8000 for production)
3. Flask-CORS is installed

### Issue: Vite not compiling changes
Try hard refresh: `Ctrl+Shift+R` (Windows/Linux) or `Cmd+Shift+R` (Mac)

## Technology Stack

- **Frontend:** HTML5, CSS3, JavaScript (Vanilla)
- **Build Tool:** Vite 5
- **Backend:** Python Flask
- **Database:** SQLite3
- **Runtime:** Node.js (for frontend tooling)
- **Styling:** Modern CSS with gradients and animations
- **API:** RESTful architecture with CORS

## Vite Configuration

The `vite.config.js` includes:
- **Dev Server:** Port 5173 with HMR enabled
- **Proxy:** API requests to `/api/*` are proxied to `http://localhost:5000`
- **Build:** Optimized production build with minification
- **Preview:** Production preview server on port 8000

## Performance Notes

- Handles up to 1000+ students and courses without issues
- SQLite suitable for development and small deployments
- For production, consider PostgreSQL or MySQL
- No authentication/authorization currently implemented

## Future Enhancements

- User authentication and authorization
- Email notifications for enrollments
- Course prerequisites and scheduling
- Grade management
- Payment/billing integration
- Admin dashboard
- Mobile app version

## License

This project is open source and available for educational use.

## Support

For issues or questions:
1. Check the Troubleshooting section above
2. Review the API endpoints documentation
3. Check browser console for error messages
4. Verify all services are running

---

**Last Updated:** April 3, 2026
**Version:** 1.0.0

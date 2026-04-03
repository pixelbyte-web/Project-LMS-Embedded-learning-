from flask import Flask, request, jsonify
from flask_cors import CORS
import sqlite3
import os
from datetime import datetime

app = Flask(__name__)
CORS(app)

# ── Database config ──────────────────────────────────────────────────────────
DB_FILE = "course_enrollment.db"

def init_db():
    """Initialize SQLite database with schema."""
    if os.path.exists(DB_FILE):
        return
    
    conn = sqlite3.connect(DB_FILE)
    cur = conn.cursor()
    
    # Create tables
    cur.execute("""
        CREATE TABLE courses (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title VARCHAR(200) NOT NULL,
            description TEXT,
            created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
        )
    """)
    
    cur.execute("""
        CREATE TABLE students (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            first_name VARCHAR(50) NOT NULL,
            last_name VARCHAR(50) NOT NULL,
            email VARCHAR(100) UNIQUE NOT NULL,
            created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
        )
    """)
    
    cur.execute("""
        CREATE TABLE enrollments (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            student_id INTEGER NOT NULL,
            course_id INTEGER NOT NULL,
            enrolled_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
            FOREIGN KEY (student_id) REFERENCES students(id) ON DELETE CASCADE,
            FOREIGN KEY (course_id) REFERENCES courses(id) ON DELETE CASCADE,
            UNIQUE(student_id, course_id)
        )
    """)
    
    # Insert sample data
    courses = [
        ('Introduction to Programming', 'Learn the fundamentals of programming using Python. Perfect for beginners with no prior coding experience.'),
        ('Web Development Fundamentals', 'Build modern websites using HTML, CSS, and JavaScript. Create responsive and interactive web applications.'),
        ('Database Management Systems', 'Master SQL and database design principles. Learn to create efficient and scalable database solutions.'),
        ('Data Structures and Algorithms', 'Deep dive into essential data structures and algorithms used in software development.'),
        ('Mobile App Development', 'Create native mobile applications for iOS and Android platforms using modern frameworks.'),
        ('Machine Learning Basics', 'Introduction to machine learning concepts, algorithms, and practical applications using Python.'),
        ('Cybersecurity Fundamentals', 'Learn essential security principles, threat detection, and protection strategies for modern systems.'),
        ('Cloud Computing with AWS', 'Master cloud infrastructure, deployment, and management using Amazon Web Services.'),
    ]
    cur.executemany('INSERT INTO courses (title, description) VALUES (?, ?)', courses)
    
    students = [
        ('Alice', 'Johnson', 'alice.j@student.edu'),
        ('Bob', 'Miller', 'bob.m@student.edu'),
        ('Carol', 'White', 'carol.w@student.edu'),
        ('David', 'Taylor', 'david.t@student.edu'),
        ('Emma', 'Brown', 'emma.b@student.edu'),
    ]
    cur.executemany('INSERT INTO students (first_name, last_name, email) VALUES (?, ?, ?)', students)
    
    enrollments = [(1, 1), (1, 2), (2, 1), (2, 3), (3, 2), (3, 4), (4, 1), (5, 5)]
    cur.executemany('INSERT INTO enrollments (student_id, course_id) VALUES (?, ?)', enrollments)
    
    conn.commit()
    conn.close()

def get_db():
    """Open and return a SQLite connection."""
    try:
        conn = sqlite3.connect(DB_FILE)
        conn.row_factory = sqlite3.Row
        return conn
    except Exception as e:
        print(f"[DB] Connection error: {e}")
        return None

# Initialize database on startup
init_db()


# ── Health ───────────────────────────────────────────────────────────────────
@app.route("/health")
def health():
    return jsonify({"status": "ok", "message": "API is running"}), 200


# ── Students ─────────────────────────────────────────────────────────────────
@app.route("/students")
def get_students():
    conn = get_db()
    if not conn:
        return jsonify({"error": "Database connection failed"}), 500

    cur = conn.cursor()
    cur.execute("""
        SELECT s.id, s.first_name, s.last_name, s.email,
               COUNT(e.id) AS enrolled_courses
        FROM students s
        LEFT JOIN enrollments e ON s.id = e.student_id
        GROUP BY s.id
        ORDER BY s.last_name, s.first_name
    """)
    rows = cur.fetchall()
    students = [dict(row) for row in rows]
    cur.close(); conn.close()
    return jsonify({"success": True, "students": students, "count": len(students)}), 200


# ── Courses ──────────────────────────────────────────────────────────────────
@app.route("/courses")
def get_courses():
    conn = get_db()
    if not conn:
        return jsonify({"error": "Database connection failed"}), 500

    cur = conn.cursor()
    cur.execute("""
        SELECT c.id, c.title, c.description, c.created_at,
               COUNT(e.id) AS enrolled_students
        FROM courses c
        LEFT JOIN enrollments e ON c.id = e.course_id
        GROUP BY c.id
        ORDER BY c.created_at DESC
    """)
    rows = cur.fetchall()
    courses = [dict(row) for row in rows]
    cur.close(); conn.close()
    return jsonify({"success": True, "courses": courses, "count": len(courses)}), 200


@app.route("/courses/<int:course_id>")
def get_course(course_id):
    conn = get_db()
    if not conn:
        return jsonify({"error": "Database connection failed"}), 500

    cur = conn.cursor()
    cur.execute("""
        SELECT c.id, c.title, c.description, c.created_at,
               COUNT(e.id) AS enrolled_students
        FROM courses c
        LEFT JOIN enrollments e ON c.id = e.course_id
        WHERE c.id = ?
        GROUP BY c.id
    """, (course_id,))
    row = cur.fetchone()
    cur.close(); conn.close()

    if not row:
        return jsonify({"error": "Course not found"}), 404
    course = dict(row)
    return jsonify({"success": True, "course": course}), 200


# ── Enrollments ───────────────────────────────────────────────────────────────
@app.route("/enrollments/<int:student_id>")
def get_enrollments(student_id):
    conn = get_db()
    if not conn:
        return jsonify({"error": "Database connection failed"}), 500

    cur = conn.cursor()
    cur.execute("""
        SELECT e.id AS enrollment_id, e.enrolled_at,
               c.id AS course_id, c.title, c.description
        FROM enrollments e
        JOIN courses c ON e.course_id = c.id
        WHERE e.student_id = ?
        ORDER BY e.enrolled_at DESC
    """, (student_id,))
    rows = cur.fetchall()
    enrollments = [dict(row) for row in rows]
    cur.close(); conn.close()
    return jsonify({"success": True, "enrollments": enrollments, "count": len(enrollments)}), 200


@app.route("/enroll", methods=["POST"])
def enroll():
    data = request.get_json()
    if not data:
        return jsonify({"error": "No JSON body provided"}), 400

    student_id = data.get("student_id")
    course_id  = data.get("course_id")
    if not student_id or not course_id:
        return jsonify({"error": "student_id and course_id are required"}), 400

    conn = get_db()
    if not conn:
        return jsonify({"error": "Database connection failed"}), 500

    cur = conn.cursor()

    # Verify student
    cur.execute("SELECT id, first_name, last_name FROM students WHERE id = ?", (student_id,))
    student_row = cur.fetchone()
    if not student_row:
        cur.close(); conn.close()
        return jsonify({"error": "Student not found"}), 404
    student = dict(student_row)

    # Verify course
    cur.execute("SELECT id, title FROM courses WHERE id = ?", (course_id,))
    course_row = cur.fetchone()
    if not course_row:
        cur.close(); conn.close()
        return jsonify({"error": "Course not found"}), 404
    course = dict(course_row)

    # Check duplicate
    cur.execute("SELECT id FROM enrollments WHERE student_id=? AND course_id=?", (student_id, course_id))
    if cur.fetchone():
        cur.close(); conn.close()
        return jsonify({"error": "Student is already enrolled in this course"}), 409

    # Insert
    cur.execute("INSERT INTO enrollments (student_id, course_id) VALUES (?, ?)", (student_id, course_id))
    conn.commit()
    enrollment_id = cur.lastrowid
    cur.close(); conn.close()

    return jsonify({
        "success": True,
        "message": f"{student['first_name']} {student['last_name']} enrolled in {course['title']}",
        "enrollment_id": enrollment_id,
        "student": student,
        "course": course,
    }), 201


@app.route("/unenroll", methods=["DELETE"])
def unenroll():
    data = request.get_json()
    if not data:
        return jsonify({"error": "No JSON body provided"}), 400

    student_id = data.get("student_id")
    course_id  = data.get("course_id")
    if not student_id or not course_id:
        return jsonify({"error": "student_id and course_id are required"}), 400

    conn = get_db()
    if not conn:
        return jsonify({"error": "Database connection failed"}), 500

    cur = conn.cursor()
    cur.execute("DELETE FROM enrollments WHERE student_id=? AND course_id=?", (student_id, course_id))
    conn.commit()
    affected = cur.rowcount
    cur.close(); conn.close()

    if affected == 0:
        return jsonify({"error": "Enrollment not found"}), 404
    return jsonify({"success": True, "message": "Successfully unenrolled"}), 200


# ── Run ───────────────────────────────────────────────────────────────────────
if __name__ == "__main__":
    app.run(debug=True, host="0.0.0.0", port=5000)

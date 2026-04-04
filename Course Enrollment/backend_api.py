from flask import Flask, request, jsonify
from flask_cors import CORS
import mysql.connector
from mysql.connector import Error

app = Flask(__name__)
CORS(app)

DB_CONFIG = {
    "host": "localhost",
    "user": "root",
    "password": "your_password",   
    "database": "course_enrollment_system",
}


def get_db():
    try:
        return mysql.connector.connect(**DB_CONFIG)
    except Error as e:
        print(f"[DB] Connection error: {e}")
        return None


# Health 
@app.route("/health")
def health():
    return jsonify({"status": "ok"}), 200


# Students 
@app.route("/students")
def get_students():
    conn = get_db()
    if not conn:
        return jsonify({"error": "Database connection failed"}), 500
    cur = conn.cursor(dictionary=True)
    cur.execute("""
        SELECT s.id, s.first_name, s.last_name, s.email,
               COUNT(e.id) AS enrolled_courses
        FROM students s
        LEFT JOIN enrollments e ON s.id = e.student_id
        GROUP BY s.id ORDER BY s.last_name, s.first_name
    """)
    rows = cur.fetchall()
    cur.close(); conn.close()
    return jsonify({"success": True, "students": rows, "count": len(rows)}), 200


# Courses 
@app.route("/courses")
def get_courses():
    conn = get_db()
    if not conn:
        return jsonify({"error": "Database connection failed"}), 500
    cur = conn.cursor(dictionary=True)
    cur.execute("""
        SELECT c.id, c.title, c.description, c.category, c.level, c.duration_hours,
               DATE_FORMAT(c.created_at, '%Y-%m-%dT%H:%i:%s') AS created_at,
               COUNT(DISTINCT e.id) AS enrolled_students,
               COUNT(DISTINCT cc.id) AS total_lessons
        FROM courses c
        LEFT JOIN enrollments e ON c.id = e.course_id
        LEFT JOIN course_content cc ON c.id = cc.course_id
        GROUP BY c.id ORDER BY c.id
    """)
    rows = cur.fetchall()
    cur.close(); conn.close()
    return jsonify({"success": True, "courses": rows, "count": len(rows)}), 200


@app.route("/courses/<int:course_id>")
def get_course(course_id):
    conn = get_db()
    if not conn:
        return jsonify({"error": "Database connection failed"}), 500
    cur = conn.cursor(dictionary=True)
    cur.execute("""
        SELECT c.id, c.title, c.description, c.category, c.level, c.duration_hours,
               DATE_FORMAT(c.created_at, '%Y-%m-%dT%H:%i:%s') AS created_at,
               COUNT(DISTINCT e.id) AS enrolled_students,
               COUNT(DISTINCT cc.id) AS total_lessons
        FROM courses c
        LEFT JOIN enrollments e ON c.id = e.course_id
        LEFT JOIN course_content cc ON c.id = cc.course_id
        WHERE c.id = %s GROUP BY c.id
    """, (course_id,))
    row = cur.fetchone()
    cur.close(); conn.close()
    if not row:
        return jsonify({"error": "Course not found"}), 404
    return jsonify({"success": True, "course": row}), 200


@app.route("/courses/<int:course_id>/content")
def get_course_content(course_id):
    """Return all lessons for a course, grouped by section."""
    conn = get_db()
    if not conn:
        return jsonify({"error": "Database connection failed"}), 500
    cur = conn.cursor(dictionary=True)
    cur.execute("""
        SELECT id, section_title, lesson_order, lesson_title, lesson_body, lesson_type
        FROM course_content
        WHERE course_id = %s
        ORDER BY lesson_order
    """, (course_id,))
    lessons = cur.fetchall()
    cur.close(); conn.close()

    # Group by section
    sections = {}
    for lesson in lessons:
        sec = lesson["section_title"]
        if sec not in sections:
            sections[sec] = []
        sections[sec].append(lesson)

    return jsonify({
        "success": True,
        "course_id": course_id,
        "sections": [{"title": k, "lessons": v} for k, v in sections.items()],
        "total_lessons": len(lessons)
    }), 200


# ── Enrollments ───────────────────────────────────────────────────────────────
@app.route("/enrollments/<int:student_id>")
def get_enrollments(student_id):
    conn = get_db()
    if not conn:
        return jsonify({"error": "Database connection failed"}), 500
    cur = conn.cursor(dictionary=True)
    cur.execute("""
        SELECT e.id AS enrollment_id,
               DATE_FORMAT(e.enrolled_at, '%Y-%m-%dT%H:%i:%s') AS enrolled_at,
               c.id AS course_id, c.title, c.description, c.category, c.level,
               c.duration_hours,
               COUNT(DISTINCT cc.id) AS total_lessons,
               COUNT(DISTINCT lp.id) AS completed_lessons
        FROM enrollments e
        JOIN courses c ON e.course_id = c.id
        LEFT JOIN course_content cc ON cc.course_id = c.id
        LEFT JOIN lesson_progress lp ON lp.lesson_id = cc.id
            AND lp.student_id = e.student_id AND lp.completed = TRUE
        WHERE e.student_id = %s
        GROUP BY e.id, c.id
        ORDER BY e.enrolled_at DESC
    """, (student_id,))
    rows = cur.fetchall()
    cur.close(); conn.close()
    return jsonify({"success": True, "enrollments": rows, "count": len(rows)}), 200


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
    cur = conn.cursor(dictionary=True)

    cur.execute("SELECT id, first_name, last_name FROM students WHERE id = %s", (student_id,))
    student = cur.fetchone()
    if not student:
        cur.close(); conn.close()
        return jsonify({"error": "Student not found"}), 404

    cur.execute("SELECT id, title FROM courses WHERE id = %s", (course_id,))
    course = cur.fetchone()
    if not course:
        cur.close(); conn.close()
        return jsonify({"error": "Course not found"}), 404

    cur.execute("SELECT id FROM enrollments WHERE student_id=%s AND course_id=%s", (student_id, course_id))
    if cur.fetchone():
        cur.close(); conn.close()
        return jsonify({"error": "Already enrolled in this course"}), 409

    cur.execute("INSERT INTO enrollments (student_id, course_id) VALUES (%s, %s)", (student_id, course_id))
    conn.commit()
    eid = cur.lastrowid
    cur.close(); conn.close()

    return jsonify({
        "success": True,
        "message": f"{student['first_name']} {student['last_name']} enrolled in {course['title']}",
        "enrollment_id": eid,
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
    cur.execute("DELETE FROM enrollments WHERE student_id=%s AND course_id=%s", (student_id, course_id))
    conn.commit()
    affected = cur.rowcount
    cur.close(); conn.close()

    if affected == 0:
        return jsonify({"error": "Enrollment not found"}), 404
    return jsonify({"success": True, "message": "Successfully unenrolled"}), 200


# ── Progress ──────────────────────────────────────────────────────────────────
@app.route("/progress/<int:student_id>/<int:course_id>")
def get_progress(student_id, course_id):
    """Return completed lesson IDs for a student in a course."""
    conn = get_db()
    if not conn:
        return jsonify({"error": "Database connection failed"}), 500
    cur = conn.cursor(dictionary=True)
    cur.execute("""
        SELECT lesson_id, completed
        FROM lesson_progress
        WHERE student_id = %s AND course_id = %s AND completed = TRUE
    """, (student_id, course_id))
    rows = cur.fetchall()
    cur.close(); conn.close()
    completed_ids = [r["lesson_id"] for r in rows]
    return jsonify({"success": True, "completed_lesson_ids": completed_ids}), 200


@app.route("/progress", methods=["POST"])
def update_progress():
    """Mark a lesson as complete or incomplete."""
    data = request.get_json()
    if not data:
        return jsonify({"error": "No JSON body"}), 400
    student_id = data.get("student_id")
    course_id  = data.get("course_id")
    lesson_id  = data.get("lesson_id")
    completed  = data.get("completed", True)

    if not all([student_id, course_id, lesson_id]):
        return jsonify({"error": "student_id, course_id, lesson_id are required"}), 400

    conn = get_db()
    if not conn:
        return jsonify({"error": "Database connection failed"}), 500
    cur = conn.cursor()

    if completed:
        cur.execute("""
            INSERT INTO lesson_progress (student_id, course_id, lesson_id, completed, completed_at)
            VALUES (%s, %s, %s, TRUE, NOW())
            ON DUPLICATE KEY UPDATE completed=TRUE, completed_at=NOW()
        """, (student_id, course_id, lesson_id))
    else:
        cur.execute("""
            INSERT INTO lesson_progress (student_id, course_id, lesson_id, completed)
            VALUES (%s, %s, %s, FALSE)
            ON DUPLICATE KEY UPDATE completed=FALSE, completed_at=NULL
        """, (student_id, course_id, lesson_id))

    conn.commit()
    cur.close(); conn.close()
    return jsonify({"success": True, "completed": completed}), 200


if __name__ == "__main__":
    app.run(debug=True, host="0.0.0.0", port=5000)

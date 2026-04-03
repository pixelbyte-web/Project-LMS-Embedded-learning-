const API_URL = 'http://localhost:5000/api/auth';

async function runTests() {
    console.log("🚀 Starting LMS Backend Tests...\n");

    const rand = Date.now();
    const studentEmail = `student_${rand}@test.com`;
    const instructorEmail = `instructor_${rand}@test.com`;

    // 1. Student Registration (Should succeed with valid code)
    console.log("▶️  Test 1: Student Registration");
    const res1 = await fetch(`${API_URL}/register/student`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({
            name: "John Student",
            email: studentEmail,
            password: "password123",
            schoolCode: "12345678" // Must match seed.js
        })
    });
    const data1 = await res1.json();
    console.log(`Response Code: ${res1.status}`);
    console.dir(data1);
    console.log(res1.status === 201 ? '🟢 PASS\n' : '🔴 FAIL\n');

    // 2. Instructor Registration
    console.log("▶️  Test 2: Instructor Registration (Pending Approval)");
    const res2 = await fetch(`${API_URL}/register/instructor`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({
            name: "Jane Instructor",
            email: instructorEmail,
            password: "password123",
            schoolCode: "12345678"
        })
    });
    const data2 = await res2.json();
    console.log(`Response Code: ${res2.status}`);
    console.dir(data2);
    console.log((res2.status === 201 && data2.msg.includes('admin approval')) ? '🟢 PASS\n' : '🔴 FAIL\n');

    // 3. Instructor Login (Should FAIL because approved is still false)
    console.log("▶️  Test 3: Instructor Login Attempt (Should Fail - Waiting for Admin)");
    const res3 = await fetch(`${API_URL}/login`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({
            email: instructorEmail,
            password: "password123"
        })
    });
    const data3 = await res3.json();
    console.log(`Response Code: ${res3.status}`);
    console.dir(data3);
    console.log(res3.status === 403 ? '🟢 PASS\n' : '🔴 FAIL\n');

    // 4. Admin Login (Should succeed with seed data)
    console.log("▶️  Test 4: Admin Login");
    const res4 = await fetch(`${API_URL}/login`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({
            email: "admin@lms.com",
            password: "adminpassword123"
        })
    });
    const data4 = await res4.json();
    console.log(`Response Code: ${res4.status}`);
    console.dir(data4);
    console.log(res4.status === 200 ? '🟢 PASS\n' : '🔴 FAIL\n');

    // 5. Admin Logout testing backlist
    console.log("▶️  Test 5: Token Logout & Invalidity");
    const token = data4.token;
    const res5 = await fetch(`${API_URL}/logout`, {
        method: 'POST',
        headers: { 
            'Content-Type': 'application/json',
            'Authorization': `Bearer ${token}` 
        }
    });
    const data5 = await res5.json();
    console.log(`Logout Response Code: ${res5.status}`);
    console.dir(data5);
    
    // Test reusing token (Should get a 401 error since it is blacklisted)
    console.log("-> Attempting to use logged-out token on a protected route...");
    const res6 = await fetch(`${API_URL}/logout`, {
        method: 'POST',
        headers: { 'Authorization': `Bearer ${token}` }
    });
    const data6 = await res6.json();
    console.log(`Secure Route Response Code: ${res6.status}`);
    console.dir(data6);
    console.log(res6.status === 401 ? '🟢 PASS\n' : '🔴 FAIL\n');
}

runTests().catch(console.error);

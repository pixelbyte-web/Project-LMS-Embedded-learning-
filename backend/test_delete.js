const API_URL = 'http://localhost:5000/api/auth';

async function testDelete() {
    const rand = Date.now();
    const email = `test_delete_${rand}@test.com`;

    // 1. Register
    const resReg = await fetch(`${API_URL}/register/student`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({
            name: "Delete Me",
            email: email,
            password: "p",
            schoolCode: "12345678"
        })
    });
    const regData = await resReg.json();
    console.log("Registered:", regData);

    const token = regData.token;

    // 2. Delete
    const resDel = await fetch(`${API_URL}/delete`, {
        method: 'DELETE',
        headers: { 
            'Content-Type': 'application/json',
            'Authorization': `Bearer ${token}` 
        }
    });
    console.log("Delete status:", resDel.status);
    console.log("Delete response:", await resDel.json());
}

testDelete().catch(console.error);

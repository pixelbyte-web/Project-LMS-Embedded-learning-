# Project-LMS-Embedded-learning-

This repository contains the backend code for the Role-Based Learning Management System. It is built using Node.js, Express, and MongoDB.

## Getting Started

Follow these steps to get the server running on your local machine.

### 1. Install Dependencies
Before running the server, you need to install all the required Node packages (Express, Mongoose, etc.).
Run this command in the root folder (`/LMS`):
```bash
npm install
```

### 2. Set Up Environment Variables
Create a `.env` file in the root directory and add the following keys. Ask your team admin for the actual URI/Secrets if you don't have them:
```env
PORT=5000
MONGODB_URI=your_mongodb_connection_string
JWT_SECRET=your_jwt_secret_key
```

### 3. Run the Server
Once dependencies are installed and the `.env` file is ready, you can start the backend server.
```bash
npm start
```
*If everything is correct, you'll see a terminal message saying `Server started on port 5000` and `MongoDB Connected`.*

---

## Additional Commands

**Seed the Database (Optional)**
If you want to quickly populate the database with test data (Admins, Schools, etc.), we have a seed file you can run:
```bash
node seed.js
```

**Running Tests (If Applicable)**
To test the deletion workflow or endpoints (make sure the server is running first):
```bash
node test_delete.js
node test_endpoints.js
```

## Integrating with the Frontend (Vite)
If you are moving the Vite frontend into this same repository:
- Run the frontend in development mode using:
  ```bash
  npm run dev
  ```
- Build the frontend for production using:
  ```bash
  npm run build
  ```
# LMS Backend

### Crucial Commands

- **Install Dependencies:**
  ```bash
  npm install
  ```

- **Run Server (Backend):**
  ```bash
  npm start
  ```

- **Run UI (Frontend):**
  ```bash
  npm run dev
  ```

- **Seed Dummy Data:**
  ```bash
  node seed.js
  ```

### Installed Packages
- `express`: Web server framework
- `mongoose`: MongoDB database connector
- `jsonwebtoken`: Secure login authentication (Tokens)
- `bcryptjs`: Password hashing
- `dotenv`: Manage hidden environment variables
- `cors`: Allow frontend to communicate with backend

### Requirements
You must create a `.env` file with `PORT`, `MONGODB_URI`, and `JWT_SECRET` for the server to run.
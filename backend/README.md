# LMS Backend

### Crucial Commands

- **Install All Dependencies:**
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
If you ever need to rebuild this project manually, here is the command used to install these packages:
```bash
npm install express mongoose jsonwebtoken bcryptjs dotenv cors
```

- `express`: Web server framework
- `mongoose`: MongoDB database connector
- `jsonwebtoken`: Secure login authentication (Tokens)
- `bcryptjs`: Password hashing
- `dotenv`: Manage hidden environment variables
- `cors`: Allow frontend to communicate with backend

### Requirements
You must create a `.env` file with `PORT`, `MONGODB_URI`, and `JWT_SECRET` for the server to run.
# Full-Stack Web Application with React, Node.js, and AWS DynamoDB

This project demonstrates a complete full-stack web application with user authentication, featuring a React frontend, Node.js/Express backend, and AWS DynamoDB for data storage.

## Project Structure

```
/project
├── frontend/          # React.js application
├── backend/           # Node.js/Express server
├── database/          # AWS CLI scripts for DynamoDB
└── README.md         # This file
```

## Features

- User registration and login
- Password hashing with bcrypt
- JWT token-based authentication
- Responsive React UI
- AWS DynamoDB integration
- CORS enabled for cross-origin requests

## Prerequisites

- Node.js (v14 or higher)
- npm or yarn
- AWS CLI installed and configured
- AWS account with appropriate permissions

## Setup Instructions

### 1. Clone and Install Dependencies

```bash
# Install backend dependencies
cd backend
npm install

# Install frontend dependencies
cd ../frontend
npm install
```

### 2. Configure AWS Credentials

#### Option A: Using AWS CLI (Recommended)

```bash
# Configure AWS CLI with your credentials
aws configure

# Enter your:
# AWS Access Key ID
# AWS Secret Access Key
# Default region name (e.g., us-east-1)
# Default output format (json)
```

#### Option B: Manual Configuration

Create a `.env` file in the `backend` directory with your AWS credentials:

```env
AWS_REGION=us-east-1
AWS_ACCESS_KEY_ID=your-access-key-id
AWS_SECRET_ACCESS_KEY=your-secret-access-key
DYNAMODB_TABLE=Users
JWT_SECRET=your-super-secret-jwt-key-change-this-in-production
PORT=5000
```

### 3. Create DynamoDB Table

Run the provided script to create the DynamoDB table:

```bash
# Make the script executable (Linux/Mac)
chmod +x database/create-table.sh

# Run the script
./database/create-table.sh
```

Or run the AWS CLI command directly:

```bash
aws dynamodb create-table \
    --table-name Users \
    --attribute-definitions \
        AttributeName=username,AttributeType=S \
    --key-schema \
        AttributeName=username,AttributeType=HASH \
    --provisioned-throughput \
        ReadCapacityUnits=5,WriteCapacityUnits=5 \
    --region us-east-1
```

### 4. Run the Application

#### Start the Backend Server

```bash
cd backend
npm start
```

The server will start on `http://localhost:5000`

#### Start the Frontend

```bash
cd frontend
npm start
```

The React app will open in your browser at `http://localhost:3000`

## API Endpoints

### POST /register
Register a new user.

**Request Body:**
```json
{
  "username": "johndoe",
  "email": "john@example.com",
  "password": "securepassword"
}
```

**Response:**
```json
{
  "message": "User registered successfully",
  "token": "jwt-token-here",
  "user": {
    "id": "user-id",
    "username": "johndoe",
    "email": "john@example.com"
  }
}
```

### POST /login
Authenticate a user.

**Request Body:**
```json
{
  "username": "johndoe",
  "password": "securepassword"
}
```

**Response:**
```json
{
  "message": "Login successful",
  "token": "jwt-token-here",
  "user": {
    "id": "user-id",
    "username": "johndoe",
    "email": "john@example.com"
  }
}
```

## AWS Deployment

### Deploy Backend to EC2

1. **Create a Security Group** (allows inbound traffic):
   ```bash
   aws ec2 create-security-group --group-name my-app-sg --description "Security group for web app"
   ```
   Note the security group ID from the output (e.g., sg-12345678).

2. **Add inbound rules to allow HTTP, SSH, and app port**:
   ```bash
   aws ec2 authorize-security-group-ingress --group-id sg-12345678 --protocol tcp --port 22 --cidr 0.0.0.0/0
   aws ec2 authorize-security-group-ingress --group-id sg-12345678 --protocol tcp --port 80 --cidr 0.0.0.0/0
   aws ec2 authorize-security-group-ingress --group-id sg-12345678 --protocol tcp --port 5000 --cidr 0.0.0.0/0
   ```

3. **Launch an EC2 Instance:**
   ```bash
   aws ec2 run-instances \
       --image-id ami-0abcdef1234567890 \
       --count 1 \
       --instance-type t2.micro \
       --key-name your-key-pair \
       --security-group-ids sg-12345678 \
       --region us-east-1
   ```

4. **Connect to your EC2 instance** (run this command on your local machine from the directory where your key pair file is located):
   ```bash
   ssh -i your-key-pair.pem ec2-user@your-instance-public-ip
   ```
   **Important Notes:**
   - Replace `your-instance-public-ip` with the actual public IP address of your EC2 instance (you can find this in the AWS EC2 console under "Public IPv4 address")
   - Make sure you're running this command from the directory where `your-key-pair.pem` file is located
   - If you get "Permission denied (publickey)", ensure the key file permissions are correct (on Windows, you may need to adjust permissions)
   - **Username depends on AMI:** `ec2-user` for Amazon Linux 2, `ubuntu` for Ubuntu, `centos` for CentOS, `admin` for Debian
   - If using Windows Command Prompt/PowerShell, you might need to use the full path to the key file

5. **Install Node.js on EC2:**
   ```bash
   # Install nvm (Node Version Manager)
   curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash

   # Load nvm into current shell session (required after installation)
   source ~/.bashrc

   # If nvm still not found, try loading the nvm script directly
   export NVM_DIR="$HOME/.nvm"
   [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
   [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

   # Install the latest LTS version of Node.js
   nvm install --lts

   # Set the default Node.js version
   nvm use --lts

   # Verify installation
   node --version
   npm --version

   # Optional: Add nvm to your shell profile for future sessions
   echo 'export NVM_DIR="$HOME/.nvm"' >> ~/.bashrc
   echo '[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"' >> ~/.bashrc
   echo '[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"' >> ~/.bashrc
   ```

6. **Clone your repository and install dependencies** (run these commands on your EC2 instance):
   ```bash
   # Install git (if not already installed)
   sudo yum update -y
   sudo yum install -y git

   # Clone your project repository (for private repositories, use SSH or personal access token)
   # Option A: Using SSH (recommended for private repos)
   git clone git@github.com:naveen18004/Cloud-Project.git

   # Option B: Using HTTPS with personal access token
   # Create a personal access token at: https://github.com/settings/tokens
   # Then use it as your password when prompted
   git clone https://github.com/naveen18004/Cloud-Project.git

   # If you get permission denied for SSH, set up SSH keys:
   # ssh-keygen -t rsa -b 4096 -C "your-email@example.com"
   # cat ~/.ssh/id_rsa.pub  # Add this to GitHub: https://github.com/settings/keys
   # Then retry: git clone git@github.com:naveen18004/Cloud-Project.git

   # Navigate to the backend directory
   cd Cloud-Project/backend

   # Install backend dependencies
   npm install
   ```

7. **Configure environment variables on EC2:**
   Create a `.env` file with your production values.

8. **Start the server:**
   ```bash
   npm start
   ```

### Deploy Frontend to Amplify

1. **Install Amplify CLI:**
   ```bash
   npm install -g @aws-amplify/cli
   ```

2. **Initialize Amplify:**
   ```bash
   cd frontend
   amplify init
   ```

3. **Add hosting:**
   ```bash
   amplify add hosting
   amplify publish
   ```

## Testing the Application

1. Open the React app in your browser
2. Click "Need to register?" to switch to registration form
3. Fill in the registration details and submit
4. Switch back to login and authenticate with your credentials
5. Upon successful login, you'll receive a JWT token

## Security Notes

- Change the JWT secret in production
- Use HTTPS in production
- Implement rate limiting for API endpoints
- Validate and sanitize all user inputs
- Use environment variables for all sensitive data

## Troubleshooting

### Common Issues:

1. **AWS Credentials Error:**
   - Ensure AWS CLI is configured correctly
   - Check IAM permissions for DynamoDB access

2. **DynamoDB Table Creation Fails:**
   - Verify AWS region matches in all configurations
   - Check if table name already exists

3. **CORS Errors:**
   - Ensure backend allows requests from frontend origin
   - Check if backend server is running on correct port

4. **JWT Token Issues:**
   - Verify JWT_SECRET is set correctly
   - Check token expiration time

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

## License

This project is licensed under the MIT License.

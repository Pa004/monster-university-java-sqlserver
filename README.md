# 🎓 Monster University Management System
### Java + SQL Server | NetBeans Project

---

## 📖 About the Project

The **Monster University Management System** is a comprehensive academic management platform designed to automate various processes and activities within a university environment.

This system was developed as a software engineering project focused on implementing academic processes, security mechanisms, business rules, and database management using **Java** and **Microsoft SQL Server**.

The platform supports multiple user roles and provides secure access to academic administration, reporting and auditing.

---

## 🚀 Technology Stack

| Component | Technology |
|------------|------------|
| Programming Language | Java |
| IDE | NetBeans |
| Database | Microsoft SQL Server |
| Database Connectivity | JDBC |
| Build Tool | Apache Ant |
| Architecture | Layered Architecture (Presentation, Business, Data Access) |

---

## 🏛️ System Architecture

The application follows a layered architecture that promotes maintainability, scalability, and separation of concerns.

```text
+------------------------------------------------+
|               Presentation Layer               |
|          Forms, Views and User Interface       |
+-------------------------+----------------------+
                          |
                          ▼
+------------------------------------------------+
|              Business Logic Layer              |
|      Validations, Rules and System Services    |
+-------------------------+----------------------+
                          |
                          ▼
+------------------------------------------------+
|                Data Access Layer               |
|         DAO Classes and SQL Operations         |
+-------------------------+----------------------+
                          |
                          ▼
+------------------------------------------------+
|              SQL Server Database               |
+------------------------------------------------+
```

---

## 👥 User Roles

### 🎓 Student
- View available courses
- Perform pre-enrollment
- Complete enrollment process
- View schedules
- Check payment status
- Review academic information

### 👨‍🏫 Instructor
- View assigned courses
- Access enrolled student lists
- Review teaching schedules

### 🏢 Academic Secretary
- Manage academic periods
- Generate academic reports
- Handle special enrollment situations

### ⚙️ Enrollment Administrator
- Manage courses and sections
- Configure enrollment periods
- Manage capacity limits
- Control waitlists

### 🤖 System
- Processes waitlists automatically
- Generates audit records
- Executes background validations

---

## 📚 Academic Management Features

### Academic Structure
- Student management
- Academic programs (Careers)
- Courses (Subjects)
- Course prerequisites
- Academic periods

### Enrollment Management
- Pre-enrollment process
- Course enrollment

### Validation Rules
- Prerequisite verification
- Enrollment period validation
- Payment status validation

---

## 🔄 Enrollment Workflow

```text
Student Login
      │
      ▼
Course Selection
      │
      ▼
System Validation
      │
      ├── Prerequisites
      ├── Payment Status
      │
      ▼
Enrollment Decision
      │
      ├── Approved → Enrollment Confirmed
      └── Rejected → Validation Message
```


---

## 🔐 Security Module

The system implements a centralized authentication and authorization model.

### Authentication Features

- Unique user identification
- Secure login process
- Role-based authorization
- User state management
  
### Password Management

- Automatic password generation
- Password reset functionality
- Forced password change on first login
- Forced password change after reset

### Password Policy

- Minimum 8 characters
- Maximum 16 characters
- At least one special character
- Cannot match user identifier
- Prevents reuse of previous passwords

---

## 📊 Reporting Module

The system generates multiple academic and administrative reports.

### Available Reports

- Student lists by course
- Student schedules
- Enrollment history

---

## 📝 Audit Module

All critical operations are recorded for accountability and traceability.

### Audited Events

- User creation
- Password reset operations
- Successful authentications
- Administrative actions

---

## 🗄️ Database Model

The system uses a relational database model implemented in Microsoft SQL Server.

### Database Characteristics

- Referential integrity through foreign keys
- Data consistency constraints
- Normalized relational structure
- Efficient query processing

---

## ⚙️ Installation

### 1. Clone the Repository

```bash
git clone https://github.com/Pa004/monster-university-java-sqlserver
cd monster-university-java-sqlserver
```

### 2. Create the Database

```sql
CREATE DATABASE MonsterUniversity;
```

### 3. Import Database Scripts

Execute the SQL scripts provided with the project.

### 4. Configure Database Connection

Update the database connection settings according to your SQL Server instance.

Example:

```java
String url = "jdbc:sqlserver://localhost:1433;databaseName=MonsterUniversity";
String user = "sa";
String password = "your_password";
```

### 5. Open the Project

Open the project using NetBeans.

### 6. Build the Project

```bash
ant clean
ant build
```

Or use:

```text
NetBeans → Clean and Build Project
```

### 7. Run the Application

```text
NetBeans → Run Project
```

---

## 📂 Project Structure

```text
monster-university-java-sqlserver
│
├── src/                 Source code
├── test/                Unit tests
├── web/                 Web resources
├── libraries/           External libraries
├── nbproject/           NetBeans configuration
├── db/                  SQL scripts
├── build.xml            Apache Ant build script
├── .gitignore           Git exclusions
├── README.md            Project documentation
│
├── build/               Generated files (ignored)
└── dist/                Distribution files (ignored)
```

---

## 🎯 Functional Requirements Implemented

✔ User Management

✔ Authentication and Authorization

✔ Academic Program Management

✔ Enrollment Processing

✔ Prerequisite Validation

✔ Academic Reporting

---

## 📈 Non-Functional Requirements

✔ Modular Design

✔ Layered Architecture

✔ Database Persistence

✔ Secure Authentication

✔ Scalability-Oriented Structure

✔ Maintainable Codebase

---

## 🔄 Related Versions

This repository represents the **Java + SQL Server** implementation of the Monster University Enrollment System.

Other available implementations include:

- C# + SQL Server
- Java + MongoDB
- C# + MongoDB

All versions share the same business rules and functional requirements while differing in programming language and database technology.

---

## 🎓 Academic Purpose

This project was developed for educational and academic purposes, demonstrating the implementation of:

- Database Management Systems
- Software Architecture
- Authentication and Authorization
- Academic Information Systems
- Object-Oriented Programming
- Business Rule Enforcement
- Software Engineering Principles

---

## 👨‍💻 Author

**Monster University Enrollment Management System**  
Java + SQL Server Implementation
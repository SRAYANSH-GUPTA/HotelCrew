# Hotelcrew

Hotelcrew is an all-in-one hotel staff management application designed to simplify hotel operations. From hotel registration to staff management and analytics, the app provides powerful tools for admins, managers, receptionists, and staff to handle their tasks efficiently.

---

## Features

### Admin
- **Hotel Management**:
  - Register hotels.
  - View and update hotel details.
  - Analyze hotel performance through financial and operational metrics.
- **Staff Management**:
  - Import staff details via an Excel file (name, email, role, department, salary, shift, UPI ID).
  - Add, edit, or delete staff.
  - Track staff attendance and performance analytics.
  - Assign, edit, and delete tasks for staff.
  - Approve or reject leave applications.
  - Manage payroll for staff directly within the app.
- **Announcements**:
  - Create announcements for specific departments.
- **Dashboards**:
  - Bar chart graphs for:
    - Staff present, vacant, or busy.
    - Room availability (occupied vs. empty).
  - Shift management for staff.

### Receptionist
- **Task Management**:
  - Assign tasks to staff.
  - View tasks and announcements.
- **Attendance and Analytics**:
  - View attendance records by week or month.
  - Graphs for room occupancy.
- **Shift and Profile Management**:
  - View and update shifts.
  - Apply for leave.
  - Update profile picture and personal details.

### Staff
- **Task Tracking**:
  - Update task status: pending, in progress, or completed.
- **Attendance and Performance**:
  - View attendance records and performance metrics.
- **Leave Management**:
  - Track leave requests (pending or approved).
- **Profile Management**:
  - Update profile picture and personal details.

### Manager
- All admin functionalities except hotel registration.
- Can approve or reject leave applications.

---

## Tech Stack

| **Technology**         | **Purpose**                |
|-------------------------|----------------------------|
| **Flutter**             | Frontend Development       |
| **Riverpod / Provider** | State Management           |
| **Dio / HTTP**          | API Communication          |
| **Firebase Messaging**  | Push Notifications         |
| **Flutter Diagnostic Tools** | Debugging and Performance |
| **GitHub Actions**      | CI/CD and Signed APK Creation |

---

## App Flow

### Hotel Registration
1. Admin registers the hotel.
2. Staff details are uploaded via an Excel file with fields:
   - Email, Name, Role, Department, Salary, Shift, UPI ID.

### Staff Management
- Staff details can be added, edited, or deleted by the admin.
- Admin can view and analyze staff performance, attendance, and shifts.

### Task and Announcement Management
- Tasks can be assigned by admins or receptionists.
- Announcements can be targeted to specific departments.

### Analytics and Dashboards
- Graphs for room occupancy, staff attendance, and hotel analytics.
- Admin and receptionist can track performance metrics.

---

## Screenshots and Videos

### Admin Features
- **Hotel Registration**:
  ![Hotel Registration](https://via.placeholder.com/800x400?text=Hotel+Registration)
- **Dashboard**:
  ![Admin Dashboard](https://via.placeholder.com/800x400?text=Admin+Dashboard)
- **Analytics**:
  ![Admin Analytics](https://via.placeholder.com/800x400?text=Admin+Analytics)

🎥 [Admin Demo Video](https://www.youtube.com/your-admin-demo-link)

### Manager Features
- **Staff Management**:
  ![Manager Staff Management](https://via.placeholder.com/800x400?text=Manager+Staff+Management)
- **Announcements**:
  ![Manager Announcements](https://via.placeholder.com/800x400?text=Manager+Announcements)

🎥 [Manager Demo Video](https://www.youtube.com/your-manager-demo-link)

### Receptionist Features
- **Task Assignment**:
  ![Receptionist Task Assignment](https://via.placeholder.com/800x400?text=Task+Assignment)
- **Leave Management**:
  ![Receptionist Leave Management](https://via.placeholder.com/800x400?text=Leave+Management)

🎥 [Receptionist Demo Video](https://www.youtube.com/your-receptionist-demo-link)

### Staff Features
- **Task Updates**:
  ![Staff Task Updates](https://via.placeholder.com/800x400?text=Task+Updates)
- **Attendance View**:
  ![Staff Attendance](https://via.placeholder.com/800x400?text=Attendance)

🎥 [Staff Demo Video](https://www.youtube.com/your-staff-demo-link)

---

## Installation

### Prerequisites
- Flutter 3.x or later
- Firebase configuration files
- Android Studio / VS Code

### Steps
1. **Clone the Repository**:
   ```bash
   git clone https://github.com/your-repo/hotelcrew.git
   cd hotelcrew

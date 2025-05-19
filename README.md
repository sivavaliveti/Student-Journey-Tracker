# Student-Journey-Tracker

*A Salesforce-Powered Academic Lifecycle Management Application*

---

## 🚀 Overview

The **Student Journey Tracker** is a robust application built on the **Salesforce Lightning Platform**, designed to help educational institutions monitor, support, and analyze a student's academic progress. This intelligent solution leverages Salesforce's automation tools, data modeling capabilities, and AI to ensure students stay aligned with their educational goals.

---

## 🎯 Key Objectives

* Track student performance across modules, courses, and milestones.
* Provide real-time analytics and dashboards for faculty and administrators.
* Automate academic status updates via **Flows** and **Apex**.
* Deliver a scalable, personalized student monitoring experience.

---

## 🛠️ Technologies Utilized

* **Salesforce Lightning Platform**
* **Apex Programming Language**
* **Lightning Web Components (LWC)**
* **Flows & Process Builder**
* **Custom Metadata Types**
* **Slack Integration (for Notifications)**
* **Einstein AI (for Recommendations)**

---

## 📌 Core Features

* 🔄 **Live Progress Tracking**: Updates student progress dynamically using Flows and Apex logic.
* 📊 **Interactive Dashboards**: Visual performance insights for easy decision-making.
* 🔔 **Automated Alerts**: Slack or Email notifications for key events or student status changes.
* 📁 **Data Import/Export**: Easily integrate student records via import wizards and templates.
* 🤖 **AI Recommendations**: Leverage Einstein AI to suggest next steps for struggling students.
* 🔐 **Role-Based Access**: Secure data access for students, faculty, and admins via permission sets.

---

## 🧩 Application Components

| Component            | Role Description                                               |
| -------------------- | -------------------------------------------------------------- |
| **Apex Controllers** | Handle backend logic and data manipulation.                    |
| **LWC Components**   | Deliver a responsive and dynamic frontend UI.                  |
| **Flows**            | Automate processes such as course and module status updates.   |
| **Custom Objects**   | Represent entities like `CourseConnection`, `Module__c`, etc.  |
| **Custom Metadata**  | Define rules for notifications, thresholds, and user settings. |

---

## 📈 Real-World Use Case

> **Scenario**: A student completes all modules in a course.
> ✅ A **Record-Triggered Flow** checks the completion status of all related `Module__c` records.
> 🎉 Once all modules are marked "Completed", the system automatically updates the parent `CourseConnection` record to **"Completed"**.
> 🔔 A Slack notification is triggered to inform the Admin.

---

## 🧪 Testing Strategy

* ✅ **Apex Unit Testing**: Ensures code coverage for all business logic and validations.
* 🔄 **Flow Test Cases**: Validate conditions such as:

  * Module progression
  * Course completion logic
  * Notification triggering via Slack

---

## 👥 Contributors

* **👤 Selapureddy Nikhil** – Developer & Team Lead
  🔗 [GitHub](https://github.com/NIKHILSELAPUREDDY) | [LinkedIn](https://www.linkedin.com/in/nikhil-selapureddy)

---

## 📄 License & Usage

This project was developed as part of an educational internship at **Edubot Software & Services**.
📚 Intended solely for academic demonstration and non-commercial use.

---

Would you like this converted into a PDF or formatted as a README.md for GitHub?

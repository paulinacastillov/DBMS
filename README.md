Here’s a description for your GitHub repository based on the project functionality you've shared:

---

# Client and Volunteer Management System

This project is a **Java-based management system** designed to handle clients, volunteers, employees, and teams within an organization, with support for integration with an Azure SQL database. This system facilitates various operations such as managing client information, donations, volunteer team associations, and team reporting relationships, alongside other key functionalities for efficient database interactions.

## Key Features

- **Client Management**: Register new clients with comprehensive details (personal information, doctor information, and enrollment details).
- **Volunteer and Employee Management**: Insert and manage volunteers and employees, associate them with teams, and track hours worked by volunteers.
- **Donation Tracking**: Record donation information for clients who are donors, with support for handling multiple donations per client.
- **Team Management**: Register new teams, track team leaders, and manage team associations with clients and employees.
- **Automated Data Cleaning**: Functions to remove clients who meet specific criteria, such as those without insurance or with low transportation needs.
- **File Import/Export**: Import team information from text files and export mailing lists to CSV format.
- **Azure SQL Integration**: Connects to an Azure SQL database with secure credentials for executing SQL queries and stored procedures.

## Functionality Overview

1. **Data Insertion and Association**:
   - Insert clients, volunteers, and employees with details such as profession, contact info, mailing list status, and team associations.
   - Insert donations associated with specific clients, including donation date, amount, and anonymity status.
   - Automatically handle associations between volunteers/employees and their respective teams.

2. **Query Execution**:
   - SQL-based data retrieval methods, such as fetching clients without insurance, total donations by employees who are also donors, and teams that report to multiple employees.
   - Methods to retrieve contact information for emergency contacts and specific associations like volunteer lists for client-associated teams.

3. **Deletion Operations**:
   - Clean-up functions to remove clients based on insurance and necessity criteria, with cascading deletions across related tables to ensure referential integrity.

4. **JSP Integration**:
   - Front-end JSP pages facilitate input collection, validate data, and display information to end-users.
   - User prompts and alerts for actions like successful data insertion or error notifications.

## Setup

1. **Database Configuration**:
   - Set up an Azure SQL database with the required tables and foreign key constraints as described in the SQL scripts.
   - Update `DataHandler.java` with appropriate credentials and connection strings.

2. **Run Application**:
   - Deploy the JSP files on a compatible server (e.g., Apache Tomcat).
   - Compile and run Java classes to initialize connections and perform operations.

## File Structure

- **Java Classes**:
  - `DataHandler.java`: Core class handling database operations with methods for insertion, querying, deletion, and data import/export.
- **JSP Files**:
  - `PAN_query*.jsp`: JSP files for user interface, including input forms and output display for various operations (e.g., adding clients, managing donations).

## Prerequisites

- **Java 8+**
- **JSP-compatible server** (e.g., Apache Tomcat)
- **Azure SQL Database**

## License

MIT License

---

This README provides a comprehensive view of the project, outlining key features, setup, and functionality. Let me know if you'd like more specific details added, like code examples or setup instructions.

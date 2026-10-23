# User Story Template
**Title:**
_As a [user role], I want [feature/goal], so that [reason]._
**Acceptance Criteria:**
1. [Criteria 1]
2. [Criteria 2]
3. [Criteria 3]
**Priority:** [High/Medium/Low]
**Story Points:** [Estimated Effort in Points]
**Notes:**
- [Additional information or edge cases]
- 
1. User Story: Account Registration
Title: New User Registration for Habit Tracking

User Story:

As a new user,

I want to register by entering my name, username, age, and country,

so that I can create a personal profile and start tracking my habits.

Acceptance Criteria:

The registration form must require Name, Username, Age, and Country.

All input fields must validate proper data types (e.g., Age must be a positive number).

Upon successful submission, the system should navigate the user to the habit dashboard.

The system should notify the user that session data will reset upon logout (due to security constraints).

Priority: High

Story Points: 3

Notes: User credentials will not persist in browser cache after logout due to demo environment security limits.

2. User Story: Account Login
Title: User Authentication via Default Credentials

User Story:

As a registered user,

I want to log in using the system default username and password,

so that I can access my account dashboard and manage my habit tracker.

Acceptance Criteria:

The login form must have input fields for Username and Password.

The system authenticates the user successfully using the pre-configured default credentials.

Clicking the "Log In" button redirects the authenticated user to their main dashboard.

Passwords must be masked (bullets/asterisks) while typing for security.

Priority: High

Story Points: 2

Notes: Login is strictly configured to validate against the system's default admin/demo credentials.

3. User Story: Login Failure Feedback
Title: Validation Error Message for Invalid Login

User Story:

As a user attempting to log in,

I want to receive an explicit error message when entering incorrect credentials,

so that I know why the login failed and can try again.

Acceptance Criteria:

If an invalid username or password is submitted, an error banner/toast must appear immediately.

The error text should clearly state: "Invalid username or password. Please try again."

The password field should automatically clear after a failed attempt.

The form should not lock the user out, allowing immediate retry.

Priority: Medium

Story Points: 1

Notes: Ensure generic error messaging so as not to expose whether the username or password specifically was wrong.

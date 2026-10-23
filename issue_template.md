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
## User Stories Implementation

### 1. Account Registration

**Title:** New User Registration for Habit Tracking

**User Story:**
*As a new user, I want to register by entering my name, username, age, and country, so that I can create a personal profile and start tracking my habits.*

**Acceptance Criteria:**
1. The registration form must require Name, Username, Age, and Country fields.
2. All input fields must validate data types properly (e.g., Age must be a positive integer).
3. Upon successful registration submission, the system navigates the user to the habit dashboard.
4. The system notifies the user that session data will reset upon logout due to environment security constraints.

**Priority:** High  
**Story Points:** 3  
**Notes:** User credentials will not persist in browser cache after logout due to demo environment security limits.

---

### 2. Account Login

**Title:** User Authentication via Default Credentials

**User Story:**
*As a registered user, I want to log in using the system default username and password, so that I can access my account dashboard and manage my habit tracker.*

**Acceptance Criteria:**
1. The login form must provide distinct input fields for Username and Password.
2. The system authenticates the user successfully using the pre-configured default credentials.
3. Clicking the "Log In" button redirects the authenticated user directly to their main dashboard.
4. Password field inputs must be masked for security.

**Priority:** High  
**Story Points:** 2  
**Notes:** Login is strictly configured to validate against the system default admin/demo credentials.

---

### 3. Error Feedback on Login

**Title:** Validation Error Message for Invalid Login

**User Story:**
*As a user attempting to log in, I want to receive an explicit error message when entering incorrect credentials, so that I know why the login failed and can try again.*

**Acceptance Criteria:**
1. If an invalid username or password is submitted, an error alert/toast must appear immediately.
2. The error notification clearly states: *"Invalid username or password. Please try again."*
3. The password input field automatically clears upon a failed login attempt.
4. The login interface allows immediate retries without locking the user interface.

**Priority:** Medium  
**Story Points:** 1  
**Notes:** Provides clear feedback while keeping the error message generic to prevent username enumeration.

## Exercise 3: Homepage User Stories

### 1. View Welcome Message

**Title:** Personalized Welcome Message on Homepage

**User Story:**
*As a user, I want to see a personalized welcome message with my name on the homepage, so that I feel recognized and can confirm I am logged into the correct account.*

**Acceptance Criteria:**
1. The homepage displays a greeting message incorporating the logged-in user's name (e.g., "Welcome back, [Name]").
2. If the user name is unavailable, a default generic greeting ("Welcome back") is displayed.
3. The welcome banner is prominently positioned at the top of the homepage view.

**Priority:** High  
**Story Points:** 1  
**Notes:** Ensures clear confirmation of user session identity upon navigating to the homepage.

---

### 2. Display Weekly Progress

**Title:** Daily and Weekly Habit Progress Overview

**User Story:**
*As a user, I want to see my daily progress for each habit on the homepage, so that I can easily monitor my progress.*

**Acceptance Criteria:**
1. A visual progress summary (e.g., completion percentage or progress bar) is rendered for active habits.
2. The user can view daily progress breakdowns corresponding to the current week.
3. Progress data updates dynamically when a habit status changes.

**Priority:** High  
**Story Points:** 3  
**Notes:** Provides a high-level visual summary to encourage daily user engagement.

---

### 3. View Completed Habits

**Title:** Completed Habits Section

**User Story:**
*As a user, I want to see a section for completed habits on the homepage, so that I can track what I have already achieved.*

**Acceptance Criteria:**
1. A dedicated section or list displays habits marked as fully completed for the selected period.
2. Completed habits show clear visual indicators (e.g., checkmarks or striking through).
3. Users can collapse or expand the completed habits list to save screen space.

**Priority:** Medium  
**Story Points:** 2  
**Notes:** Keeps completed items visible for motivation without cluttering the active habits list.

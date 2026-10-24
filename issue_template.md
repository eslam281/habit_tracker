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

---

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
---

## Exercise 4: Menu Navigation User Stories

### 1. Access Menu Options

**Title:** Navigation Menu Access

**User Story:**
*As a user, I want to access a menu with options for configuring my habits, viewing reports, editing my profile, and signing out, so that I can easily navigate to different parts of the app.*

**Acceptance Criteria:**
1. A menu button/icon (e.g., hamburger menu or drawer) is visible and accessible from any primary app screen.
2. Tapping the menu icon expands or presents all available options clearly: Habits, Reports, Profile, and Sign Out.
3. The menu interface can be easily closed or dismissed without making a selection.

**Priority:** High  
**Story Points:** 2  
**Notes:** Acts as the primary global navigation entry point across the application.

---

### 2. Navigate to Profile

**Title:** Profile Page Navigation

**User Story:**
*As a user, I want to navigate to my profile page from the menu, so that I can view and edit my personal details.*

**Acceptance Criteria:**
1. The navigation menu includes a clearly labeled "Profile" option.
2. Clicking "Profile" redirects the user directly to the profile management page.
3. The active menu state highlights or updates upon successful navigation to the Profile screen.

**Priority:** Medium  
**Story Points:** 1  
**Notes:** Allows quick access for users to manage account details and preferences.

---

### 3. Navigate to Habits Page

**Title:** Habits Management Navigation

**User Story:**
*As a user, I want to access the habits page from the menu, so that I can configure and manage my habits.*

**Acceptance Criteria:**
1. The navigation menu contains a dedicated "Habits" option.
2. Selecting "Habits" navigates the user to the habits overview/configuration screen.
3. The user can view existing habits and access controls to create or edit habit entries.

**Priority:** High  
**Story Points:** 2  
**Notes:** Core feature shortcut ensuring fast access to habit customization.

---

### 4. Sign Out from Menu

**Title:** User Logout via Navigation Menu

**User Story:**
*As a user, I want to sign out of my account using an option in the menu, so that I can securely log out when I'm finished using the app.*

**Acceptance Criteria:**
1. The menu displays a prominent "Sign Out" or "Log Out" action button.
2. Selecting "Sign Out" prompts a quick confirmation modal to prevent accidental logouts.
3. Upon confirming logout, the active user session is terminated and redirected to the login screen.
4. Temporary session cache is cleared according to security policy requirements.

**Priority:** High  
**Story Points:** 1  
**Notes:** Ensures user security and clean session state reset upon exiting the application.
---

## Exercise 5: Profile Page User Stories

### 1. View Personal Information

**Title:** View Saved Registration Details

**User Story:**
*As a user, I want to view my saved name, username, age, and country on my profile page, so that I can see the details I provided during registration.*

**Acceptance Criteria:**
1. The profile page renders distinct fields for Name, Username, Age, and Country.
2. The values displayed match the current active session/user registration data.
3. Fields remain in read-only mode until the user explicitly initiates editing.

**Priority:** High  
**Story Points:** 1  
**Notes:** Provides transparency so users can review their saved personal details.

---

### 2. Edit Personal Information

**Title:** Edit Profile Details Form

**User Story:**
*As a user, I want to update my name, username, age, and country on my profile page, so that I can keep my information up to date.*

**Acceptance Criteria:**
1. An "Edit Profile" button toggles input fields into an editable state.
2. All editable fields perform proper input validation (e.g., preventing empty required fields or invalid age numbers).
3. The interface provides clear "Save" and "Cancel" actions while in edit mode.

**Priority:** High  
**Story Points:** 2  
**Notes:** Allows flexible updates to user profile attributes when details change.

---

### 3. Save Updated Information

**Title:** Persist Profile Changes

**User Story:**
*As a user, I want the changes I make to my profile to be saved, so that my updated details are stored and reflected throughout the app.*

**Acceptance Criteria:**
1. Clicking the "Save" button commits all valid modifications to the user profile model.
2. A success confirmation feedback (toast/banner) alerts the user that changes were saved successfully.
3. If saving fails, an error message appears and retains the user's unsaved edits in the form.

**Priority:** High  
**Story Points:** 2  
**Notes:** Ensures state persistence and seamless updates across the active session.

---

### 4. Update Name in Header

**Title:** Dynamic Header Name Synchronization

**User Story:**
*As a user, I want my updated name to be displayed in the app's header after I change it in the profile, so that my changes are immediately visible.*

**Acceptance Criteria:**
1. Updating the name field in the profile automatically triggers a state update in the top app header/welcome banner.
2. The newly saved name reflects instantly across global navigation headers without requiring a manual page refresh.

**Priority:** Medium  
**Story Points:** 1  
**Notes:** Enhances UI consistency and real-time state synchronization across screens.

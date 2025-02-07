# Product Requirements Document (PRD) for iOS Exercise App

## Project Overview
The iOS Exercise App is designed to help users stay active with a quick, structured 5-minute workout. The app ensures simplicity and accessibility by guiding users through a daily exercise routine, tracking progress, and providing an offline experience.

## Features
1. **Home Screen with "Go" Button**
2. **Exercise Timer and Routine Display**
3. **7-Day Exercise History Tracking**
4. **Structured Workout Plan**
5. **Offline GIF Storage and Exercise Selection**
6. **Two Difficulty Levels for Each Exercise**
7. **Post-Workout Encouragement**

## Requirements for Each Feature

### 1. Home Screen "Go" Button
- Large, centered button labeled "Go".
- Tapping the button starts a 30-second countdown before workout begins.
- Transition to exercise routine screen after countdown.

### 2. Exercise Timer and Routine Display
- Displays 10 exercises for a 5-minute workout (30 seconds each).
- Countdown timer for each exercise.
- Visual and optional audio cues for exercise transitions.

### 3. 7-Day Exercise History Tracking
- Stores workout completion data for the last 7 days.
- Displays basic stats (completed workouts, skipped workouts).

### 4. Structured Workout Plan
- **Day 1:** Chest, Triceps, Abs
- **Day 2:** Back, Biceps, Abs
- **Day 3:** Legs (Quads, Hamstrings, Glutes), Abs
- **Day 4:** Shoulders, Abs
- **Day 5:** Active Training (HIIT), Abs
- **Day 6:** Yoga
- **Day 7:** Rest-Walk
- Rotates automatically based on the current day.

### 5. Offline GIF Storage and Exercise Selection
- All GIFs stored locally to ensure offline usability.
- Exercises categorized in folders by type.
- Each exercise has a predefined duration (e.g., Bicep Curls - 30s, Yoga Flow - 5 min).

### 6. Two Difficulty Levels for Each Exercise
- Each exercise has two versions: "easy" and "hard".
- Users can manually switch between difficulty levels.
- Defaults to previous selection if available.

### 7. Post-Workout Encouragement
- Upon completing 5 minutes of exercise, the app congratulates the user.
- Encourages the user to continue for an additional 2 minutes.
- Provides an optional "Extend Workout" button to continue exercising.

## Data Models

### User Progress Model
```json
{
  "userId": "1234",
  "workoutDate": "2025-02-05",
  "completedExercises": [
    {"name": "Bicep Curls", "difficulty": "hard", "duration": 30},
    {"name": "Plank", "difficulty": "easy", "duration": 30}
  ]
}
```

### Exercise Model
```json
{
  "name": "Bicep Curls",
  "category": "Arms",
  "difficultyLevels": {
    "easy": "bicep_curl_easy.gif",
    "hard": "bicep_curl_hard.gif"
  },
  "duration": 30
}
```

### Workout Plan Model
```json
{
  "day": 1,
  "categories": ["Shoulders", "Back", "Abs"]
}
```

## API Contracts

### 1. Fetch Workout Plan for the Day
**Endpoint:** `GET /api/workout-plan`
**Request:**
```json
{
  "userId": "1234",
  "date": "2025-02-05"
}
```
**Response:**
```json
{
  "day": 1,
  "categories": ["Shoulders", "Back", "Abs"]
}
```

### 2. Fetch Exercises for a Workout Category
**Endpoint:** `GET /api/exercises`
**Request:**
```json
{
  "category": "Back"
}
```
**Response:**
```json
[
  {
    "name": "Pull-ups",
    "difficultyLevels": {
      "easy": "pull_up_easy.gif",
      "hard": "pull_up_hard.gif"
    },
    "duration": 30
  }
]
```

### 3. Log User Workout Completion
**Endpoint:** `POST /api/workout-log`
**Request:**
```json
{
  "userId": "1234",
  "date": "2025-02-05",
  "completedExercises": [
    {"name": "Bicep Curls", "difficulty": "hard", "duration": 30}
  ]
}
```
**Response:**
```json
{
  "status": "success",
  "message": "Workout logged successfully."
}
```

### 4. Fetch User Workout History
**Endpoint:** `GET /api/workout-history`
**Request:**
```json
{
  "userId": "1234"
}
```
**Response:**
```json
{
  "history": [
    {
      "date": "2025-02-04",
      "completedExercises": ["Push-ups", "Squats", "Plank"]
    }
  ]
}
```

## Dependencies & Considerations
- **Local Storage:** GIFs stored locally for offline usage.
- **Offline Mode:** Queue logs when offline, sync later.
- **Authentication:** Optional for v1.
- **Data Format:** JSON with `camelCase` naming.

This PRD provides a clear roadmap for development. Let me know if any refinements are needed!


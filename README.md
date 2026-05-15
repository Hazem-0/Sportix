<div align="center">


# 🏆 Sportix

**Your all-in-one sports companion — Leagues, Fixtures, Teams & more.**

[![Swift](https://img.shields.io/badge/Swift-5.9-FA7343?style=for-the-badge&logo=swift&logoColor=white)](https://swift.org)
[![iOS](https://img.shields.io/badge/iOS-15+-000000?style=for-the-badge&logo=apple&logoColor=white)](https://developer.apple.com/ios/)
[![Xcode](https://img.shields.io/badge/Xcode-15+-1575F9?style=for-the-badge&logo=xcode&logoColor=white)](https://developer.apple.com/xcode/)
[![Architecture](https://img.shields.io/badge/Architecture-MVP%20%2B%20Clean-6C63FF?style=for-the-badge)](https://github.com)
[![License](https://img.shields.io/badge/License-MIT-green?style=for-the-badge)](LICENSE)

</div>

---

## 📖 Table of Contents

- [Overview](#-overview)
- [Features](#-features)
- [Architecture](#-architecture)
- [Project Structure](#-project-structure)
- [Tech Stack & Dependencies](#-tech-stack--dependencies)
- [Getting Started](#-getting-started)
- [Configuration](#-configuration)
- [Data Flow](#-data-flow)
- [Team](#-team)

---

## 🌟 Overview

**Sportix** is a native iOS application that brings the world of sports to your fingertips. Built with a clean, scalable architecture, Sportix lets users explore leagues, track live & upcoming fixtures, browse team rosters, and save their favorite leagues — all wrapped in a polished, dark-mode-ready interface.

The app supports four major sports categories:

| Sport | Supported |
|-------|-----------|
| ⚽ Football | ✅ |
| 🏀 Basketball | ✅ |
| 🎾 Tennis | ✅ |
| 🏏 Cricket | ✅ |

---

## ✨ Features

### 🎬 Animated Splash Screen
- Stunning **Lottie animation** plays on launch
- Automatically routes to Onboarding (first run) or the Main App

### 📋 Onboarding
- Multi-page onboarding flow for first-time users
- Persisted via `UserDefaults` so it's shown only once

### 🏟️ Sports & Leagues
- Browse all supported sports from a categorized home screen
- View all leagues per sport fetched from the live API
- Smooth collection view with sport badges and country flags

### 🔍 League Details
- Dive into any league to see:
  - **Upcoming Fixtures** — future matches with team logos, date & time
  - **Past Fixtures** — recent results with scores
  - **Teams** — all teams competing in the selected league

### 👥 Team Details
- Full team profile including players and key stats
- Rich card-based UI for player listings

### ⭐ Favorites
- Add/remove leagues to a personal Favorites list
- Favorites are persisted locally using **Core Data**
- Accessible from a dedicated tab at any time

### 🌗 Dark / Light Mode
- Full system-level Dark Mode support
- Manual theme toggle with smooth **cross-dissolve transition**
- Theme preference saved and restored across sessions

### 📡 Offline Awareness
- Network connectivity checked via `ReachabilityManager`
- Graceful error alerts when the device is offline

---



## 🏛️ Architecture

Sportix is built following **Clean Architecture** principles with an **MVP** (Model-View-Presenter) presentation pattern.

```
┌─────────────────────────────────────────────────┐
│                  Presentation Layer              │
│          (ViewControllers + Presenters)          │
│              MVP pattern per scene               │
└────────────────────┬────────────────────────────┘
                     │ uses
┌────────────────────▼────────────────────────────┐
│                  Domain Layer                    │
│         (Models + Repository Protocol)           │
│          Pure Swift — no framework deps          │
└────────────────────┬────────────────────────────┘
                     │ implements
┌────────────────────▼────────────────────────────┐
│                   Data Layer                     │
│   Remote: NetworkManager (Alamofire + async/await)│
│   Local:  CoreData (Favorites) + UserDefaults    │
│           Mapper: DTO → Domain Model             │
└─────────────────────────────────────────────────┘
```

### Layer Responsibilities

| Layer | Responsibility |
|-------|---------------|
| **Domain** | Defines pure `struct` models (`League`, `Fixture`, `TeamDetails`, etc.) and the `SportixRepo` protocol — no dependencies on UIKit or any framework |
| **Data** | `SportixRepoImp` implements `SportixRepo`, coordinating `NetworkManager`, `CoreDataManager`, and `AppSettingsLocalDataSource` |
| **Presentation** | Each scene owns a `ViewController` (View) + `Presenter`; the Presenter calls the repo and maps data to display-ready format, then notifies the View via a delegate |

---

## 📁 Project Structure

```
Sportix/
├── AppDelegate.swift
├── SceneDelegate.swift
├── Config.xcconfig                  # API key configuration
│
├── Domain/
│   ├── Models/
│   │   ├── Sport.swift              # Sport enum (Football, Basketball, Tennis, Cricket)
│   │   ├── League.swift
│   │   ├── Fixture.swift
│   │   ├── TeamDetails.swift
│   │   ├── Player.swift
│   │   ├── OnboardingSlide.swift
│   │   └── Sport+APIPath.swift      # API path mapping per sport
│   └── Repo/
│       └── SportixRepo.swift        # Repository protocol (abstraction)
│
├── Data/
│   ├── Remote/
│   │   ├── NetworkManager.swift     # Alamofire async/await wrapper
│   │   ├── APIService.swift
│   │   ├── NetworkError.swift
│   │   ├── Endpoint/
│   │   │   ├── EndpointProtocol.swift
│   │   │   ├── LeaguesEndpoint.swift
│   │   │   ├── FixtureEndpoint.swift
│   │   │   └── TeamEndpoint.swift
│   │   └── Model/                   # API response DTOs
│   ├── Local/
│   │   ├── CoreData/
│   │   │   ├── CoreDataManager.swift
│   │   │   └── Sportix.xcdatamodeld
│   │   └── UserDefaults/
│   │       └── AppSettingsLocalDataSource.swift
│   ├── Mapper/                      # DTO → Domain model mappers
│   └── Repo/
│       └── SportixRepoImp.swift     # Concrete repository implementation
│
├── Presentation/
│   └── Scenes/
|       ├── Splash/           
│       ├── Onboarding/              # Presenter + View
│       ├── Sports/                  # Presenter + View
│       ├── Leagues/                 # Presenter + View
│       ├── LeagueDetails/           # Presenter + View
│       ├── TeamDetails/             # Presenter + View
│       ├── Favorites/               # Presenter + View
│       └── MainTabBar/              # Tab bar controller
│
└── Utils/
    ├── AppTheme.swift               # Design tokens: Colors, Radius, Spacing + ThemeManager
    ├── Alert.swift                  # Reusable alert helpers
    └── ReachablityManager.swift     # Network connectivity checker
```

---

## 🛠 Tech Stack & Dependencies

| Technology | Purpose |
|------------|---------|
| **Swift 5.9** | Primary language |
| **UIKit** | UI framework (programmatic + Storyboard) |
| **Alamofire** | HTTP networking — wraps `URLSession` with async/await |
| **Lottie** | JSON-driven animations (Splash screen) |
| **Core Data** | Local persistence for favorite leagues |
| **UserDefaults** | Lightweight persistence (onboarding flag, theme preference) |
| **SystemConfiguration** | Native network reachability checks |


### External APIs

Sportix is powered by the **[AllSportsAPI](https://allsportsapi.com/)** — a RESTful API providing:
- League listings per sport
- Fixture schedules (upcoming & past)
- Team and player data

---

## 🚀 Getting Started

### Prerequisites

| Requirement | Minimum Version |
|-------------|----------------|
| macOS | 13.0 (Ventura) or later |
| Xcode | 15.0 or later |
| iOS Deployment Target | 15.0 |


### Installation

1. **Clone the repository**

   ```bash
   git clone https://github.com/your-org/sportix.git
   cd sportix/Sportix
   ```

2. **Install dependencies**

   ```bash
   pod install
   ```

3. **Open the workspace** _(not the `.xcodeproj`)_

   ```bash
   open Sportix.xcworkspace
   ```

4. **Configure the API key** (see [Configuration](#-configuration) below)

5. **Select a simulator or device**, then press **⌘ + R** to run.

---

## ⚙️ Configuration

The API key is injected via an `.xcconfig` file and is **not** hardcoded in source files.

1. Open `Sportix/Config.xcconfig`
2. Replace the placeholder value with your own API key from [AllSportsAPI](https://allsportsapi.com/):

   ```
   API_KEY = your_api_key_here
   ```

> [!WARNING]
> Never commit your real API key to version control. Add `Config.xcconfig` to `.gitignore` if distributing publicly.

---

## 🔄 Data Flow

```
User Action
    │
    ▼
ViewController  ──────►  Presenter
                              │
                              ▼
                         SportixRepo (Protocol)
                              │
                              ▼
                       SportixRepoImp
                        ├── NetworkManager  ──►  AllSportsAPI
                        ├── CoreDataManager ──►  Core Data Store
                        └── AppSettings     ──►  UserDefaults
                              │
                              ▼ (mapped to Domain Models)
                         Presenter
                              │
                              ▼
                       ViewController (updates UI)
```

---

## 👨‍💻 Team

| Name |
|------|
| **Hazem Abdelraouf** |
| **Aalaa Adel** |

---

<div align="center">

Made with ❤️ and Swift

</div>

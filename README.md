# AI Quotes

## Overview

AI Quotes is a mobile application designed to centralize your quote collection and provide AI-powered quote generation. This project is my contribution to the Google I/O Extended Hackathon '24, focusing on Web, Mobile, Gaming, and AI.

## Compelling Problem

As a quote enthusiast, I often struggle with:
- **Scattered collections:** Quotes are saved in various places - notes, emails, social media - making it hard to find the perfect one or that quote I heard before, leading to hours of searching.
- **Limited inspiration:** Finding new and relevant quotes can be time-consuming.

## Target Audience

- **Quote enthusiasts:** People who collect and use quotes for inspiration, communication, or creativity.
- **Writers and communicators:** Individuals who use quotes to enhance their writing and speaking.

## Solution

AI Quotes is a mobile app that offers a central hub for all your quote needs.

### Features

- **Home Page:** 
  - Beautiful background image of the Apple Park visitor center sand sculpture titled ‘Mirage’.
  - Preview quotes based on the selection from the Floating Action Button.
  
- **Floating Action Button:**
  - **Add Quote:** Manually enter and preview a quote before adding it to the list.
  - **Random Quote:** Fetch a random quote from Zenquotes.io.
  - **AI Quote:** Generate an AI-powered quote based on a given category using Gemini Flash.
  - **Favorite List:** Access your favorite quotes.
  - **Quote List:** View all added quotes.

- **Quote List:**
  - Add quotes from the Home Page.
  - Mark quotes as favorites.
  - Delete quotes.
  - Add an author's occupation before adding to the Favorite List.

- **Favorite List:**
  - Display favorite quotes added from the Quote List.

### Development

- **IDE:** Project IDX, a web-based, AI-assisted development environment (IDE) from Google.
- **Backend:** Firebase Service with Cloud Firestore for storing, syncing, and querying data.
- **State Management:** Provider package.
- **Code Quality:** Adheres to Clean Code and Best Practices.

### Gemini AI Quote Generator

- **API Endpoint:** Provides unique AI-powered quotes based on a given category using Firebase Functions and the Gemini AI Flash 1.5 model.
- **GitHub Repo:** [AI Quotes Gemini](https://github.com/JavaVista/ai-quotes-gemini)


## Contribution

This is currently a personal project, but anyone interested in contributing is welcome!

## Future Work

- **Dynamic Background:** Change background images based on the author or the category/mood of the quote.
- **Grammar Check:** Ensure quotes are polished and error-free using Gemini's grammar-checking capabilities.
- **Custom API:** Create a custom API like Zenquotes.io to fetch quotes from a curated collection.
- **Enhanced AI Quote Generation:** Allow users to enter not just the category but also the author's name and user's mood.
- **Quote Organization:** Create collections, tag quotes, and search for them easily.
- **Social Media Sharing:** Add a feature to share quotes on social media platforms.
- **Voice Activation:** Explore voice-activated quote search and AI-powered quote translation.
- **Refactoring:** Continue to refactor and adhere to Clean Code and Best Practices.

## Getting Started

### Prerequisites

- Flutter SDK
- Firebase Account
- Project IDX (optional)

### Installation

1. **Clone the repository:**
    ```bash
    git clone https://github.com/JavaVista/ai-quotes.git
    ```
2. **Navigate to the project directory:**
    ```bash
    cd ai-quotes
    ```
3. **Install dependencies:**
    ```bash
    flutter pub get
    ```
4. **Set up Firebase:**
   - Follow the instructions on the [Firebase Console](https://console.firebase.google.com/) to create a project and add Firebase to your Flutter app.
   - Replace the `google-services.json` and `GoogleService-Info.plist` files in the project with your own.

5. **Run the app:**
    ```bash
    flutter run
    ```

## Usage

- Launch the app and navigate through the different features using the Floating Action Button.
- Add, view, and manage quotes.
- Generate AI-powered quotes by entering a category.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

Thank you for checking out my AI Quotes project! If you have any questions or suggestions, feel free to open an issue or submit a pull request.


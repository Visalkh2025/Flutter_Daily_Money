# Daily Money - Personal Finance Tracker

Daily Money is a Flutter application that helps you track your daily income and expenses. It provides a simple and intuitive interface to manage your personal finances, view your spending habits, and stay on top of your financial goals.

## Features

- **User Authentication**: Secure email and password sign-up and sign-in using [Supabase Auth](https://supabase.com/docs/guides/auth).
- **Transaction Management**:
    - Add, edit, and delete income and expense transactions.
    - View a list of recent transactions on the home screen.
    - Filter transactions by date.
- **Categorization**:
    - Assign categories to transactions (e.g., food, transport, salary).
    - Add custom categories.
    - Delete unused categories.
- **Data Persistence**: All transaction and user data is stored securely in [Supabase Firestore](https://supabase.com/docs/guides/database).
- **Statistics**:
    - Visualize your income and expenses with interactive pie and bar charts from the [fl_chart](https://pub.dev/packages/fl_chart) library.
    - Filter statistics by week, month, and year.
- **Profile Management**:
    - Update your username and profile picture.
    - View your email address.
    - Sign out from the application.

## Project Structure

The project is structured using the [GetX](https://pub.dev/packages/get) pattern, which separates the UI, business logic, and data models.

```
lib/
├───Bindings/       # Dependency injection for controllers
├───Config/
│   ├───routes/      # Route management
│   └───themes/      # App theme data
├───Controllers/   # Business logic (state management)
├───Models/        # Data models
├───Services/      # Services (e.g., API calls)
├───View/          # UI (screens and widgets)
├───Widgets/       # Reusable widgets
├───main.dart      # App entry point
└───my_app.dart    # Root widget
```

## Screenshots

| Splash Screen | Home Screen | Statistics |
| :---: | :---: | :---: |
| ![Splash Screen](https://via.placeholder.com/300x600.png?text=Splash+Screen) | ![Home Screen](https://via.placeholder.com/300x600.png?text=Home+Screen) | ![Statistics](https://via.placeholder.com/300x600.png?text=Statistics) |


## Getting Started

### Prerequisites

- [Flutter SDK](https://flutter.dev/docs/get-started/install)
- A Supabase account and project.

### Installation

1.  **Clone the repository:**
    ```sh
    git clone https://github.com/your-username/daily_money.git
    cd daily_money
    ```

2.  **Install dependencies:**
    ```sh
    flutter pub get
    ```

3.  **Set up environment variables:**
    Create a `.env` file in the root of the project and add your Supabase URL and Anon Key:
    ```
    URL=YOUR_SUPABASE_URL
    ANNON_KEY=YOUR_SUPABASE_ANON_KEY
    ```

4.  **Run the app:**
    ```sh
    flutter run
    ```

## Usage

1.  Sign up or log in to your account.
2.  Add your income and expense transactions from the home screen.
3.  View your daily and total balance on the dashboard.
4.  Navigate to the statistics screen to see a breakdown of your spending.
5.  Manage your profile information in the profile screen.

## Built With

- [Flutter](https://flutter.dev/) - The UI toolkit for building natively compiled applications for mobile, web, and desktop from a single codebase.
- [GetX](https://pub.dev/packages/get) - A powerful and lightweight state management, dependency injection, and navigation library for Flutter.
- [Supabase](https://supabase.io/) - The open source Firebase alternative for building secure and scalable backends.
- [fl_chart](https://pub.dev/packages/fl_chart) - A highly customizable Flutter chart library.

## Contributing

Contributions are what make the open source community such an amazing place to learn, inspire, and create. Any contributions you make are **greatly appreciated**.

1.  Fork the Project
2.  Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
3.  Commit your Changes (`git commit -m 'Add some AmazingFeature'`)
4.  Push to the Branch (`git push origin feature/AmazingFeature`)
5.  Open a Pull Request

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Acknowledgments

-   Thanks to all the amazing packages and tools used in this project.
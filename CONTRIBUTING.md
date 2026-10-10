# Contributing to Eridian Clock

Thank you for your interest in contributing to the **Eridian Clock** project! 
Whether you're fixing a bug, improving documentation, adding an audio chime, or refining the Android widget, we welcome your contributions.

---

## 🛠 Development Workflow

1. **Fork & Clone**:
   ```bash
   git clone https://github.com/your-username/eridian-clock.git
   cd eridian-clock
   ```

2. **Verify Setup**:
   Ensure your Flutter development environment is configured:
   ```bash
   flutter doctor
   ```

3. **Create a Feature Branch**:
   ```bash
   git checkout -b feature/my-new-feature
   ```

4. **Run Tests Frequently**:
   All new logic in `lib/core/` must be covered by automated tests:
   ```bash
   flutter test
   ```

5. **Code Style & Formatting**:
   Ensure code conforms to official Dart guidelines:
   ```bash
   dart format --set-exit-if-changed .
   flutter analyze
   ```

---

## 📐 Project Structure Guidelines

* **`lib/core/`**:
  * Must remain **100% pure Dart**.
  * Never import `package:flutter/material.dart` in `lib/core/`.
  * Keep all mathematical time conversions and physical constants here.
* **`lib/presentation/`**:
  * Contains UI components and widgets.
  * Use Flutter's `CustomPainter` for drawing custom visual symbols.
  * Maintain responsive layouts that adapt cleanly across desktop and mobile aspect ratios.

---

## 🧪 Testing Guidelines

Before opening a pull request, verify that:
1. All existing unit and widget tests pass (`flutter test`).
2. Any new mathematical calculations have corresponding test cases.
3. Edge cases (e.g. tick 0, tick 7775, and Sol boundary rollovers) are explicitly tested.

---

## 🚀 Submitting a Pull Request

1. Commit your changes with clear, descriptive commit messages.
2. Push your branch to your fork.
3. Open a Pull Request against the `main` branch.
4. Our automated GitHub Actions workflow will run `flutter test` and `flutter analyze` on your PR.

# 🪐 Eridian Clock

[![License: MIT](https://img.shields.io/badge/License-MIT-emerald.svg)](https://opensource.org/licenses/MIT)
[![Flutter](https://img.shields.io/badge/Flutter-3.47%2B-blue.svg)](https://flutter.dev)
[![Platform](https://img.shields.io/badge/Platform-Linux%20Desktop%20%7C%20Android-cyan.svg)](https://github.com)
[![Tests](https://img.shields.io/badge/Tests-Passing-brightgreen.svg)](https://github.com)

An open-source, physically accurate **Eridian Clock** application inspired by **Andy Weir’s novel *Project Hail Mary***. 

Built with **Flutter & Dart**, featuring a **base-6 (senary)** mechanical rotor visualization, authentic stroke-count glyph rendering, two-way Earth-to-Eridian time conversion, and an experiment lab reproducing Ryland Grace’s stopwatch measurement.

---

## 📖 The Science & Novel Lore (Chapter 10)

In *Project Hail Mary*, protagonist **Ryland Grace** makes first contact with the Eridian engineer **Rocky** across a xenonite divider. To bridge the communication gap, they use their respective clocks to establish a universal baseline of mathematics and time.

### 1. Senary (Base-6) Biology & Arithmetic
Eridians possess five limbs around a central carapace, but manipulate objects using **two hands with three fingers each** ($2 \times 3 = 6$ digits). Just as humans developed decimal (base-10) arithmetic from ten fingers, Eridians naturally count in **base-6 (senary)** with digits $0$ through $5$.

### 2. The Stroke-Count Numerals
Because Eridians perceive their environment through echolocation and tactile vibration rather than light, their written numerals are formed by the number of straight line segments:

| Digit | Human Numeral | Eridian Glyph | Description |
| :---: | :---: | :---: | :--- |
| **0** | `0` | **$\ell$** | Continuous loop ($0$ straight segments) |
| **1** | `1` | **$\text{I}$** | $1$ straight vertical line |
| **2** | `2` | **$\text{V}$** | $2$ straight lines meeting at an angle |
| **3** | `3` | **$\lambda$** | $3$ straight lines (tripod / lambda shape) |
| **4** | `4` | **$+$** | $4$ straight lines meeting at a central cross |
| **5** | `5` | **$\forall$** | $5$ straight lines (inverted enclosed chevron) |

### 3. Mathematical Derivation of Time Units
Rocky’s mechanical clock features **5 rotating cylinders** (rotors). Grace uses his stopwatch to time the **3rd rotor** ($6^3 = 216$ ticks) as it completes one full lap:

$$\tau_{\text{Eridian}} = \frac{511.0\text{ Earth seconds}}{216\text{ ticks}} \approx 2.36574\text{ Earth seconds}$$

* **Eridian Day (Sol)**: Erid (40 Eridani b) rotates rapidly. One full Eridian day is exactly $6^5 = 7,776\text{ Eridian seconds}$:
  $$1\text{ Sol} = 7,776 \times 2.36574\text{ s} \approx 18,396\text{ Earth seconds} \approx 5.11\text{ hours} \quad (5\text{h } 6\text{m } 36\text{s})$$

### 4. The 5-Rotor Hierarchy
| Rotor | Power | Value (Ticks) | Earth Duration | Role |
| :---: | :---: | :---: | :---: | :--- |
| **Rotor 0** | $6^0$ | $1$ | $\approx 2.37\text{ s}$ | Fundamental tick unit |
| **Rotor 1** | $6^1$ | $6$ | $\approx 14.19\text{ s}$ | Senary minute increment |
| **Rotor 2** | $6^2$ | $36$ | $\approx 85.17\text{ s}$ | Intermediate cycle |
| **Rotor 3** | $6^3$ | $216$ | $\approx 511.0\text{ s}$ ($8.52\text{ min}$) | Major rotor timed by Grace |
| **Rotor 4** | $6^4$ | $1,296$ | $\approx 3,065.9\text{ s}$ ($51.1\text{ min}$) | Eridian hour (1/6th of a day) |
| **Full Cycle**| $6^5$ | $7,776$ | $\approx 18,396\text{ s}$ ($5.11\text{ hours}$) | All rotors rollover to $\ell\ell\ell\ell\ell_6$ |

---

## ✨ Features

- **3D Mechanical Cylinders**: Visual tumbler drums with cylindrical lighting gradients, horizontal mechanical grooves, and tactile deceleration roll animations.
- **Ambient Fullscreen Focus Mode**: A distraction-free zen mode / ambient desk clock displaying exclusively the enlarged mechanical cylinders against an obsidian starfield. Toggle via the fullscreen icon or pressing the `F` key (press `Esc` to exit).
- **Custom Vector Glyph Engine**: Drawn directly onto the hardware canvas via Flutter’s `CustomPainter` for crisp rendering at any DPI (from phone screens to 4K desktop displays).
- **Dual Realtime & Simulation Modes**:
  - **Synced to Earth**: Syncs directly with the local Earth time-of-day.
  - **Simulation Warp**: Run time at $1\times$, $6\times$, $36\times$, or $216\times$ (Grace speed) or manually step $+1\text{ tick}$.
- **Two-Way Earth $\leftrightarrow$ Eridian Converter**: Enter Earth hours/minutes/seconds to calculate Eridian Sols, ticks, and glyphs—or enter Eridian ticks to find the Earth duration.
- **Chapter 10 Experiment Mode**: Interactive lab stopwatch recreating Grace’s measurement of the 3rd rotor lap.
- **In-App Lore Reference**: Instant access to book excerpts, diagrams, and mathematical derivations.

---

## 🏛 Architecture

The codebase follows **Clean Architecture** principles:

```text
eridian-clock/
├── lib/
│   ├── main.dart                       # App entry point, tab navigation, ticker
│   ├── core/                           # 🧠 Pure Dart Domain (Zero UI dependencies)
│   │   ├── constants.dart              # Andy Weir's mathematical constants & glyphs
│   │   ├── eridian_time.dart           # Senary decomposition, rollovers, conversions
│   │   └── eridian_stopwatch.dart      # Experiment stopwatch engine
│   └── presentation/                   # 🎨 Flutter UI Layer
│       ├── theme/
│       │   └── eridian_theme.dart      # Xenonite dark palette & sci-fi tokens
│       └── widgets/
│           ├── eridian_glyph.dart      # Hardware-accelerated vector glyph painter
│           ├── rotor_cylinder.dart     # 3D mechanical cylinder drum widget
│           ├── clock_display.dart      # Primary 5-rotor clock screen
│           ├── converter_view.dart     # Two-way Earth/Eridian converter
│           ├── stopwatch_view.dart     # Chapter 10 experiment stopwatch
│           └── lore_dialog.dart        # Scientific lore documentation modal
├── test/                               # 🧪 Automated Test Suite
│   ├── core/
│   │   ├── eridian_time_test.dart      # Senary arithmetic & conversion tests
│   │   └── eridian_stopwatch_test.dart # Stopwatch engine unit tests
│   └── presentation/
│       └── eridian_glyph_test.dart     # Vector glyph widget tests
└── .github/workflows/
    └── ci.yml                          # Automated GitHub Actions CI/CD pipeline
```

---

## 🚀 Building & Running

### Prerequisites
* [Flutter SDK](https://docs.flutter.dev/get-started/install) ($\ge 3.13$)
* Linux desktop build tools:
  ```bash
  # On Arch / CachyOS:
  sudo pacman -S --needed base-devel clang cmake ninja pkgconf gtk3
  
  # On Ubuntu / Debian:
  sudo apt install clang cmake ninja-build pkg-config libgtk-3-dev
  ```

### Run on Linux Desktop
```bash
flutter run -d linux
```

### Run on Android
```bash
flutter run -d android
```

### Run Tests
```bash
flutter test
```

---

## 🤝 Contributing

Contributions are welcome! Please check [CONTRIBUTING.md](CONTRIBUTING.md) for details on code style, testing requirements, and submitting pull requests.

## 📄 License

This project is open-source and released under the [MIT License](LICENSE).

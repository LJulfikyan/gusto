
# Food Ordering App Blueprint

## Overview

This document outlines the plan and implementation details for a modern food ordering mobile application. The app allows users to browse stores, add products to a cart, place orders, and track their order status. The UI is designed in Argentinian Spanish with a focus on a clean, modern aesthetic and a great user experience.

## Style, Design, and Features

### Implemented

*   **Project Setup**:
    *   Dependencies: `provider`, `google_fonts`, `go_router`.
*   **Theming**:
    *   Centralized theme management in `lib/src/theme`.
    *   `ThemeProvider` for switching between light and dark modes.
    *   Material 3 `ColorScheme.fromSeed` for consistent color palettes.
    *   Custom fonts via `google_fonts` (Oswald, Roboto, Open Sans).
    *   Styled themes for `AppBar`, `ElevatedButton`, and `Card`.
*   **Navigation**:
    *   Declarative routing using `go_router`.
    *   Defined routes for all screens.
*   **Authentication**:
    *   `AuthScreen` with animated page switching for Login and Sign Up.
    *   Styled input fields and buttons.
*   **Core UI**:
    *   **Home Screen**: `StoreCard` widgets for displaying restaurants.
    *   **Store Screen**: Detailed view with a product list.
    *   **Cart Screen**: Manages items with quantity controls.
    *   **Account Screen**: Basic profile and settings links.
*   **State Management**:
    *   `ThemeProvider` for theme state.
    *   `CartProvider` for managing shopping cart state.
    *   `AuthProvider` for user authentication state.
*   **Models**:
    *   Data models for `Store`, `Product`, `CartItem`, and `Order`.
*   **Visual Polish**:
    *   Use of `const` for performance.
    *   Placeholder images for a complete look.
    *   User-facing text in Argentinian Spanish.

### Current Plan

*   Flesh out the remaining screens: Checkout, Orders, Order Details, Settings, and Cards.
*   Implement animations for a more dynamic user experience.
*   Refine the UI/UX based on the complete application flow.
*   Add mock data to simulate a real-world application.
*   Write unit and widget tests for key components.

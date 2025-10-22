---
inclusion: always
---

# Product Overview

A Flutter mobile application for tracking personal financial transactions with Google Spreadsheet backend integration.

## Core Features

- Add transactions with day, note, price, and payment method (cash/card)
- View last 5 transactions
- Undo last transaction
- Real-time "per day" budget calculation displayed in app bar
- Two-tab interface: Add transaction and View transactions

## Backend Integration

The app communicates with a REST API at `https://googlespreadsheet.tindecken.xyz/api` that manages data in Google Spreadsheets.

## User Flow

1. Users add transactions via a form with validation
2. App displays before/after per-day budget on successful submission
3. Users can view recent transactions and undo the last one if needed
4. Per-day budget updates automatically across the app

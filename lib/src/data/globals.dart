import 'package:flutter/material.dart';

const ApiUrl = 'https://nodejs-serverless-connector.vercel.app/api';

const widgetHeight = 370.0;
const widgetHeightMobile = 250.0;
const dealWidth = 340.0;
const dealHeight = 240.0;
const dealSpacing = 16.0;
const borderThickness = .5;
const buttonBorderThickness = 1.0;
const borderColor = Colors.white70;
const pageWidth = 1200.0;
const leftGradient = Color.fromARGB(255, 233, 30, 99);
const rightGradient = Colors.orange;

// Define the color map for buttons
const Map<String, Color> colorButton = {
  'borderColor': Colors.transparent,
  'leftColor': leftGradient,
  'rightColor': rightGradient,
};
const Map<String, Color> transparentButton = {
  'borderColor': Colors.white,
  'leftColor': Colors.transparent,
  'rightColor': Colors.transparent,
};

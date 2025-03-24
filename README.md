# Crop Yield Prediction Application

## Purpose

This project aims to support precision agriculture by forecasting crop yields, enabling farmers to:

- Minimize waste of resources like water, pesticides, and fertilizers
- Prepare for climate-related impacts on crop production
- Select crops with the best yield potential for their area
- Boost profits through informed, data-backed choices

## Data Overview

**Origin**: Crop Yield Prediction Dataset, sourced from Kaggle  
https://www.kaggle.com/datasets/mrigaankjaswal/crop-yield-prediction-dataset

The dataset includes 28,242 records and 7 columns, capturing agricultural and environmental data across 101 countries from 1990 to 2019.

**Main Columns**:

- Area (Country): Categorical, covering 101 distinct countries
- Item: Crop type, with 22 varieties such as Wheat, Maize, and Rice
- Year: Harvest year, ranging from 1990 to 2019
- hg/ha_yield: Yield in hectograms per hectare (target variable)
- average_rain_fall_mm_per_year: Yearly rainfall in millimeters
- pesticides_tonnes: Pesticide use in metric tonnes
- avg_temp: Average annual temperature in Celsius

**Goals of Analysis**:

1. Determine the primary factors influencing crop yields
2. Build models to predict agricultural output
3. Facilitate smarter farming decisions with data

## API Access

**Prediction Endpoint (POST)**: https://summative-belf.onrender.com/predict
**Swagger Interface**: https://summative-belf.onrender.com/docs

## Project Details

The project centers on predicting crop yields using a random forest model, hosted through a FastAPI endpoint, and connected to a Flutter mobile app. It meets the summative assignment criteria by focusing on a specific use case (crop yield prediction).

Using scikit-learn, a random forest model was trained to predict yields based on variables like rainfall, pesticide use, temperature, crop type, region, and year. The model’s performance was evaluated against linear regression and decision trees using mean squared error as the metric.

Loss curves for both training and test data were visualized, and the top-performing model (random forest) was saved for API deployment. A FastAPI endpoint was developed to deliver predictions, accepting POST requests with strict data types and value ranges (enforced via Pydantic’s BaseModel), and is hosted on Render for free.

The Swagger UI allows for easy endpoint testing. A Flutter app was created to work with the API, featuring an input screen with fields for all necessary variables, a "Predict" button, and a results screen showing the predicted yield or error messages. The app is well-structured, intuitive, and visually clean.

## API Endpoint Information

The endpoint uses:
**Method**: POST,
**Path**: `/predict`,
**Input Parameters**:

- `rainfall`: float (0–5000),
- `pesticides`: float (0–200,000),
- `temperature`: float (-10 to 50),
- `item`: string (e.g., "Maize", "Wheat"),
- `area`: string (e.g., "Brazil", "India"),
- `year`: int (1990–2019). Test the endpoint via Swagger UI by sending a POST request with these parameters.

## Flutter App Setup and Usage

To use the Flutter app, ensure you have the **Flutter SDK** installed from [flutter.dev](https://flutter.dev/docs/get-started/install) and an emulator or device ready (Android/iOS emulator or physical device). Follow these steps:

1. **Clone the Repository**: `git clone https://github.com/oyhaan/linear_regression_model.git` and then `cd linear_regression_model/summative/flutter_app`
2. **Install Dependencies**: `flutter pub get `
3. **Set the API URL**: Open `lib/pages/input_page.dart`, find the API endpoint variable (e.g., `final String apiUrl = 'https://summative-belf.onrender.com/predict';`), and confirm it matches `https://summative-belf.onrender.com/predict`.
4. **Launch the App**: `flutter run`. To use the app: on the input screen, input values for rainfall, pesticides, temperature, year, and choose the crop type and country from dropdowns, tap the "Predict" button to send the data to the API, and check the predicted yield or any errors on the results screen.

## Demonstration Video

View the 2-minute demo video [here](https://www.youtube.com/your-video-link). It features: the Flutter app performing predictions with example inputs and the `/predict` endpoint being tested through Swagger UI.

## Notes and Customization

The random forest model outperformed linear regression and decision trees in mean squared error, making it the selected model for deployment. The FastAPI endpoint runs on Render with CORS enabled to allow requests from the Flutter app. For inquiries or issues, reach out to [gyhaan@alustudent.com]. **To Customize**: Update the `git clone` command with your GitHub repository URL, add your YouTube video link in the "Demonstration Video" section, and include your email in the "Notes and Customization" section.

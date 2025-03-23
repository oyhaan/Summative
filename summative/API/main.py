from fastapi import FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel, Field
import pickle
import pandas as pd  # Changed from numpy to pandas
import uvicorn
import gzip

# Initialize FastAPI app
app = FastAPI(title="Crop Yield Prediction API", description="API to predict crop yield based on environmental and regional inputs")

# Add CORS middleware
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # Adjust for production
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Define input schema with Pydantic
class YieldInput(BaseModel):
    rainfall: float = Field(..., ge=0, le=5000, description="Average rainfall in mm per year (0-5000)")
    pesticides: float = Field(..., ge=0, le=200000, description="Pesticides used in tonnes (0-200,000)")
    temperature: float = Field(..., ge=-10, le=50, description="Average temperature in °C (-10 to 50)")
    item: str = Field(..., description="Crop type (e.g., Maize, Potatoes)")
    area: str = Field(..., description="Region or country (e.g., Albania, Zambia)")
    year: int = Field(..., ge=1900, le=2025, description="Year of prediction (1900-2025)")

# Load model and encoders
with gzip.open("../linear_regression/best_model.pkl.gz", "rb") as f:
    model = pickle.load(f)
with open("../linear_regression/label_encoder_item.pkl", "rb") as f:
    le_item = pickle.load(f)
with open("../linear_regression/label_encoder_area.pkl", "rb") as f:
    le_area = pickle.load(f)

# Define feature names as used during training
FEATURE_NAMES = ["average_rain_fall_mm_per_year", "pesticides_tonnes", "avg_temp", "Item", "Area", "Year"]

# Prediction endpoint
@app.post("/predict")
async def predict(data: YieldInput):
    try:
        # Encode item and area
        try:
            item_encoded = le_item.transform([data.item])[0]
        except ValueError:
            raise HTTPException(status_code=400, detail=f"Crop '{data.item}' not recognized.")
        try:
            area_encoded = le_area.transform([data.area])[0]
        except ValueError:
            raise HTTPException(status_code=400, detail=f"Area '{data.area}' not recognized.")

        # Prepare input data as a DataFrame with feature names
        input_data = pd.DataFrame(
            [[data.rainfall, data.pesticides, data.temperature, item_encoded, area_encoded, data.year]],
            columns=FEATURE_NAMES
        )

        # Make prediction
        prediction = model.predict(input_data)[0]

        # Return result
        return {"predicted_yield": round(prediction, 2), "unit": "hg/ha"}
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Prediction error: {str(e)}")

# Run the app (for local testing)
if __name__ == "__main__":
    uvicorn.run(app, host="0.0.0.0", port=8000)   
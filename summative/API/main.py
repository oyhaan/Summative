# main.py
from fastapi import FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel, Field
import pandas as pd
import pickle
import gzip

app = FastAPI(title="Water Quality Dissolved Oxygen Prediction API")

# Add CORS middleware
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # Allow all origins (adjust for production)
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Define the input model with data types and range constraints
class WaterQualityInput(BaseModel):
    salinity: float = Field(..., ge=0, le=10, description="Salinity in ppt (0-10)")
    water_temp: float = Field(..., ge=0, le=40, description="Water temperature in °C (0-40)")
    secchi_depth: float = Field(..., ge=0, le=5, description="Secchi Depth in meters (0-5)")
    air_temp: float = Field(..., ge=-20, le=50, description="Air temperature in °C (-20 to 50)")

# Load the model and scaler from compressed files using pickle and gzip
with gzip.open("do_prediction_model.pkl.gz", "rb") as f:
    model = pickle.load(f)

with gzip.open("scaler_do.pkl.gz", "rb") as f:
    scaler = pickle.load(f)

@app.post("/predict")
async def predict_dissolved_oxygen(input_data: WaterQualityInput):
    # Create a dataframe with the input data
    input_df = pd.DataFrame({
        "Salinity (ppt)": [input_data.salinity],
        "Water Temp (?C)": [input_data.water_temp],
        "Secchi Depth (m)": [input_data.secchi_depth],
        "Air Temp-Celsius": [input_data.air_temp]
    })
    
    # Scale the input data
    input_scaled = scaler.transform(input_df)
    
    # Make prediction
    prediction = model.predict(input_scaled)[0]
    
    # Interpret the prediction
    safety_message = (
        "Dissolved Oxygen level suggests the water is safe for aquatic life (>=5 mg/L)."
        if prediction >= 5
        else "Warning: Low Dissolved Oxygen (<5 mg/L) - Water may be unsafe for aquatic life."
    )
    
    return {
        "predicted_dissolved_oxygen": prediction,
        "safety_message": safety_message
    }

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8000)
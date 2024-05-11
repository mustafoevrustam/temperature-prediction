import torch
import numpy as np
import pandas as pd
from fastapi import FastAPI
from fastapi.responses import JSONResponse
from sklearn.preprocessing import MinMaxScaler


from src.temperature_forecast.model import LSTMModel
from src.schemas import TemperaturePredict

app = FastAPI()

forecast_model = LSTMModel(
    input_dim=1,
    hidden_dim=50,
    num_layers=2,
    output_dim=1
)
forecast_model.load_state_dict(torch.load('temperature_prediction_model.pth'))
forecast_model.eval()

scaler = MinMaxScaler(feature_range=(0, 1))


@app.get("/")
def health():
    return {"status": "ok"}


@app.post('/predict/temperature/')
def predict_temperature(inputs: TemperaturePredict):
    df = pd.DataFrame(inputs.temperature)
    _model_input_temperatures = scaler.fit_transform(df.values.reshape(-1, 1))
    _model_input_temperatures = np.array(_model_input_temperatures).reshape(1, len(inputs.temperature), 1)
    _model_input_temperatures = torch.from_numpy(_model_input_temperatures).float()

    with torch.no_grad():
        forecast = forecast_model(_model_input_temperatures)

    return JSONResponse({'status': 'success', 'predicted_temperature': scaler.inverse_transform(forecast).item()})

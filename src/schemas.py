from pydantic import BaseModel, conlist


class TemperaturePredict(BaseModel):
    temperature: conlist(float, min_length=60, max_length=60)

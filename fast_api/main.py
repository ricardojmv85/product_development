from fastapi import FastAPI
from pydantic import BaseModel

from typing import List
from enum import Enum

import numpy as np

app = FastAPI()


class Operations(str, Enum):
    divide = "divide"
    multiplicate = "multiplicate"
    addition = "addition"
    subtract = "subtract"

class InputList(BaseModel):
    input_list: List[float] = None


def operate(operation, input):
    if operation == 'addition':
        return np.sum(input)
    elif operation == 'multiplicate':
        return np.prod(input)
    elif operation == 'divide':
        temp_result = input[0]
        for divisor in input[1:]:
            temp_result /= divisor
        return temp_result
    else:
        temp_result = input[0]
        for divisor in input[1:]:
            temp_result -= divisor
        return temp_result

@app.get("/health")
def root():
    return {"message": "ALIVE"}

@app.post("/multiplicate")
def multiplicate(input: InputList):
    return {"result": operate('multiplicate', input.input_list)}

@app.post("/divide")
def divide(input: InputList):
    return {"result": operate('divide', input.input_list)}
    
@app.post("/addition")
def divide(input: InputList):
    return {"result": operate('addition', input.input_list)}

@app.post("/subtract")
def divide(input: InputList):
    return {"result": operate('subtract', input.input_list)}

@app.post("/operate/{operation}")
def operatev2(input: InputList, operation: Operations):
    return {"result": operate(operation.value, input.input_list)}
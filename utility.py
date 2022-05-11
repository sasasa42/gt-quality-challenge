import math  
from math import floor


def ageFlooring(age):
    age = floor(age)
    return  age

def reliefFlooring(relief):
    modified =  math.modf(relief)
    if  modified[0]<=0.5:
        relief = floor(relief)
        rounded = round(relief, 2)
    relief = round(relief, 2)
    return  relief
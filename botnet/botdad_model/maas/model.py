import sklearn
import numpy as np
from sklearn.externals import joblib 

class BOTDAD:
  def __init__(self):
    self.model = loaded_model = joblib.load('bot_dad_model.sav') 
    self.class_map = ['bot', 'clean']

  def evaluate_request(self, features):
    pred = self.model.predict(features)
    return self.class_map[pred[0]]


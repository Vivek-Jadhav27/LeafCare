import requests

# url = "http://127.0.0.1:8000/api/"
# files = {"image": open("D:/Codespeedy/Plant_Disease/dataset/valid/TomatoHealthy2.JPG", "rb")}
# response = requests.post(url, files=files)
# print(response.json())

import tensorflow as tf

try:
    model = tf.keras.models.load_model("detection/trained_plant_disease_model.keras")
    print("Model loaded successfully!")
except Exception as e:
    print("Error loading model:", e)

import os.path
from django.conf import settings
from django.shortcuts import render
from django.core.files.storage import default_storage
from rest_framework.response import Response  # ✅ Corrected Import
from rest_framework.decorators import api_view

from .keras_model import predict_disease

def home(request):
    return render(request, "home.html")

def predict(request):
    if request.method == "POST" and request.FILES.get("image"):
        image = request.FILES["image"]
        image_path = default_storage.save("uploads/" + image.name, image)
        path = os.path.join(settings.MEDIA_ROOT,image_path)
        prediction , confidence = predict_disease(path)

        return render(request, "result.html", {"image_url": image_path, "prediction": prediction , "confidence" : confidence})

    return render(request, "home.html", {"error": "Please upload an image!"})

@api_view(['POST'])
def predict_api(request):
    if "image" not in request.FILES:
        return Response({"error": "Please upload an image!"}, status=400)

    image = request.FILES["image"]
    image_path = default_storage.save("uploads/" + image.name, image)
    path = os.path.join(settings.MEDIA_ROOT, image_path)
    prediction ,confidence = predict_disease(path)
    return Response({"image_url": settings.MEDIA_URL + image_path, "prediction": prediction,"confidence" : confidence})

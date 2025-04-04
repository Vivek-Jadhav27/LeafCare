from django.urls import path
from .views import home, predict , predict_api

urlpatterns = [
    path('', home, name="home"),
    path('predict/', predict, name="predict"),
    path('predict_api/',predict_api,name="predict_api"),
]
# 🌿 LeafCare – AI-Powered Plant Disease Detection  

LeafCare is an AI-driven mobile application that helps users identify plant diseases through image classification. The system uses Deep Learning (CNNs) to analyze leaf images and provide real-time disease predictions, enabling early detection and better plant care.  

---

## 🚀 Features  
✅ **AI-Based Disease Detection** – Upload a leaf image for instant analysis  
✅ **Real-Time Predictions** – Uses a trained CNN model for high accuracy  
✅ **Flutter Mobile App** – Seamless user experience with a modern UI  
✅ **Django REST API** – Efficient backend for handling ML model inference  
✅ **Database Integration (Supabase)** – Stores user profiles, images, and predictions  

---

## 🏗️ Tech Stack  
### **Frontend (Mobile App)**  
- **Flutter (Dart)**  
- **Provider** for state management  

### **Backend (API & Machine Learning)**  
- **Django REST Framework**  
- **TensorFlow/Keras** (Deep Learning for plant disease detection)  
- **Pillow & OpenCV** for image preprocessing  

### **Database & Storage**  
- **Supabase (PostgreSQL)** – Stores user data, predictions, and images  
- **Firebase Storage** – Manages uploaded images  

---

## ⚙️ Setting Up the Project  
### **1️⃣ Clone the Repository**  
```sh
git clone https://github.com/Vivek-Jadhav27/LeafCare.git
cd LeafCare
```
### 2️⃣ Backend Setup (Django API)
```sh
cd plant_disease_api
python -m venv venv
venv\Scripts\activate
pip install -r requirements.txt
python manage.py migrate
python manage.py runserver 0.0.0.0:8000
Django API will be live at: http://0.0.0.0:8000/
```
###3️⃣ Frontend Setup (Flutter App)
```sh
cd leafcare
flutter pub get
flutter run
```

---





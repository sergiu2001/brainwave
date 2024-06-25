import json
import pandas as pd
import numpy as np
import tensorflow as tf
from keras import Sequential
from tensorflow.keras.models import Sequential
from tensorflow.keras.layers import Dense
from sklearn.preprocessing import OneHotEncoder
# Load JSON file
with open('Apps.json') as f:
    app_data = json.load(f)

# Convert JSON to DataFrame
df_apps = pd.DataFrame(app_data)

# Define the possible attributes, daily activities, and mental health questions
app_attributes = [
    'Going for a walk',
    'Reading a book',
    'Going out',
    'Working out',
    'Meditating',
    'Socializing',
    'Relaxing',
    'Working',
]

daily_activities = [
    'Home',
    'Work',
    'Public Place',
    'On the Go',
    'Happy',
    'Sad',
    'Anxious',
    'Stressed',
    'Calm',
    'Bored',
    'Excited',
    'Entertainment',
    'Communication',
    'Productivity',
    'Information',
    'Relaxation',
    'Habit',
    'Boredom',
    'Stress Relief',
    'Eating',
    'Exercising',
    'Commuting',
    'Working',
    'Relaxing',
    'Socializing',
    'Alone Time'
]

mental_health_questions = [
    'How was your overall mood today?',
    'How stressed did you feel today?',
    'How well did you sleep last night?',
    'How anxious did you feel today?',
    'How happy did you feel today?',
]

# Number of simulated reports
num_reports = 1000

# Parameters to ensure consistent feature length
max_apps = 5  # Maximum number of apps per report
app_feature_length = len(app_attributes) + 1 + df_apps['appType'].nunique()  # Attributes, usage, and one-hot appType
daily_activities_length = len(daily_activities)
mental_health_length = len(mental_health_questions)

# Initialize OneHotEncoder
encoder = OneHotEncoder(sparse_output=False)
encoder.fit(df_apps[['appType']])

# Function to generate a single report
def generate_report():
    report = {}
    
    # Randomly select apps and their details
    num_apps = np.random.randint(1, max_apps + 1)  # Random number of apps between 1 and max_apps
    selected_apps = df_apps.sample(num_apps)
    report['apps'] = []
    for _, row in selected_apps.iterrows():
        app = {
            'appPackageName': row['appPackageName'],
            'appType': row['appType'],
            'appUsage': np.random.uniform(0.1, 5.0),  # Random usage time between 0.1 and 5.0 hours
            'attributes': np.random.choice(app_attributes, size=np.random.randint(1, 4), replace=False).tolist()  # Random attributes
        }
        report['apps'].append(app)
    
    # Randomly select daily activities
    report['daily_activities'] = np.random.choice(daily_activities, size=np.random.randint(1, len(daily_activities)), replace=False).tolist()
    
    # Randomly rate mental health questions
    report['mental_health_ratings'] = {question: np.random.randint(1, 6) for question in mental_health_questions}
    
    return report

# Generate multiple reports
reports = [generate_report() for _ in range(num_reports)]

# Function to preprocess a report into a feature vector
def preprocess_report(report):
    features = []
    
    # Encode app details
    for app in report['apps']:
        app_type_df = pd.DataFrame([[app['appType']]], columns=['appType'])
        app_type_encoded = encoder.transform(app_type_df)[0]
        app_usage = app['appUsage']
        attributes_encoded = [1 if attr in app['attributes'] else 0 for attr in app_attributes]
        app_features = np.concatenate([app_type_encoded, [app_usage], attributes_encoded])
        features.extend(app_features)
    
    # Pad app features to ensure consistent length
    while len(features) < max_apps * app_feature_length:
        features.extend([0] * app_feature_length)
    if len(features) > max_apps * app_feature_length:
        features = features[:max_apps * app_feature_length]
    
    # Encode daily activities
    activities_encoded = [1 if activity in report['daily_activities'] else 0 for activity in daily_activities]
    features.extend(activities_encoded)
    
    # Encode mental health ratings
    ratings = [report['mental_health_ratings'][question] for question in mental_health_questions]
    features.extend(ratings)
    
    return features

# Preprocess all reports
dataset = np.array([preprocess_report(report) for report in reports])

# Labels (for demonstration purposes, we randomly assign positive or negative labels)
labels = np.random.randint(0, 2, size=(num_reports, 1))  # 0 for negative, 1 for positive

# Define the model using the Sequential API
model = Sequential([
    Dense(128, activation='relu', input_shape=(dataset.shape[1],)),
    Dense(64, activation='relu'),
    Dense(1, activation='sigmoid'),
])

# Compile the model
model.compile(optimizer='adam', loss='binary_crossentropy', metrics=['accuracy'])

# Train the model
model.fit(dataset, labels, epochs=10, batch_size=16)

# Save model in .keras format
#model.save('BrainHealth.keras')
#tf.saved_model.save(model, 'models')
model.export("models")

# Load the model in a new instance to ensure compatibility
#loaded_model = tf.keras.models.load_model('BrainHealth.keras')

# Convert model to TensorFlow Lite with input signature
converter = tf.lite.TFLiteConverter.from_saved_model('models') # path to the SavedModel directory
converter.target_spec.supported_ops = [tf.lite.OpsSet.TFLITE_BUILTINS]
converter.optimizations = [tf.lite.Optimize.DEFAULT]
tflite_model = converter.convert()

# Save the TFLite model
with open('BrainHealth.tflite', 'wb') as f:
    f.write(tflite_model)
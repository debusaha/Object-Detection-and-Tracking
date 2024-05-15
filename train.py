import os
import numpy as np
import tensorflow as tf
from keras.callbacks import ModelCheckpoint
from model import denseNet_model, unet_model
from data_importer import SemanticSegmentationDataGenerator 

# Define paths and parameters
image_dir = "C:/Users/itsde/OneDrive/git_repos/Object-Detection-and-Tracking/Trapping/images/"
mask_dir = "C:/Users/itsde/OneDrive/git_repos/Object-Detection-and-Tracking/Trapping/masks/"
img_size = (1024, 1024)
batch_size = 32
epochs = 30

# Get input image and mask paths
image_paths = sorted([
    os.path.join(image_dir, file_name)
    for file_name in os.listdir(image_dir)
    if file_name.endswith(".jpg")
])
mask_paths = sorted([
    os.path.join(mask_dir, file_name)
    for file_name in os.listdir(mask_dir)
    if file_name.endswith(".jpg")
])

# Split data into training and validation sets
validate_samples = 100
train_image_paths = image_paths[:-validate_samples]
train_mask_paths = mask_paths[:-validate_samples]
validate_image_paths = image_paths[-validate_samples:]
validate_mask_paths = mask_paths[-validate_samples:]

# Instantiate data Generators
train_data_generator = SemanticSegmentationDataGenerator(batch_size, img_size, train_image_paths, train_mask_paths)  
validate_data_generator = SemanticSegmentationDataGenerator(batch_size, img_size, validate_image_paths, validate_mask_paths) 

# Load model from model.py
model = denseNet_model(img_size)

# Compile model
model.compile(optimizer="adam", loss="sparse_categorical_crossentropy")

# Define callbacks
callbacks = [tf.keras.callbacks.ModelCheckpoint("SemanticSeg_PS_Particle.keras", save_best_only=True)]

# Train model
model.fit(train_data_generator, epochs=epochs, validation_data=validate_data_generator, callbacks=callbacks)

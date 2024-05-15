import os
import numpy as np
from keras_preprocessing.image import load_img, img_to_array
from tensorflow.keras.utils import Sequence

class SemanticSegmentationDataGenerator(Sequence):
    def __init__(self, batch_size, image_size, image_paths, mask_paths):
        self.batch_size = batch_size
        self.image_size = image_size
        self.image_paths = image_paths
        self.mask_paths = mask_paths
        self.n = len(mask_paths)

    def __len__(self):
        return self.n // self.batch_size

    def __getitem__(self, idx):
        batch_image_paths = self.image_paths[idx * self.batch_size: (idx + 1) * self.batch_size]
        batch_mask_paths = self.mask_paths[idx * self.batch_size: (idx + 1) * self.batch_size]

        batch_images = np.zeros((self.batch_size,) + self.image_size, dtype="uint8")
        batch_masks = np.zeros((self.batch_size,) + self.image_size, dtype="uint8")

        for i, (image_path, mask_path) in enumerate(zip(batch_image_paths, batch_mask_paths)):
            image = load_img(image_path, target_size=self.image_size, color_mode='grayscale')
            batch_images[i] = img_to_array(image)[:, :, 0] / 255.0

            mask = load_img(mask_path, target_size=self.image_size, color_mode='grayscale')
            batch_masks[i] = img_to_array(mask)[:, :, 0] / 255.0

        return batch_images, batch_masks

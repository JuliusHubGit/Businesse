#!/usr/bin/env python3
"""
Raspberry Pi Digital Photo Frame
Displays images from SD card with 30-second intervals
"""

import os
import time
import random
from pathlib import Path
import tkinter as tk
from PIL import Image, ImageTk
import json

class PhotoFrame:
    def __init__(self, config_file='config.json'):
        """Initialize the photo frame application"""
        # Load configuration
        self.config = self.load_config(config_file)
        
        # Set up paths
        self.image_folder = Path(self.config.get('image_folder', '/home/pi/Pictures'))
        self.interval = self.config.get('interval_seconds', 30)
        self.shuffle = self.config.get('shuffle', True)
        self.fullscreen = self.config.get('fullscreen', True)
        
        # Supported image formats
        self.image_extensions = {'.jpg', '.jpeg', '.png', '.gif', '.bmp'}
        
        # Get all images
        self.images = self.get_all_images()
        self.current_index = 0
        
        # Create GUI
        self.root = tk.Tk()
        self.root.title("Photo Frame")
        
        # Configure window
        if self.fullscreen:
            self.root.attributes('-fullscreen', True)
            # Exit fullscreen with Escape key
            self.root.bind('<Escape>', lambda e: self.root.attributes('-fullscreen', False))
            # Quit with 'q' key
            self.root.bind('q', lambda e: self.root.quit())
        
        # Get screen dimensions
        self.screen_width = self.root.winfo_screenwidth()
        self.screen_height = self.root.winfo_screenheight()
        
        # Create label for image display
        self.image_label = tk.Label(self.root, bg='black')
        self.image_label.pack(fill=tk.BOTH, expand=True)
        
        # Hide cursor in fullscreen mode
        if self.fullscreen:
            self.root.config(cursor='none')
    
    def load_config(self, config_file):
        """Load configuration from JSON file"""
        default_config = {
            'image_folder': '/home/pi/Pictures',
            'interval_seconds': 30,
            'shuffle': True,
            'fullscreen': True
        }
        
        if os.path.exists(config_file):
            try:
                with open(config_file, 'r') as f:
                    user_config = json.load(f)
                    default_config.update(user_config)
            except Exception as e:
                print(f"Error loading config: {e}. Using defaults.")
        
        return default_config
    
    def get_all_images(self):
        """Get list of all image files from the folder"""
        if not self.image_folder.exists():
            print(f"Creating image folder: {self.image_folder}")
            self.image_folder.mkdir(parents=True, exist_ok=True)
            return []
        
        images = []
        for ext in self.image_extensions:
            images.extend(self.image_folder.glob(f'*{ext}'))
            images.extend(self.image_folder.glob(f'*{ext.upper()}'))
        
        images = sorted(images)
        
        if self.shuffle:
            random.shuffle(images)
        
        if not images:
            print(f"No images found in {self.image_folder}")
            print(f"Supported formats: {', '.join(self.image_extensions)}")
        
        return images
    
    def resize_image(self, image_path):
        """Resize image to fit screen while maintaining aspect ratio"""
        try:
            img = Image.open(image_path)
            
            # Get original dimensions
            img_width, img_height = img.size
            
            # Calculate scaling factor
            width_ratio = self.screen_width / img_width
            height_ratio = self.screen_height / img_height
            scale_factor = min(width_ratio, height_ratio)
            
            # Calculate new dimensions
            new_width = int(img_width * scale_factor)
            new_height = int(img_height * scale_factor)
            
            # Resize image
            img = img.resize((new_width, new_height), Image.Resampling.LANCZOS)
            
            return ImageTk.PhotoImage(img)
        
        except Exception as e:
            print(f"Error loading image {image_path}: {e}")
            return None
    
    def show_next_image(self):
        """Display the next image"""
        if not self.images:
            # No images available, check again
            self.images = self.get_all_images()
            if not self.images:
                # Still no images, show message and retry later
                self.root.after(self.interval * 1000, self.show_next_image)
                return
        
        # Get current image
        image_path = self.images[self.current_index]
        
        # Load and display image
        photo = self.resize_image(image_path)
        
        if photo:
            self.image_label.configure(image=photo)
            self.image_label.image = photo  # Keep a reference
            print(f"Displaying: {image_path.name}")
        
        # Move to next image
        self.current_index = (self.current_index + 1) % len(self.images)
        
        # Re-scan folder periodically (every 10 images)
        if self.current_index == 0:
            new_images = self.get_all_images()
            if len(new_images) != len(self.images):
                print(f"Updated image list: {len(new_images)} images found")
                self.images = new_images
        
        # Schedule next update
        self.root.after(self.interval * 1000, self.show_next_image)
    
    def run(self):
        """Start the photo frame"""
        print(f"Starting Photo Frame...")
        print(f"Image folder: {self.image_folder}")
        print(f"Interval: {self.interval} seconds")
        print(f"Number of images: {len(self.images)}")
        print(f"Fullscreen: {self.fullscreen}")
        
        if self.fullscreen:
            print("Press 'Escape' to exit fullscreen, 'q' to quit")
        
        # Show first image
        self.show_next_image()
        
        # Start the GUI event loop
        self.root.mainloop()

if __name__ == '__main__':
    frame = PhotoFrame()
    frame.run()

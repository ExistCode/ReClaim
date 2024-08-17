import tkinter as tk
from tkinter import Label, Button, Frame, Listbox, Scrollbar, messagebox
from collections import Counter
from PIL import Image, ImageTk
import cv2
import qrcode
from lobe import ImageModel
from cryptography.fernet import Fernet
import os
import pigpio
import json
import uuid  

# Load Lobe TF model
model = ImageModel.load('/home/sanjivrajah./dataset')

# Global variables
recycled_items = []
MAX_DISPLAY_ITEMS = 5  # Number of most recent items to display

cap = None  # Initialize cap to None
qr_expired = False
qr_code_displayed = False
session_active = False
scan_active = False
last_tick = 0
timer_running = False

# Encryption key (store and load this securely)
key = Fernet.generate_key()
cipher = Fernet(key)

# GPIO setup
pi = pigpio.pi()
button1_pin = 2  # Pin for the first button
button2_pin = 17  # Pin for the second button

pi.set_mode(button1_pin, pigpio.INPUT)
pi.set_mode(button2_pin, pigpio.INPUT)

pi.set_pull_up_down(button1_pin, pigpio.PUD_UP)
pi.set_pull_up_down(button2_pin, pigpio.PUD_UP)

def toggle_fullscreen(event=None):
    global is_fullscreen
    is_fullscreen = not is_fullscreen
    root.attributes("-fullscreen", is_fullscreen)
    return "break"

def end_fullscreen(event=None):
    global is_fullscreen
    is_fullscreen = False
    root.attributes("-fullscreen", False)
    return "break"

def create_gui():
    global preview_label, captured_img_label, qr_label, item_frame, total_count_label, item_listbox, timer_label, message_label
    global start_session_button, scan_item_button, done_button, exit_button, exit_program_button

    # Main frame to center content
    main_frame = Frame(root, bg='#E8F5E9')
    main_frame.pack(expand=True)

    # HomePage Welcome Message
    welcome_label = Label(main_frame, text="Welcome to Reclaim", bg='#E8F5E9', font=("Arial", 24, 'bold'), fg='#388E3C')
    welcome_label.grid(row=0, column=0, columnspan=2, pady=20)

    # Left side: Camera preview
    left_frame = Frame(main_frame, bg='#E8F5E9')
    left_frame.grid(row=1, column=0, padx=20, pady=20, sticky='n')

    preview_label = Label(left_frame, bg='#E8F5E9')
    preview_label.pack()

    # Right side: Controls and QR code display
    right_frame = Frame(main_frame, bg='#E8F5E9')
    right_frame.grid(row=1, column=1, padx=20, pady=20, sticky='n')

    captured_img_label = Label(right_frame, bg='#E8F5E9')
    captured_img_label.pack(pady=10)

    # Message Label for displaying messages
    message_label = Label(right_frame, text="", bg='#E8F5E9', font=("Arial", 14, 'bold'), fg='#D32F2F')
    message_label.pack(pady=10)

    # QR code display on QR page (Left side)
    qr_label = Label(left_frame, bg='#E8F5E9')
    qr_label.pack(pady=10)

    # Frame for item list and total count
    item_frame = Frame(right_frame, bg='#E8F5E9')
    item_frame.pack(pady=10)
    
    total_count_label = Label(item_frame, text="Total Items Recycled: 0", bg='#E8F5E9', font=("Arial", 14, 'bold'), fg='#388E3C')
    total_count_label.pack(pady=5)

    item_listbox = Listbox(item_frame, height=5, width=30, font=("Arial", 12))
    item_listbox.pack(side=tk.LEFT, fill=tk.BOTH)

    scrollbar = Scrollbar(item_frame, orient="vertical")
    scrollbar.config(command=item_listbox.yview)
    scrollbar.pack(side=tk.RIGHT, fill=tk.Y)

    item_listbox.config(yscrollcommand=scrollbar.set)

    # Timer label for QR code expiration
    timer_label = Label(right_frame, text="", bg='#E8F5E9', font=("Arial", 14, 'bold'), fg='#D32F2F')

    # Buttons
    button_frame = Frame(right_frame, bg='#E8F5E9')
    button_frame.pack(pady=10)

    start_session_button = Button(button_frame, text="Start Recycling Session", command=start_session, bg='#388E3C', fg='white', font=("Arial", 14, 'bold'), width=25)
    start_session_button.pack(pady=5)

    scan_item_button = Button(button_frame, text="Scan Item", command=capture_photo, bg='#1976D2', fg='white', font=("Arial", 14, 'bold'), width=25)
    
    done_button = Button(button_frame, text="Done", command=end_session, bg='#FBC02D', fg='white', font=("Arial", 14, 'bold'), width=25)
    
    exit_button = Button(button_frame, text="Exit Session", command=exit_session, bg='#D32F2F', fg='white', font=("Arial", 14, 'bold'), width=25)

    exit_program_button = Button(right_frame, text="Exit Program", command=exit_program, bg='#D32F2F', fg='white', font=("Arial", 14, 'bold'), width=25)
    exit_program_button.pack(side=tk.BOTTOM, pady=10)

def update_item_display():
    # Clear the current list
    item_listbox.delete(0, tk.END)
    
    # Get the item counts
    item_counts = Counter(recycled_items)
    
    # Display total count
    total_count = len(recycled_items)
    total_count_label.config(text=f"Total Items Recycled: {total_count}")
    
    # Display most recent unique items (up to MAX_DISPLAY_ITEMS)
    unique_recent_items = []
    for item in reversed(recycled_items):
        if item not in unique_recent_items:
            unique_recent_items.append(item)
        if len(unique_recent_items) == MAX_DISPLAY_ITEMS:
            break
    
    for item in unique_recent_items:
        count = item_counts[item]
        item_listbox.insert(tk.END, f"{item} (x{count})")

# Function to update the webcam preview
def update_preview():
    if cap is not None and cap.isOpened():
        ret, frame = cap.read()
        if ret:
            img = Image.fromarray(cv2.cvtColor(frame, cv2.COLOR_BGR2RGB))
            img = img.resize((300, 300))
            img_tk = ImageTk.PhotoImage(img)
            preview_label.config(image=img_tk)
            preview_label.image = img_tk
        root.after(10, update_preview)

# Function to capture photo and make prediction
def capture_photo():
    global scan_active
    scan_active = True
    if cap is not None and cap.isOpened():
        ret, frame = cap.read()
        if ret:
            # Save the captured image
            image_path = 'captured_image.jpg'
            cv2.imwrite(image_path, frame)

            # Display captured image
            img = Image.fromarray(cv2.cvtColor(frame, cv2.COLOR_BGR2RGB))
            img = img.resize((150, 150))
            img_tk = ImageTk.PhotoImage(img)
            captured_img_label.config(image=img_tk)
            captured_img_label.image = img_tk

            # Run prediction
            result = model.predict_from_file(image_path)
            prediction = result.prediction

            if prediction == "Empty":
                message_label.config(text="Please put an item in the bin")
            elif prediction == "Cannot":
                message_label.config(text="Item not recognizable")
            else:
                recycled_items.append(prediction)
                update_item_display()
                message_label.config(text="")
    scan_active = False

def show_message(message):
    messagebox.showinfo("Recycle Bin System", message)

def generate_qr_code(data):
    qr = qrcode.QRCode(
        version=1,
        error_correction=qrcode.constants.ERROR_CORRECT_L,
        box_size=10,
        border=4,
    )
    qr.add_data(data)
    qr.make(fit=True)
    img = qr.make_image(fill='black', back_color='white')
    return img

def start_session():
    global cap, qr_expired, qr_code_displayed, session_active, scan_active
    
    # Initialize or reopen the camera
    if cap is None or not cap.isOpened():
        cap = cv2.VideoCapture(0)
    
    # Clear previous content from frames
    preview_label.pack_forget()
    captured_img_label.pack_forget()
    item_frame.pack_forget()
    qr_label.pack_forget()
    timer_label.pack_forget()
    scan_item_button.pack_forget()
    done_button.pack_forget()
    exit_button.pack_forget()
    exit_program_button.pack_forget()

    # Clear the list of recycled items and update display
    recycled_items.clear()
    update_item_display()
    
    # Show the preview and captured image labels
    preview_label.pack(pady=10)
    # captured_img_label.pack(pady=10)
    item_frame.pack(pady=10)
    
    # Hide session buttons initially
    start_session_button.pack_forget()
    exit_program_button.pack_forget()
    
    # Show the scan item and done buttons
    # scan_item_button.pack(pady=5)
    # done_button.pack(pady=5)
    # exit_button.pack(pady=5)
    
    qr_expired = False
    qr_code_displayed = False
    session_active = True
    scan_active = False
    stop_timer()
    
    # Start updating the preview
    update_preview()
    captured_img_label.config(image=None)

def end_session():
    global qr_code_displayed, session_active, scan_active

    # Disable session buttons
    scan_item_button.config(state=tk.DISABLED)
    done_button.config(state=tk.DISABLED)

    # Hide live preview and captured image
    preview_label.pack_forget()
    captured_img_label.pack_forget()

    # Hide Scan Item and Done buttons
    scan_item_button.pack_forget()
    done_button.pack_forget()

    # Create a unique ID for the session
    session_id = str(uuid.uuid4())  # Generate a unique ID

    # Count items in each category
    item_counts = Counter(recycled_items)
    plastic_count = item_counts.get("Plastic", 0)
    cans_count = item_counts.get("Cans", 0)
    cartons_count = item_counts.get("Cartons", 0)

    # Create JSON data
    qr_data = {
        "id": session_id,
        "message": f"{plastic_count}, {cans_count},{cartons_count}"
    }

    # Convert JSON data to string
    qr_data_json = json.dumps(qr_data)

    encrypted_data = cipher.encrypt(qr_data_json.encode())

    # Commenting out the encryption
    qr_img1 = generate_qr_code(encrypted_data)

    qr_img = generate_qr_code(qr_data_json) 
    qr_img = qr_img.resize((250, 250)) 
    qr_img_tk = ImageTk.PhotoImage(qr_img)
    qr_label.config(image=qr_img_tk)
    qr_label.image = qr_img_tk

    # Show the QR code and exit button
    qr_label.pack(pady=10, side=tk.LEFT, anchor='n')

    qr_code_displayed = True
    session_active = False

    # Hide the label 
    message_label.pack_forget()

    # Start the expiration timer
    start_qr_timer()


def start_qr_timer():
    global timer_running
    timer_running = True
    update_timer(25)

def stop_timer():
    global timer_running
    timer_running = False
    timer_label.pack_forget()

def update_timer(seconds):
    global timer_running
    if seconds > 0 and timer_running:
        timer_label.config(text=f"QR Code expires in {seconds} seconds")
        timer_label.pack()  # Show the timer label
        root.after(1000, update_timer, seconds - 1)  # Call this function again after 1 second
    else:
        if timer_running:
            expire_qr_code()

def expire_qr_code():
    global qr_expired
    qr_expired = True
    back_to_home()

def back_to_home():
    global qr_code_displayed, cap, session_active, scan_active
    if qr_code_displayed and not qr_expired:
        qr_label.config(text="QR Code Expired!")
    qr_code_displayed = False
    qr_label.pack_forget()
    timer_label.pack_forget()
    preview_label.pack_forget()
    captured_img_label.pack_forget()
    captured_img_label.config(image=None)
    item_frame.pack_forget()
    scan_item_button.pack_forget()
    done_button.pack_forget()
    exit_button.pack_forget()
    start_session_button.pack(pady=5)
    # exit_program_button.pack(side=tk.BOTTOM, pady=10)
    if cap:
        cap.release()
        cap = None
    session_active = False
    scan_active = False
    stop_timer()

# Function to handle exiting the session
def exit_session():
    back_to_home()

# Function to handle exiting the program
def exit_program():
    root.quit()

# Button callback function with debouncing logic
def button_callback(gpio, level, tick):
    global session_active, scan_active, last_tick
    
    # Ignore presses within 200ms of the last press
    if tick - last_tick < 200000:
        return
    
    last_tick = tick
    if gpio == button1_pin:
        if not session_active:
            start_session()
        elif session_active and not scan_active:
            capture_photo()
    elif gpio == button2_pin:
        if qr_code_displayed:
            exit_session()  # Exit the session and return to the home screen
        elif session_active and not scan_active:
            end_session()  # Ends the session
        elif not session_active:
            exit_program()  # Exits the program if no session is active

# Set up GPIO callbacks
pi.callback(button1_pin, pigpio.FALLING_EDGE, button_callback)
pi.callback(button2_pin, pigpio.FALLING_EDGE, button_callback)

# Create GUI
root = tk.Tk()
root.title("Recycle Bin System")
root.configure(bg='#E8F5E9')

# Fullscreen setup
is_fullscreen = True
root.attributes("-fullscreen", True)
root.bind("<F11>", toggle_fullscreen)
root.bind("<Escape>", end_fullscreen)

create_gui()

root.mainloop()

# Cleanup GPIO
pi.stop()

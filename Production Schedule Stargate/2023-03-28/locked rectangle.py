import tkinter as tk
import random

# Create a list of 6 random colors
colors = [f'#{random.randint(0, 0xFFFFFF):06x}' for _ in range(6)]

# Define canvas_stg scrolling function
def scroll_canvas(event):
    # Get current horizontal scroll position
    scroll_pos = canvas.xview()[0]

    # Calculate new scroll position based on scroll amount
    scroll_amount = event.delta / 120.0
    new_pos = scroll_pos - (scroll_amount * 0.1)

    # Set new scroll position
    canvas.xview_moveto(new_pos)

    # Move all rectangles except black one by the same amount
    for rect_id in rect_ids:
        if rect_id != black_rect:
            canvas.move(rect_id, -event.delta, 0)

# Create tkinter window and canvas_stg
root = tk.Tk()
canvas = tk.Canvas(root, width=600, height=400)
canvas.pack(fill='both', expand=True)

# Add 6 random colored rectangles to canvas_stg
rect_ids = []
for i in range(6):
    color = colors[i]
    x1, y1 = random.randint(50, 500), random.randint(50, 300)
    x2, y2 = x1 + random.randint(50, 150), y1 + random.randint(50, 100)
    rect_id = canvas.create_rectangle(x1, y1, x2, y2, fill=color)
    rect_ids.append(rect_id)

# Add black rectangle to center of canvas_stg
x1, y1 = 250, 150
x2, y2 = 350, 250
black_rect = canvas.create_rectangle(x1, y1, x2, y2, fill='black')

# Bind horizontal scroll to canvas_stg
canvas.bind('<MouseWheel>', scroll_canvas)

# Start tkinter event loop
root.mainloop()

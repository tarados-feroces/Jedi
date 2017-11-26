#!/usr/bin/env python

from filestream import FileStream as ofstream
from filestream import endl

from math import floor

import os
import sys

try:
    import Tkinter as tk

except:
    print "I can't find module 'Tkinter'. Try this:"
    print "    sudo apt-get install python-tk python3-tk"

try:
    from PIL import Image, ImageTk
except:
    print "I can't find module 'PIL'. Try this:"
    print "    sudo pip install pillow"


def fix_path(path):
    where_am_i = os.getcwd()
    if path[0] != '/':
        path = os.path.join(where_am_i, path)
    return path




class ExampleApp(tk.Tk):

    current_index_photo = 0

    scale = (1, 1)

    x = 0
    y = 0
    rect = None
    start_x = None
    start_y = None
    end_x = None
    end_y = None

    def __init__(self, filenames_file, report_file):
        tk.Tk.__init__(self)

        size = (self.winfo_screenwidth() * 0.8, self.winfo_screenheight() * 0.8)

        self.width, self.height = int(size[0]), int(size[1])

        self.ratio = float(self.width) / self.height
        print self.ratio

        self.title('Object selecter')

        self.filenames_file = filenames_file
        self.filenames = ofstream(filenames_file).as_list()
        self.report_file = ofstream(report_file, 'a')

        self.filenames = sorted(self.filenames)

        print self.filenames[0:3]


        self.canvas = tk.Canvas(self, width=self.width, height=self.height, cursor="cross", bg="lightblue")
        self.canvas.pack(side="top", fill="both", expand=True)

        self.canvas.bind("<ButtonPress-1>", self.on_button_press)
        self.canvas.bind("<B1-Motion>", self.on_move_press)
        self.canvas.bind("<Motion>", self.on_move)
        self.canvas.bind("<ButtonRelease-1>", self.on_button_release)

        self.bind("<Tab>", self.exit)
        self.bind("<space>", self.next)

        self.draw_image()


    def draw_image(self):
    	self.canvas.delete('y-line')
    	self.canvas.delete('x-line')
    	self.canvas.delete('rect')

    	if not os.path.isfile(self.filenames[0]):
    		self.filenames = self.filenames[1:]
        self.image = Image.open(self.filenames[0])

        im_width, im_height = self.image.size
        ratio = float(im_width) / float(im_height)

        if ratio > self.ratio:
            self.coef = float(im_width) / float(self.width)
            size = (self.width, int(floor(im_height / self.coef)))

        if ratio < self.ratio:
            self.coef = float(im_height) / float(self.height)
            size = (int(floor(im_width / self.coef)), self.height)

        if ratio == self.ratio:
            self.coef = float(im_width) / float(self.width)
            size = (self.width, self.height)

        print "coef is {}".format(self.coef)

        self.resized = self.image.resize(size, Image.ANTIALIAS)
        self.tk_image = ImageTk.PhotoImage(self.resized)

        self.canvas.create_image(0, 0, anchor="nw", image=self.tk_image, tags='image')
        self.X_line = self.canvas.create_line(0,0,0,0,fill='red',width=2,dash=(5,3), tags='x-line')
        self.Y_line = self.canvas.create_line(0,0,0,0,fill='red',width=2,dash=(5,3), tags='y-line')


    def on_button_press(self, event):
        # save mouse drag start position
        self.start_x = event.x
        self.start_y = event.y

        #one rectangle
        if not self.rect:
            self.rect = self.canvas.create_rectangle(self.x, self.y, 1, 1, tags='rect')

    def on_move(self, event):
    	curX, curY = event.x, event.y
        self.canvas.coords(self.X_line, curX, 0, curX, self.height)
        self.canvas.coords(self.Y_line, 0, curY, self.width, curY)

    def on_move_press(self, event):
        curX, curY = (event.x, event.y)
        self.canvas.coords(self.rect, self.start_x, self.start_y, curX, curY)
        

    def on_button_release(self, event):
        self.end_x, self.end_y = (event.x, event.y)

    def f(self, x):
    	return int(float(x) * float(self.coef))


    def next(self, event):
        self.rect = None
        
        self.report_file << "{name} 1 {x} {y} {w} {h}".format(
            name=self.filenames[0],
            x=self.f(min(self.start_x, self.end_x)),
            y=self.f(min(self.start_y, self.end_y)),
            w=self.f(abs(self.end_x-self.start_x)),
            h=self.f(abs(self.end_y-self.start_y))
        ) << endl

        self.filenames = self.filenames[1:]

        if not self.filenames:
            self.report_file.close()
            self.destroy()
        else:
        	self.draw_image()

    def exit(self, event):
    	self.report_file.close()

    	file = ofstream(self.filenames_file, 'w')
    	file << self.filenames
    	file.close()
    	self.destroy()



if __name__ == "__main__":

    filenames_file = fix_path(sys.argv[1])

    report = fix_path(sys.argv[2])

    app = ExampleApp(filenames_file, report)
    app.mainloop()

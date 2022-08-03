#!/usr/local/bin/python3
import os, shutil, pathlib
import tkinter as tk
from queue import Queue, Empty
from threading import Event

done = Event()
queue = Queue()

class Main(tk.Frame):

    def __init__(self,master=None):
        tk.Frame.__init__(self,master)
        self.list = []
        self.dateiendungen = []
        self.path= tk.StringVar()
        self.datendungen= tk.StringVar()
        self.hidden = tk.IntVar()
        self.createwidgets()
        self.pack(expand=True, fill=tk.BOTH)

    def createwidgets(self):
        self.list.append(tk.Label(self,relief=tk.GROOVE,font="Arial 12 bold", text="Mit diesem Programm können Sie Ihre Dateien sortieren"))
        self.list.append(tk.Label(self,font="Arial 12", text="Pfad eingeben:"))

        #Entry for Path
        self.entry_path = tk.Entry(self, textvariable=self.path)
        self.list.append(self.entry_path)
        self.entry_path.bind('<Return>', self.onEnter)


        self.list.append(tk.Label(self,font="Arial 12", text="Dateiendungen mit Kommas(,) getrennt:"))

        #Entry for Dateiendungen
        self.entry_datendungen = tk.Entry(self, textvariable=self.datendungen)
        self.list.append(self.entry_datendungen)
        self.entry_datendungen.bind('<Return>', self.onEnter)

        for i,item in enumerate(self.list):
            item.grid(row=i,column=0, sticky= tk.W+tk.E, pady=2)

        #Button zum starten
        self.enterbutton = tk.Button(self, font="Arial 8", text="Enter", width=2, height=1, command=self.buttonPressed)
        self.list.append(self.enterbutton)
        self.enterbutton.grid(row=5, column=0, sticky=tk.E+tk.W, pady=10)

        #Optionsteil
        self.options = tk.Label(self,font="Arial 10", text="Options: ")
        self.list.append(self.options)
        self.options.grid(row=6, column=0, sticky=tk.W)

        self.checkhidden = tk.Checkbutton(self,font="Arial 10", text="Hiddenfolder: ", variable=self.hidden)
        self.list.append(self.checkhidden)
        self.checkhidden.grid(row=6, column=0, padx=3)

        self.chosenpath = tk.Label(self,font="Arial 10", text="Gewählter Pfad: ")
        self.list.append(self.chosenpath)
        self.chosenpath.grid(row=7, column=0, sticky=tk.W)

        self.dateiendungen = tk.Label(self,font="Arial 10", text="Gewählte Dateiendungen: ")
        self.list.append(self.dateiendungen)
        self.dateiendungen.grid(row=8, column=0, sticky=tk.W)

    def buttonPressed(self):
        if os.path.exists(self.path.get()) and self.entry_datendungen.get() != "":
            queue.put(self.sort)

    def onEnter(self,event):
        queue.put(self.updatelabel)

    def updatelabel(self):
        self.chosenpath["text"] = "Gewählter Pfad: %s" % self.path.get()
        self.dateiendungen["text"] = "Gewählte Dateiendung: %s" % self.datendungen.get()

    def sort(self):
        path = self.path.get() if self.path.get()[-1] == "/" else self.path.get() + "/"
        os.chdir(path)
        suffixes = self.datendungen.get().split(",")
        dateien = [datei for datei in os.listdir() for suffix in suffixes if datei.endswith(suffix) and not os.path.isdir(path+datei)]
        if dateien == []:
            return

        to_handle = [pathlib.Path(path+datei).suffix for datei in dateien]
        if not self.hidden.get():
            tmplist = [handle[1:] for idx,handle in enumerate(to_handle)]
            to_handle[:] = tmplist

        for i in range(len(to_handle)):
            if not os.path.isdir(to_handle[i]):
                os.mkdir(path+to_handle[i]) #erstelle Ordner mit Name der Endung
            shutil.move(path+dateien[i],path+to_handle[i])
        
def eventloop(root):
    if not done.is_set():
        try:
            while True:
                func = queue.get_nowait()
                func()
        except Empty:
            pass
        root.after(100, lambda: eventloop(root))

if __name__ == "__main__":
    root = tk.Tk()
    root.title("Organize v.0.1")
    #root.iconbitmap("book-icon.ico")
    root.minsize(355,400)
    root.maxsize(355,200)
    main = Main(root)
    eventloop(root)
    root.mainloop()



#!/usr/bin/python3

import tkinter as tk
import os, random
from threading import Thread, Event, Timer
from queue import Queue, Empty

FORTUNE_DIR = "/usr/share/games/fortunes"
done = Event()
queue = Queue()

class Main(tk.Frame):
    def __init__(self,master=None):
        os.chdir(FORTUNE_DIR)
        #Main fillt kompletten root
        tk.Frame.__init__(self,master)
        self.createWidgets()
        self.start_thread_savefortunes()

        self.selected_categories = []
        self.dictionary = {} #category(key) -> fortune(list)  ++for each category++ 
        self.actual_available_fortunes = []

        self.selected = 0 #würde resourcenverschw sein wenn man immer laenge von selected_categories berechnet 
        self.count_fortunes = 0
        
        self.pack(expand=True,fill=tk.BOTH)

    def info_Window(self):
        win = tk.Toplevel(self)
        display_label = tk.Label(win, font="Arial 12 bold", text="Usage:\n\nSelect Categories to get fortunes from.\n\nIf you like specific words in the fortune type into Entryfield and press <Enter>.")
        display_label.pack()

    def createWidgets(self):
        #Buttons
        button_frame = tk.Frame(self, relief=tk.GROOVE, pady=2, borderwidth=2)
        button_frame.pack(fill=tk.X, side=tk.TOP)

        button_fortune = tk.Button(button_frame,text="Fortune", command=lambda: self.start_thread_choosefortune())
        button_fortune.pack(side=tk.LEFT, padx=2)

        button_reset = tk.Button(button_frame,text="Reset", command=lambda: self.reset())
        button_reset.pack(side=tk.LEFT, padx=2)

        button_quit = tk.Button(button_frame,text="Quit", command=self._root().destroy)
        button_quit.pack(side=tk.LEFT, padx=2)

        button_question = tk.Button(button_frame, text="?", command=self.info_Window)
        button_question.pack(side=tk.LEFT, padx=2)

        #Basic Frame
        basic_frame = tk.Frame(self, pady=2, borderwidth=2)
        basic_frame.pack(fill=tk.BOTH,expand = True)

        #leftframe
        leftframe = tk.Frame(basic_frame)
        leftframe.pack(side=tk.LEFT,fill = tk.BOTH)

        #Entry in leftframe
        entry_frame = tk.Frame(leftframe)
        entry_frame.pack(side=tk.TOP, fill=tk.X)

        self.entry = tk.Entry(entry_frame)
        self.entry.pack(fill=tk.X)
        self.entry.bind("<Return>", self.onEnterPressed)

        #Label
        label_frame = tk.Frame(leftframe)
        label_frame.pack(side = tk.BOTTOM,anchor = "w")

        self.label = tk.Label(label_frame, text="43/43 Categories\n15256/15256 Fortunes", font="Arial 12")
        self.label.pack(anchor="s")

        #Listbox in leftframe
        listbox_frame = tk.Frame(leftframe)
        listbox_frame.pack(side = tk.LEFT ,fill = tk.BOTH)

        self.listbox = tk.Listbox(listbox_frame, bg="lightgrey", selectbackground="SteelBlue1")
        self.listbox["selectmode"] = tk.EXTENDED
        self.listbox.bind('<<ListboxSelect>>',self.onItemSelect)
        self.listbox.pack(side=tk.LEFT,fill = tk.Y)

        scrollbar = tk.Scrollbar(listbox_frame)
        scrollbar.pack(side=tk.LEFT, fill=tk.Y)
        scrollbar["command"] = self.listbox.yview
        self.listbox["yscrollcommand"] = scrollbar.set
        self.save_fortunescategories()

        #Text
        text_frame = tk.Frame(basic_frame, height=1200)
        text_frame.pack(fill=tk.BOTH)

        self.text = tk.Text(text_frame, font="Arial 12",height = 1200)
        self.text.pack(fill=tk.BOTH)

    def onEnterPressed(self,event):        
        tmplist = [fortune for idx, fortune in enumerate(self.actual_available_fortunes) if self.entry.get() in fortune]
        self.actual_available_fortunes[:] = tmplist
        queue.put(self.updatelabel)

    #Listbox Selection Handler
    def onItemSelect(self,event):
        #copy of onEnterPressed for better behaviour
        self.actual_available_fortunes = [fortune for idx, fortune in enumerate(self.actual_available_fortunes) if self.entry.get() in fortune]
        wid = event.widget
        self.selected = len(wid.curselection())
        client_selected = wid.curselection() #tuple
        self.selected_categories = [self.categorylist[idx] for idx in client_selected]
        self.get_necessary_fortunes()
        queue.put(self.updatelabel)
    
    def get_necessary_fortunes(self):
        #Fallunterscheidung und Vorbereitung von jeweiligen fortunes
        if self.selected > 0:
                self.actual_available_fortunes = [fortune for idx,key in enumerate(self.dictionary) 
                                                for count,fortune in enumerate(self.dictionary[key]) if key in self.selected_categories]
        else:
                self.actual_available_fortunes = [fortune for idx,key in enumerate(self.dictionary) 
                                                for count,fortune in enumerate(self.dictionary[key])]

    #reset button functionality
    def reset(self):
        self.listbox.select_clear(0,tk.END)
        self.text.delete("1.0",tk.END)
        self.selected = len(self.categorylist)
        self.actual_available_fortunes = [fortune for idx,key in enumerate(self.dictionary) 
                                            for count,fortune in enumerate(self.dictionary[key])]
        queue.put(self.updatelabel)

    #Category counter
    def save_fortunescategories(self):
        self.categorylist = [dateiname for dateiname in os.listdir(".") #self.categorylist is declared here, should be changed for readablity
                    if not dateiname.endswith(".dat") and not dateiname.endswith(".u8")
                    and dateiname not in "de" and dateiname not in "off"]
        for category in self.categorylist:
            self.listbox.insert(tk.END,category)

    #Label Updatefunction
    def updatelabel(self):
        self.label["text"] = "%d/%d Categories\n%d/%d Fortunes"%(self.selected,len(self.categorylist),len(self.actual_available_fortunes),self.count_fortunes)

    #Save all fortunes in self.actual_available_fortunes
    def start_thread_savefortunes(self):
        Thread(target=self.save_fortunes).start()

    def save_fortunes(self):
        queue.put(self.all_fortunes)

    def all_fortunes(self):
        for idx in range(len(self.categorylist)):
            tmplist = []
            tmplist.extend(open(self.categorylist[idx]).read().split("\n%\n"))
            self.count_fortunes += len(tmplist)
            self.dictionary.update({self.categorylist[idx]: tmplist})
        self.actual_available_fortunes = [fortune for idx,key in enumerate(self.dictionary) for count,fortune in enumerate(self.dictionary[key])]

    #Fortune Button, Generation of 1 random fortune
    def start_thread_choosefortune(self):
        Thread(target=self.choosefortune).start()

    def choosefortune(self):
        queue.put(self.random_fortune)

    def random_fortune(self):
        self.text.delete("1.0",tk.END)
        if self.actual_available_fortunes:
            fortune = random.choice(self.actual_available_fortunes)
            self.text.insert(tk.END,fortune)

def event_loop(root):
    if not done.is_set():
        try:
            while True:
                func = queue.get_nowait()
                func()
        except Empty:
            pass
        root.after(100, lambda: event_loop(root))
        
if __name__ == "__main__":
    root = tk.Tk()
    root.minsize(800,300)
    root.maxsize(1200,600)
    root.title("tkFortune")
    main = Main(root)
    event_loop(root)
    root.mainloop()
    done.set()
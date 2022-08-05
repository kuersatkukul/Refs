#!/usr/bin/python3.9
import tkinter as tk
from tkgameutil import KeyPress
from threading import Event, Thread, Lock
from queue import Queue, Empty
import time
import math
from random import randrange,choice



done = Event()
queue = Queue()
lock = Lock()
lock2 = Lock()
lock3 = Lock()
remainingwait = 0

def eventloop(root):
      if not done.is_set():
        try:
            while True: # drain the queue
                fun = queue.get_nowait()
                fun()
        except Empty:
            pass
        # do again after 100 msecs
        root.after(50, lambda: eventloop(root))

def gameloop(root,fps=25):
    main = Main(root)
    waittimems = int((1/fps)*1000) # default 40 ms
    def gameloop():
        if not done.is_set():
            start = time.time()
            main.tick() # progress and display
            duration = int((time.time()-start)*1000)
            remainingwait = int(waittimems-duration)
            if remainingwait < 0:
                print("tick too slow...")
                remainingwait = 0
            # tup = (duration, remainingwait, time.time()%100)
            # print("tick: dur=%d, wait=%d, time=5.2%s" % tup)
            root.after(remainingwait, gameloop)
    gameloop()
    root.mainloop()
    done.set()

class Main(tk.Frame):
    def __init__(self,master=None):
        tk.Frame.__init__(self,master)
        self.pack(expand=True, fill=tk.BOTH)
        self.gamefinished = 0
        self.createwidgets()

        #Keys
        self.keys = ["w","s","o","l"]
        self.keypress = KeyPress(self, self.keys)
        
        #Canvas
        self.canvasFrame = tk.Frame(self)
        self.canvasFrame.pack(fill = tk.BOTH)
        self.canvas = tk.Canvas(self, width=300, height=300, bg="black")
        self.canvasheight = int(self.canvas["height"])
        self.canvaswidth = int(self.canvas["width"])
        self.canvas.pack(fill=tk.BOTH)

        #Pause Variable
        self.pause = 0

        self.vars1 = tk.IntVar()
        self.vars2 = tk.IntVar()
        self.col = ["white","green","yellow","blue","violet"]

        #Schlaeger1 Schlaeger2
        self.p1 = []
        self.p2 = []
        self.pc1 = "white"
        self.pc2 = "white"
        self.rect1 = 0
        self.rect2 = 0
        self.plrmvmt = 0
        #Ball
        self.b1 = []
        self.b1mvmnt = []
        self.obj = 0
        self.dickeys = {}
        self.playerpoints = {"p1": 0, "p2": 0}
        self.not_available = 0
        self.winner = 0
        self.settingsOn = 0
        self.settingswindows = 0

        ##Schläger und Ball init
        self.initialstate()

        #ID
        self.id = None

        #check
        self.check = 1

    def createwidgets(self):
        #Buttons
        button_frame = tk.Frame(self, relief=tk.SOLID, pady=2, padx=2)
        button_frame.pack(fill=tk.X)

        button_restart = tk.Button(button_frame, text="(Re)start", command=self.initialstate)
        button_restart.pack(side=tk.LEFT)

        button_pause = tk.Button(button_frame, text="Pause", command=self.pause_game)
        button_pause.pack(side=tk.LEFT)

        button_quit = tk.Button(button_frame, text="Quit", command=self.quit)
        button_quit.pack(side=tk.LEFT)

        button_settings = tk.Button(button_frame, text="Settings", command=self.opensettings)
        button_settings.pack(side=tk.LEFT)

        #Label
        self.label_points = tk.Label(button_frame, text="00:00", padx=20)
        self.label_points.pack(side=tk.LEFT)
        self.label_pause = tk.Label(button_frame, text="", padx=5, foreground="red")
        self.label_pause.pack(side=tk.LEFT)
        self.label_winner = tk.Label(button_frame, text="", padx=5, foreground="green")
        self.label_winner.pack(side=tk.LEFT)

    def opensettings(self):
        def clean_save():
            self.settingswindows = 0
            self.settingsOn = 0
            toplevel.destroy()
        def change():
            self.savechanges()
            clean_save()
        if not self.settingswindows:
            if self.pause == 0:          
                self.pause_game()
            self.settingsOn = 1
            toplevel = tk.Toplevel()
            toplevel.title("Settings")
            toplevel.protocol("WM_DELETE_WINDOW",clean_save)
            
            button_confirm = tk.Button(toplevel, text="Confirm", command=change)
            button_confirm.grid(row=0, column=0,sticky = tk.W)

            label1 = tk.Label(toplevel, text="Choose color for Player1:",font="Arial 12 bold", foreground="black")
            label1.grid(row=1,column=0,columnspan = 3,sticky = tk.W)

            radios1 = []
            radios2 = []

            for i in range(len(self.col)):
                radios1.append(tk.Radiobutton(toplevel, text=self.col[i], variable = self.vars1, value = i))
                radios1[i].grid(row=2, column=i,sticky = tk.W)
            radios1[self.col.index(self.pc1)].select

            label1 = tk.Label(toplevel, text="Choose color for Player2:",font="Arial 12 bold", foreground="black")
            label1.grid(row=3,column=0,columnspan = 3,sticky = tk.W)

            for i in range(len(self.col)):
                radios2.append(tk.Radiobutton(toplevel, text=self.col[i],variable = self.vars2, value = i))
                radios2[i].grid(row=4, column=i,sticky = tk.W)
            radios2[self.col.index(self.pc2)].select
            self.vars1.set(self.col.index(self.pc1))
            self.vars2.set(self.col.index(self.pc2))
            self.settingswindows = 1

    def savechanges(self):
        self.pc1 = self.col[self.vars1.get()]
        self.pc2 = self.col[self.vars2.get()]
        self.rect1 = self.canvas.create_rectangle(self.p1[0],self.p1[1],self.p1[2],self.p1[3],fill=self.pc1)
        self.rect2 = self.canvas.create_rectangle(self.p2[0],self.p2[1],self.p2[2],self.p2[3], fill=self.pc2)

    #Quitting the game
    def quit(self):
        done.set()
        self._root().destroy()

    #Restart Funktion
    def initialstate(self):
        if self.settingsOn == 1:
            return
        self.canvas.delete("all")
        self.plrmvmt = self.canvasheight / 50
        #Ball
        self.b1 = [self.canvaswidth/2-self.canvaswidth/100, self.canvasheight/2-self.canvasheight/100, self.canvaswidth/2+self.canvaswidth/100, self.canvasheight/2+self.canvasheight/100]
        self.obj = self.canvas.create_rectangle(self.b1[0],self.b1[1],self.b1[2],self.b1[3], fill="white")
        #Schläger
        self.p1 = [self.canvaswidth/20, self.canvasheight/2-self.canvasheight/24, self.canvaswidth/20+self.canvaswidth/33, self.canvasheight/2+self.canvasheight/24]
        self.p2 = [(self.canvaswidth/20*19)-self.canvaswidth/33,self.canvasheight/2-self.canvasheight/24, self.canvaswidth/20*19, self.canvasheight/2+self.canvasheight/24]
        self.rect1 = self.canvas.create_rectangle(self.p1[0],self.p1[1],self.p1[2],self.p1[3],fill=self.pc1)
        self.rect2 = self.canvas.create_rectangle(self.p2[0],self.p2[1],self.p2[2],self.p2[3], fill=self.pc2)

        #Geschwindigkeit
        #Die Rechnung Gibt einen Vektor mit dem Betrag Canvasbreite/50 raus
        tmp3 = [1,-1]
        tmp1 = (randrange(int(self.canvaswidth/7),int(self.canvaswidth/5)) * choice(tmp3)) / 10
        tmp2 = int(math.sqrt((self.canvasheight/100+self.canvaswidth/100)**2-tmp1*tmp1) * choice(tmp3))
        self.b1mvmnt = [tmp1,tmp2]

        self.dickeys = {"w":[self.up,self.p1],"o":[self.up,self.p2],"s":[self.down,self.p1],"l":[self.down,self.p2]}
        with lock3:
            if not self.winner == 0:
                self.label_winner["text"] = "Winner: "+str(self.winner)
        with lock2:
            if self.pause and self.gamefinished == 1:
                self.playerpoints = self.playerpoints.fromkeys(self.playerpoints,0)
                self.gamefinished = 0
                self.not_available = 0
                self.winner = 0
                self.label_winner["text"] = ""
                self.pause_game()
        if self.gamefinished == 1:
            self.pause_game()
            self.not_available = 1   
        self.label_points["text"] = "%s:%s"%(self.playerpoints["p1"],self.playerpoints["p2"])
        

    #Spieler Bewegung
    def up(self,pp):
        if  pp[1] > 0:
            pp[1] -= self.plrmvmt
            pp[3] -= self.plrmvmt
    def down(self,pp):
        if  pp[3] < self.canvasheight:
            pp[1] += self.plrmvmt
            pp[3] += self.plrmvmt                           
    def moveschlaeger(self):
        tmp_keylist = self.keypress.pressed() #hole alle aktuellen keys
        if tmp_keylist == []:
            return
        for i in tmp_keylist:
            tmplis = self.dickeys[i]
            tmplis[0](tmplis[1]) #berechnet die neue Position für de betroffenen Spieler; Position wird außerhalb von for aktualisiert
        self.canvas.coords(self.rect1,self.p1[0],self.p1[1],self.p1[2],self.p1[3])
        self.canvas.coords(self.rect2,self.p2[0],self.p2[1],self.p2[2],self.p2[3])
    
    def lrhit(self):
        self.b1mvmnt[0] = self.b1mvmnt[0]*-1 #change x

    def tbhit(self):
        self.b1mvmnt[1] = self.b1mvmnt[1]*-1 #change y

    def advhit(self):
        pass
        
    def collisionDetect(self):
        if self.b1[1] < 0 or self.b1[3] > self.canvasheight:
            self.tbhit()
        if self.p1[2] >= self.b1[0] >= self.p1[2] + self.b1mvmnt[0] and self.b1mvmnt[0] < 0: #ball fliegt nach links
            if self.b1[1] <= self.p1[3] and self.b1[3] >= self.p1[1]:
                self.lrhit()
                self.b1[2] = self.b1[2] - self.b1[0] + self.p1[2]
                self.b1[0] = self.p1[2]
                self.canvas.coords(self.obj,self.b1[0],self.b1[1],self.b1[2],self.b1[3])
        elif self.p2[0] - self.b1mvmnt[0] <= self.b1[2] <= self.p2[0] and self.b1mvmnt[0] > 0: #ball fliegt nach rechts
            if self.b1[1] <= self.p2[3] and self.b1[3] >= self.p2[1]:
                self.lrhit()
                self.b1[0] = self.b1[2] - self.b1[0] + self.p2[0]
                self.b1[2] = self.p2[0]
                self.canvas.coords(self.obj,self.b1[0],self.b1[1],self.b1[2],self.b1[3])
        
    def restart(self, koord1, koord2):
        def do_now():
            if koord1 < 0:                
                self.playerpoints["p2"] += 1
            elif koord2 > self.canvaswidth:
                self.playerpoints["p1"] += 1
            self.initialstate()
        queue.put(do_now)

    def moveball(self):
        self.b1[0] += self.b1mvmnt[0]
        self.b1[1] += self.b1mvmnt[1]
        self.b1[2] += self.b1mvmnt[0]
        self.b1[3] += self.b1mvmnt[1]
        self.canvas.coords(self.obj,self.b1[0],self.b1[1],self.b1[2],self.b1[3])
        if self.check:
            self.check = 0
        else:
            self.check = 1

    #Tick Funktion
    def tick(self):
        with lock:
            if self.pause != 1:
                if 10 in self.playerpoints.values():
                    if self.gamefinished == 1:
                        return
                    self.gamefinished = 1
                    with lock3:
                        if self.playerpoints["p1"] == 10:
                            self.winner = 1
                        else:
                            self.winner = 2
                    self.game_end()
                if self.check:
                    if self.b1[0] < 0 or self.b1[2] > self.canvaswidth:
                        self.restart(self.b1[0], self.b1[2])
                self.moveschlaeger()
                self.collisionDetect()              
                self.moveball()

    def game_end(self):
        self.initialstate()

    #Pause the game
    def pause_game(self):
        if self.not_available or self.settingsOn:
            return
        def do_now():
            with lock2:
                if self.pause == 0:
                    self.pause = 1
                    self.label_pause["text"] = "Paused"
                else:
                    self.pause = 0
                    self.label_pause["text"] = ""
        queue.put(do_now)

root = tk.Tk()
root.minsize(200,200)
eventloop(root)
gameloop(root)

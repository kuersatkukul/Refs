"""Helper for implementing simple games, which are not
totally obvious in tkinter.
* KeyPress: class to check whether a key is pressed
* gameloop_main: Provide a simple gameloop with 'after' as we
  do in animations, everything stays in main thread
Simple test examples of how to use included."""

import time
import threading
import tkinter

class KeyPress:
    """KeyPress, instantiate and provide a frame to check in, most commonly
    use root. You can check anytime in the main thread, whether currently
    in the master a tracked key is pressed."""

    def __init__(self, master, keys):
        """bind the keypress events on the master widget.
        Provide the keys to track in a list keys.
        Assume that initially nothing is pressed"""
        master.bind_all('<KeyPress>', self._report_key_press)
        master.bind_all('<KeyRelease>', self._report_key_release)
        self.keys = dict()
        for key in keys:
            self.keys[key] = None # not pressed

    def _report_key_press(self, event):
        key = event.keysym
        if key in self.keys: # a tracked key
            self.keys[key] = time.time()

    def _report_key_release(self, event):
        key = event.keysym
        if key in self.keys: # a tracked key
            self.keys[key] = None

    def check(self, key):
        "find out whether a tracked key is pressed, use from main thread"
        return self.keys[key] is not None

    def pressed(self):
        "find out all currently pressed keys, use from main thread"
        return [key for key in self.keys if self.keys[key] is not None]


def gameloop_main(Main, *posargs, **kwargs):
    """runs a game loop on a class in addition to the mainloop.
    Use instead of classical main, provide a Main class with optional
    initialization arguments. The Main class should provide a tick method,
    which is called periodically, default is 25 times per second.
    The tick method does *both* state progress and display/visualization.
    Use e.g. FPS=30 to provide a different Frames Per Second setting.
    We only have one loop for both progress and display."""
    fps = 25 # Frames Per Second
    if "FPS" in kwargs:
        fps = int(kwargs["FPS"])
        del kwargs["FPS"]
    if "fps" in kwargs:
        fps = int(kwargs["fps"])
        del kwargs["fps"]
    root = tkinter.Tk()
    posargs = (root, *posargs)
    main = Main(*posargs, **kwargs) # keep reference
    _done = threading.Event()
    waittimems = int((1/fps)*1000) # default 40 ms
    def gameloop():
        if not _done.is_set():
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
    gameloop() # establish event queue loop
    root.mainloop() # here we block
    _done.set() # finish game loop


def test_keypress():
    "test keypress"
    import tkil # no threading in your game code! see test_gameloop
    class Main(tkinter.Frame):
        "Main"
        def __init__(self, master):
            "init"
            super().__init__(master)
            self._root().geometry("400x400")
            self.label = tkinter.Label(self, bg="white")
            self.label.pack(expand=True, fill=tkinter.BOTH)
            keys = ["a", "s", "d", "w", "y", "q",
                    "space", "j", "k", "l", "i", "m"]
            self.keypress = KeyPress(self, keys)
            self.thread = threading.Thread(target=self.run)
            self.thread.start()
        def run(self):
            "run"
            for _ in range(100):
                time.sleep(0.05)
                print(self.keypress.pressed())
            root = self._root()
            tkil.invoke_later(root.destroy)
    tkil.main(Main)


def test_gameloop():
    "test gameloop"
    class Main(tkinter.Frame):
        def __init__(self, master):
            super().__init__(master)
            self.pack()
            self.canvas = tkinter.Canvas(self, width=400, height=400)
            self.canvas.pack(expand=True, fill=tkinter.BOTH)
            # this is the state, good to have as extra class
            self.pos = (0, 0)
            # this is the element on the screen, position depending on state
            self.dot = self.canvas.create_rectangle(0, 0, 10, 10, fill="white")
        def tick(self):
            self.progress()
            self.redraw()
        def progress(self):
            # ugly, magic constants, screen resolution dependent
            # you will do it nicer!
            if self.pos[0] < 390:
                self.pos = (self.pos[0]+1, self.pos[1])
            else:
                if self.pos[1] < 390:
                    self.pos = (0, self.pos[1]+1)
                else:
                    self.pos = (0, 0)
        def redraw(self):
            self.canvas["bg"] = "black"
            coords = self.pos + (self.pos[0]+10, self.pos[1]+10)
            self.canvas.coords(self.dot, coords)
    gameloop_main(Main, FPS=25)


if __name__ == '__main__':
    import sys
    if "keypress" in sys.argv:
        test_keypress()
    elif "gameloop" in sys.argv:
        test_gameloop()
    else:
        print("use as library only, to test do:")
        print("  python3 %s [keypress | gameloop]" % sys.argv[0])

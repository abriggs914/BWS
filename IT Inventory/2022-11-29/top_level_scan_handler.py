import tkinter
from dnd_onv_states import DNDItemManagerStatus


class TopLevelScanHandler(tkinter.Toplevel):

    def __init__(self, master):
        super().__init__(master)

        # Create Widgets
        self.frame_a = tkinter.Frame(self)
        self.dnd_states = DNDItemManagerStatus(self.frame_a)


        # Grid widgets
        self.frame_a.grid()
        self.dnd_states.grid()

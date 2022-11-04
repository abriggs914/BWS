import math
import tkinter
from tkinter import messagebox
from utility import *
from colour_utility import *


class DNDItemManager(tkinter.Canvas):

    def __init__(
            self,
            master,
            canvas_width=600,
            canvas_height=200,
            canvas_background=rgb_to_hex(DODGERBLUE_2),
            omit_server=False,
            omit_in_use=False,
            omit_broken=False,
            omit_disposed=False
    ):
        super().__init__(master, width=canvas_width, height=canvas_height, background=canvas_background)

        self.canvas_width = canvas_width
        self.canvas_height = canvas_height
        self.canvas_background = canvas_background

        self.locked_dnd = tkinter.BooleanVar(self, value=True)
        self.made_dnd = tkinter.BooleanVar(self, value=False)

        self.iv_server_room_number = tkinter.IntVar(self, value=0)
        self.iv_in_use_number = tkinter.IntVar(self, value=0)
        self.iv_broken_number = tkinter.IntVar(self, value=0)
        self.iv_disposed_number = tkinter.IntVar(self, value=0)

        if not omit_server:
            # Server room state
            c1 = rgb_to_hex(GOLDENROD)
            c2 = rgb_to_hex(GRAY_1)
            f1 = ("Arial", 10, "bold")
            self.rect_server_room_state, \
            self.tag_server_room_state_rect, \
            self.tag_server_room_state_text, \
            self.tag_server_room_state_number \
                = self.init_drag_state(100, 100, 120, 50, "Server Room", c1, c2, f1, True, 0.35, False, 0.35)

            self.iv_server_room_number.trace_variable("w", self.update_server_room_number)
            self.iv_server_room_number.set(0)

            self.tag_bind(self.tag_server_room_state_rect, "<B1-Motion>", self.event_drag_server_room)
            self.tag_bind(self.tag_server_room_state_text, "<B1-Motion>", self.event_drag_server_room)
            self.tag_bind(self.tag_server_room_state_number, "<B1-Motion>", self.event_drag_server_room)
            self.tag_bind(self.tag_server_room_state_rect, "<ButtonRelease-1>", self.event_release_server_room)
            self.tag_bind(self.tag_server_room_state_text, "<ButtonRelease-1>", self.event_release_server_room)
            self.tag_bind(self.tag_server_room_state_number, "<ButtonRelease-1>", self.event_release_server_room)
        else:
            self.rect_server_room_state, \
            self.tag_server_room_state_rect, \
            self.tag_server_room_state_text, \
            self.tag_server_room_state_number \
                = None, None, None, None

        if not omit_in_use:
            # In Use state
            c1 = rgb_to_hex(FORESTGREEN)
            c2 = rgb_to_hex(FLORALWHITE)
            f1 = ("Arial", 10, "bold")
            self.rect_in_use_state, \
            self.tag_in_use_state_rect, \
            self.tag_in_use_state_text, \
            self.tag_in_use_state_number \
                = self.init_drag_state(290, 100, 120, 50, "In Use", c1, c2, f1, True, 0.35, False, 0.35)

            self.iv_in_use_number.trace_variable("w", self.update_in_use_number)
            self.iv_in_use_number.set(0)

            self.tag_bind(self.tag_in_use_state_rect, "<B1-Motion>", self.event_drag_in_use)
            self.tag_bind(self.tag_in_use_state_text, "<B1-Motion>", self.event_drag_in_use)
            self.tag_bind(self.tag_in_use_state_number, "<B1-Motion>", self.event_drag_in_use)
            self.tag_bind(self.tag_in_use_state_rect, "<ButtonRelease-1>", self.event_release_in_use)
            self.tag_bind(self.tag_in_use_state_text, "<ButtonRelease-1>", self.event_release_in_use)
            self.tag_bind(self.tag_in_use_state_number, "<ButtonRelease-1>", self.event_release_in_use)
        else:
            self.rect_in_use_state, \
            self.tag_in_use_state_rect, \
            self.tag_in_use_state_text, \
            self.tag_in_use_state_number \
                = None, None, None, None

        if not omit_broken:
            # Broken state
            c1 = rgb_to_hex(INDIANRED_3)
            c2 = rgb_to_hex(GRAY_1)
            f1 = ("Arial", 10, "bold")
            self.rect_broken_state, \
            self.tag_broken_state_rect, \
            self.tag_broken_state_text, \
            self.tag_broken_state_number \
                = self.init_drag_state(480, 45, 120, 50, "Broken", c1, c2, f1, True, 0.35, False, 0.35)

            self.iv_broken_number.trace_variable("w", self.update_broken_number)
            self.iv_broken_number.set(0)

            self.tag_bind(self.tag_broken_state_rect, "<B1-Motion>", self.event_drag_broken)
            self.tag_bind(self.tag_broken_state_text, "<B1-Motion>", self.event_drag_broken)
            self.tag_bind(self.tag_broken_state_number, "<B1-Motion>", self.event_drag_broken)
            self.tag_bind(self.tag_broken_state_rect, "<ButtonRelease-1>", self.event_release_broken)
            self.tag_bind(self.tag_broken_state_text, "<ButtonRelease-1>", self.event_release_broken)
            self.tag_bind(self.tag_broken_state_number, "<ButtonRelease-1>", self.event_release_broken)
        else:
            self.rect_broken_state, \
            self.tag_broken_state_rect, \
            self.tag_broken_state_text, \
            self.tag_broken_state_number \
                = None, None, None, None

        if not omit_disposed:
            # Disposed state
            c1 = rgb_to_hex(GRAY_20)
            c2 = rgb_to_hex(WHITE)
            f1 = ("Arial", 10, "bold")
            self.rect_disposed_state, \
            self.tag_disposed_state_rect, \
            self.tag_disposed_state_text, \
            self.tag_disposed_state_number \
                = self.init_drag_state(480, 145, 120, 50, "Disposed", c1, c2, f1, True, 0.35, False, 0.35)

            self.iv_disposed_number.trace_variable("w", self.update_disposed_number)
            self.iv_disposed_number.set(0)

            self.tag_bind(self.tag_disposed_state_rect, "<B1-Motion>", self.event_drag_disposed)
            self.tag_bind(self.tag_disposed_state_text, "<B1-Motion>", self.event_drag_disposed)
            self.tag_bind(self.tag_disposed_state_number, "<B1-Motion>", self.event_drag_disposed)
            self.tag_bind(self.tag_disposed_state_rect, "<ButtonRelease-1>", self.event_release_disposed)
            self.tag_bind(self.tag_disposed_state_text, "<ButtonRelease-1>", self.event_release_disposed)
            self.tag_bind(self.tag_disposed_state_number, "<ButtonRelease-1>", self.event_release_disposed)
        else:
            self.rect_disposed_state, \
            self.tag_disposed_state_rect, \
            self.tag_disposed_state_text, \
            self.tag_disposed_state_number \
                = None, None, None, None

    def event_drag(self, event, caller):
        print(f"event_drag")
        print(f"{event=}, {caller=}")
        print(f"\t{event.widget=}")

    def event_release(self, event, caller):
        print(f"event_release")
        print(f"{event=}, {caller=}")
        print(f"\t{event.widget=}")
        order = ["server", "in use", "broken", "disposed"]
        bounds_to_check = [
            (0, self.rect_server_room_state),
            (1, self.rect_in_use_state),
            (2, self.rect_broken_state),
            (3, self.rect_disposed_state)
        ]

        ex, ey = event.x, event.y
        match caller:
            case "server":
                bounds_to_check.remove((0, self.rect_server_room_state))
                x1, y1, x2, y2 = self.rect_server_room_state
                if x1 <= ex <= x2 and y1 <= ey <= y2:
                    print(f"RELEASE BACK ON CALLER")
                    return
            case "in use":
                bounds_to_check.remove((1, self.rect_in_use_state))
                x1, y1, x2, y2 = self.rect_in_use_state
                if x1 <= ex <= x2 and y1 <= ey <= y2:
                    print(f"RELEASE BACK ON CALLER")
                    return
            case "broken":
                bounds_to_check.remove((2, self.rect_broken_state))
                x1, y1, x2, y2 = self.rect_broken_state
                if x1 <= ex <= x2 and y1 <= ey <= y2:
                    print(f"RELEASE BACK ON CALLER")
                    return
            case "disposed":
                bounds_to_check.remove((3, self.rect_disposed_state))
                x1, y1, x2, y2 = self.rect_disposed_state
                if x1 <= ex <= x2 and y1 <= ey <= y2:
                    print(f"RELEASE BACK ON CALLER")
                    return
            case _:
                raise Exception(f"Error, this caller is not recognized '{caller}'.")

        for idx, lst in bounds_to_check:
            x1, y1, x2, y2 = lst
            if x1 <= ex <= x2 and y1 <= ey <= y2:
                reciever = order[idx]
                print(f"Release over index {idx}, {reciever=}")
                self.handle_dnd(caller, reciever)
                self.made_dnd.set(True)
                return

        print(f"RELEASED OVER NOTHING")

    def handle_dnd(self, caller, receiver):
        if caller == receiver:
            raise Exception("Error, this can't happen A.")

        if caller == "server":
            # can go directly to the next state
            from_total = self.iv_server_room_number.get()
            move_total = 1
            if (from_total - move_total) >= 0:
                var = None
                match receiver:
                    case "in use":
                        var = self.iv_in_use_number
                    case "broken":
                        var = self.iv_broken_number
                    case "disposed":
                        var = self.iv_disposed_number
                    case _:
                        raise Exception("Error, this can't happen B.")

                self.iv_server_room_number.set(from_total - move_total)
                print(f"{move_total=}, {var.get()=}, {type(move_total)=}, {type(var.get())=}")
                var.set(var.get() + move_total)
                return True
            else:
                tkinter.messagebox.showerror(title="Server Room Inventory", message="Error, none in the server room to move.")

            return False

        elif receiver == "server":
            # can go directly from this state
            match caller:
                case "in use":
                    var = self.iv_in_use_number
                    title = "In Use"
                case "broken":
                    var = self.iv_broken_number
                    title = "Broken"
                case "disposed":
                    var = self.iv_disposed_number
                    title = "Disposed"
                case _:
                    raise Exception("Error, this can't happen B.")

            move_total = 1
            from_total = var.get()
            if (from_total - move_total) >= 0:
                self.iv_server_room_number.set(self.iv_server_room_number.get() + move_total)
                var.set(var.get() - move_total)
                return True
            else:
                tkinter.messagebox.showerror(title=f"{title} Inventory", message="Error, not enough to move.")
            return False
        else:
            a = self.handle_dnd(caller, "server")
            if a:
                b = self.handle_dnd("server", receiver)
            else:
                # tkinter.messagebox.showerror(title=f"Inventory", message="Error, could not complete move.")
                b = False
            return a and b

    def event_drag_server_room(self, event):
        self.event_drag(event, "server")

    def event_drag_in_use(self, event):
        self.event_drag(event, "in use")

    def event_drag_broken(self, event):
        self.event_drag(event, "broken")

    def event_drag_disposed(self, event):
        self.event_drag(event, "disposed")

    def event_release_server_room(self, event):
        self.event_release(event, "server")

    def event_release_in_use(self, event):
        self.event_release(event, "in use")

    def event_release_broken(self, event):
        self.event_release(event, "broken")

    def event_release_disposed(self, event):
        self.event_release(event, "disposed")

    def update_server_room_number(self, *args):
        self.itemconfigure(self.tag_server_room_state_number, text=f"# {self.iv_server_room_number.get()}")

    def update_in_use_number(self, *args):
        self.itemconfigure(self.tag_in_use_state_number, text=f"# {self.iv_in_use_number.get()}")

    def update_broken_number(self, *args):
        self.itemconfigure(self.tag_broken_state_number, text=f"# {self.iv_broken_number.get()}")

    def update_disposed_number(self, *args):
        self.itemconfigure(self.tag_disposed_state_number, text=f"# {self.iv_disposed_number.get()}")

    def init_drag_state(self, x, y, w, h, name, c1, c2, font, dc1, pc1, dc2, pc2):
        # self.fill_server_room_state = c1
        if dc1:
            c3 = darken(c1, pc1, rgb=False)
        else:
            c3 = brighten(c1, pc1, rgb=False)
        if not dc2:
            c4 = brighten(c2, pc2, rgb=False)
        else:
            c4 = darken(c2, pc2, rgb=False)
        bounds = calc_bounds((x, y), w, h)
        rect = self.create_rectangle(
            *bounds,
            fill=c1,
            activefill=c3
        )
        t1 = self.create_text(
            x,
            y - 8,
            text=name,
            font=font,
            fill=c4,
            activefill=c4
        )
        t2 = self.create_text(
            x,
            y + 8,
            text="#__",
            font=font,
            fill=c4,
            activefill=c4
        )
        return bounds, rect, t1, t2

    def select_iti_item(self, data):

        self.locked_dnd.set(False)
        self.made_dnd.set(False)

        print(f"{data=}")
        print(f"qty: {data['Quantity']=}")
        print(f"in_use: {data['Assigned']=}")
        print(f"broken: {data['Maintenance']=}")
        print(f"disposed: {0}")
        qty = 0 if math.isnan(float(data["Quantity"])) else float(data["Quantity"])
        in_use = 0 if math.isnan(float(data["Assigned"])) else float(data["Assigned"])
        broken = 0 if math.isnan(float(data["Maintenance"])) else float(data["Maintenance"])
        disposed = 0
        self.iv_broken_number.set(broken)
        self.iv_disposed_number.set(disposed)
        self.iv_in_use_number.set(in_use)
        self.iv_server_room_number.set(qty)

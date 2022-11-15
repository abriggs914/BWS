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
            omit_disposed=False,
            omit_shopping_cart=False,
            omit_unknown=False
    ):
        super().__init__(master, width=canvas_width, height=canvas_height, background=canvas_background)

        self.canvas_width = canvas_width
        self.canvas_height = canvas_height
        self.canvas_background = canvas_background

        self.btn_width = 90
        self.btn_height = 50
        self.w_space = 48

        # match [omit_server, omit_in_use, (omit_broken and omit_disposed), omit_shopping_cart].count(True):
        #     case 1:
        #         self.btn_width += (self.btn_width / 4)
        #     case 2:
        #         self.btn_width += (self.btn_width / 3)
        #     case 3:
        #         self.btn_width += (self.btn_width / 2)
        #     case _:
        #         # 0, 4
        #         pass

        self.locked_for_animation = tkinter.BooleanVar(self, value=False)
        self.ani_data_drag_object = {
            "x1": 0,
            "y1": 0,
            "x2": 30,
            "y2": 30
        }

        self.locked_dnd = tkinter.BooleanVar(self, value=True)
        self.made_dnd = tkinter.BooleanVar(self, value=False)

        self.omit_server_room = omit_server
        self.omit_in_use = omit_in_use
        self.omit_broken = omit_broken
        self.omit_disposed = omit_disposed
        self.omit_shopping_cart = omit_shopping_cart
        self.omit_unknown = omit_unknown

        self.iv_server_room_number = tkinter.IntVar(self, value=0)
        self.iv_in_use_number = tkinter.IntVar(self, value=0)
        self.iv_broken_number = tkinter.IntVar(self, value=0)
        self.iv_disposed_number = tkinter.IntVar(self, value=0)
        self.iv_shopping_cart_number = tkinter.IntVar(self, value=1)
        self.iv_unknown_number = tkinter.IntVar(self, value=0)

        self.status = tkinter.Variable(self, value={})

        self.status.trace_variable("w", self.status_update)
        self.set_status_update()

        def calc_btn_x(col_idx):
            return ((col_idx + 1) * self.w_space) + ((col_idx) * self.btn_width) + (self.btn_width / 2)

        if not omit_shopping_cart:
            # Shopping Cart state
            c1 = rgb_to_hex(MEDIUMSLATEBLUE)
            c2 = rgb_to_hex(BLACK)
            f1 = ("Arial", 10, "bold")
            cnt = (calc_btn_x(0), 50)
            bounds = (*cnt, self.btn_width, self.btn_height)
            print(f"SHOPPING CART: {bounds=}")
            self.rect_shopping_cart_state, \
            self.tag_shopping_cart_state_rect, \
            self.tag_shopping_cart_state_text, \
            self.tag_shopping_cart_state_number \
                = self.init_drag_state(*bounds, "Cart", c1, c2, f1, True, 0.35, False, 0.35)

            self.iv_shopping_cart_number.trace_variable("w", self.update_shopping_cart_number)
            self.iv_shopping_cart_number.set(1)

            self.tag_bind(self.tag_shopping_cart_state_rect, "<B1-Motion>", self.event_drag_shopping_cart)
            self.tag_bind(self.tag_shopping_cart_state_text, "<B1-Motion>", self.event_drag_shopping_cart)
            self.tag_bind(self.tag_shopping_cart_state_number, "<B1-Motion>", self.event_drag_shopping_cart)
            self.tag_bind(self.tag_shopping_cart_state_rect, "<ButtonRelease-1>", self.event_release_shopping_cart)
            self.tag_bind(self.tag_shopping_cart_state_text, "<ButtonRelease-1>", self.event_release_shopping_cart)
            self.tag_bind(self.tag_shopping_cart_state_number, "<ButtonRelease-1>", self.event_release_shopping_cart)
        else:
            self.rect_shopping_cart_state, \
            self.tag_shopping_cart_state_rect, \
            self.tag_shopping_cart_state_text, \
            self.tag_shopping_cart_state_number \
                = None, None, None, None

        if not omit_unknown:
            # Shopping Cart state
            c1 = rgb_to_hex(MAROON)
            c2 = rgb_to_hex(FLORALWHITE)
            f1 = ("Arial", 10, "bold")
            cnt = (calc_btn_x(0), 150)
            bounds = (*cnt, self.btn_width, self.btn_height)
            print(f"UNKNOWN: {bounds=}")
            self.rect_unknown_state, \
            self.tag_unknown_state_rect, \
            self.tag_unknown_state_text, \
            self.tag_unknown_state_number \
                = self.init_drag_state(*bounds, "Unknown", c1, c2, f1, True, 0.35, False, 0.35)

            self.iv_unknown_number.trace_variable("w", self.update_unknown_number)
            self.iv_unknown_number.set(0)

            self.tag_bind(self.tag_unknown_state_rect, "<B1-Motion>", self.event_drag_unknown)
            self.tag_bind(self.tag_unknown_state_text, "<B1-Motion>", self.event_drag_unknown)
            self.tag_bind(self.tag_unknown_state_number, "<B1-Motion>", self.event_drag_unknown)
            self.tag_bind(self.tag_unknown_state_rect, "<ButtonRelease-1>", self.event_release_unknown)
            self.tag_bind(self.tag_unknown_state_text, "<ButtonRelease-1>", self.event_release_unknown)
            self.tag_bind(self.tag_unknown_state_number, "<ButtonRelease-1>", self.event_release_unknown)
        else:
            self.rect_unknown_state, \
            self.tag_unknown_rect, \
            self.tag_unknown_text, \
            self.tag_unknown_number \
                = None, None, None, None

        if not omit_server:
            # Server room state
            c1 = rgb_to_hex(GOLDENROD)
            c2 = rgb_to_hex(GRAY_1)
            f1 = ("Arial", 10, "bold")
            cnt = (calc_btn_x(1), 100)
            bounds = (*cnt, self.btn_width, self.btn_height)
            print(f"SERVER: {bounds=}")
            self.rect_server_room_state, \
            self.tag_server_room_state_rect, \
            self.tag_server_room_state_text, \
            self.tag_server_room_state_number \
                = self.init_drag_state(*bounds, "Server Room", c1, c2, f1, True, 0.35, False, 0.35)

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
            cnt = (calc_btn_x(2), 100)
            bounds = (*cnt, self.btn_width, self.btn_height)
            print(f"IN USE: {bounds=}")
            self.rect_in_use_state, \
            self.tag_in_use_state_rect, \
            self.tag_in_use_state_text, \
            self.tag_in_use_state_number \
                = self.init_drag_state(*bounds, "In Use", c1, c2, f1, True, 0.35, False, 0.35)

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
            cnt = (calc_btn_x(3), 50)
            bounds = (*cnt, self.btn_width, self.btn_height)
            print(f"BROKEN: {bounds=}")
            self.rect_broken_state, \
            self.tag_broken_state_rect, \
            self.tag_broken_state_text, \
            self.tag_broken_state_number \
                = self.init_drag_state(*bounds, "Broken", c1, c2, f1, True, 0.35, False, 0.35)

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
            cnt = (calc_btn_x(3), 150)
            bounds = (*cnt, self.btn_width, self.btn_height)
            print(f"DISPOSED: {bounds=}")
            self.rect_disposed_state, \
            self.tag_disposed_state_rect, \
            self.tag_disposed_state_text, \
            self.tag_disposed_state_number \
                = self.init_drag_state(*bounds, "Disposed", c1, c2, f1, True, 0.35, False, 0.35)

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

        self.ani_data_drag_object["tag"] = self.create_rectangle(
            self.ani_data_drag_object["x1"],
            self.ani_data_drag_object["y1"],
            self.ani_data_drag_object["x2"],
            self.ani_data_drag_object["y2"],
            fill=rgb_to_hex(BWS_GREY)
        )
        self.itemconfigure(self.ani_data_drag_object["tag"], state="hidden")

    def set_status_update(self):
        self.status.set({
            "unknown": self.iv_unknown_number.get(),
            "server": self.iv_server_room_number.get(),
            "in_use": self.iv_in_use_number.get(),
            "broken": self.iv_broken_number.get(),
            "disposed": self.iv_disposed_number.get(),
            "cart": self.iv_shopping_cart_number.get()
        })

    def status_update(self, *args):
        # print(dict_print(eval(self.status.get()), "Self.Status"))
        pass

    def event_drag(self, event, caller):
        if not self.locked_for_animation.get():
            caller_value = eval(self.status.get())[caller]
            if caller_value > 0:
                self.itemconfigure(self.ani_data_drag_object["tag"], state="normal")
                x, y = event.x, event.y
                w2, h2 = (self.ani_data_drag_object["x2"] - self.ani_data_drag_object["x1"]) / 2, (self.ani_data_drag_object["y2"] - self.ani_data_drag_object["y1"]) / 2
                x -= w2
                y -= h2
                x = clamp(0, x, self.canvas_width - (2 * w2))
                y = clamp(0, y, self.canvas_height - (2 * h2))
                self.moveto(self.ani_data_drag_object["tag"], x, y)
                print(f"event_drag")
                print(f"{event=}, {caller=}, caller_value='{caller_value}'")
                print(f"\t{event.widget=}")
            else:
                print(f"Nothing to move.")
        else:
            print(f"Locked for animation.")

    def event_release(self, event, caller):
        if not self.locked_for_animation.get():
            self.itemconfigure(self.ani_data_drag_object["tag"], state="hidden")
            print(f"event_release")
            print(f"{event=}, {caller=}")
            print(f"\t{event.widget=}")
            order = ["server", "in_use", "broken", "disposed", "cart", "unknown"]
            bounds_to_check = []
            if not self.omit_server_room:
                bounds_to_check.append((0, self.rect_server_room_state))
            if not self.omit_in_use:
                bounds_to_check.append((1, self.rect_in_use_state))
            if not self.omit_broken:
                bounds_to_check.append((2, self.rect_broken_state))
            if not self.omit_disposed:
                bounds_to_check.append((3, self.rect_disposed_state))
            if not self.omit_shopping_cart:
                bounds_to_check.append((4, self.rect_shopping_cart_state))
            if not self.omit_unknown:
                bounds_to_check.append((5, self.rect_unknown_state))

            ex, ey = event.x, event.y
            match caller:
                case "server":
                    bounds_to_check.remove((0, self.rect_server_room_state))
                    x1, y1, x2, y2 = self.rect_server_room_state
                    if x1 <= ex <= x2 and y1 <= ey <= y2:
                        print(f"RELEASE BACK ON CALLER")
                        return
                case "in_use":
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
                case "cart":
                    bounds_to_check.remove((4, self.rect_shopping_cart_state))
                    x1, y1, x2, y2 = self.rect_shopping_cart_state
                    if x1 <= ex <= x2 and y1 <= ey <= y2:
                        print(f"RELEASE BACK ON CALLER")
                        return
                case "unknown":
                    bounds_to_check.remove((5, self.rect_unknown_state))
                    x1, y1, x2, y2 = self.rect_unknown_state
                    if x1 <= ex <= x2 and y1 <= ey <= y2:
                        print(f"RELEASE BACK ON CALLER")
                        return
                case _:
                    raise Exception(f"Error, this caller is not recognized '{caller}'.")

            for idx, lst in bounds_to_check:
                x1, y1, x2, y2 = lst
                if x1 <= ex <= x2 and y1 <= ey <= y2:
                    receiver = order[idx]
                    print(f"Release over index {idx}, {receiver=}")
                    self.handle_dnd(caller, receiver)
                    self.made_dnd.set(True)
                    return

            print(f"RELEASED OVER NOTHING")
        else:
            print(f"Locked for animation.")

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
                    case "in_use":
                        var = self.iv_in_use_number
                    case "broken":
                        var = self.iv_broken_number
                    case "disposed":
                        var = self.iv_disposed_number
                    case "unknown":
                        var = self.iv_unknown_number
                    case "cart":
                        tkinter.messagebox.showerror(title="Server Room Inventory", message="Error, can't send things back to shopping cart.")
                    case _:
                        raise Exception("Error, this can't happen B.")

                self.iv_server_room_number.set(from_total - move_total)
                print(f"{move_total=}, {var.get()=}, {type(move_total)=}, {type(var.get())=}, {self.status.get()=}, {type(self.status.get())=}")
                var.set(var.get() + move_total)
                self.set_status_update()
                return True
            else:
                tkinter.messagebox.showerror(title="Server Room Inventory", message="Error, none in the server room to move.")

            return False

        elif receiver == "server":
            # can go directly from this state
            match caller:
                case "in_use":
                    var = self.iv_in_use_number
                    title = "in_use"
                case "broken":
                    var = self.iv_broken_number
                    title = "Broken"
                case "disposed":
                    var = self.iv_disposed_number
                    title = "Disposed"
                case "cart":
                    var = self.iv_shopping_cart_number
                    title = "Shopping Cart"
                case "unknown":
                    var = self.iv_unknown_number
                    title = "Unknown"
                case _:
                    raise Exception("Error, this can't happen B.")

            move_total = 1
            from_total = var.get()
            if (from_total - move_total) >= 0:
                self.iv_server_room_number.set(self.iv_server_room_number.get() + move_total)
                if caller != "cart":
                    # shopping cart always stays in stock
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
        self.event_drag(event, "in_use")

    def event_drag_broken(self, event):
        self.event_drag(event, "broken")

    def event_drag_disposed(self, event):
        self.event_drag(event, "disposed")

    def event_drag_shopping_cart(self, event):
        self.event_drag(event, "cart")

    def event_drag_unknown(self, event):
        self.event_drag(event, "unknown")

    def event_release_server_room(self, event):
        self.event_release(event, "server")

    def event_release_in_use(self, event):
        self.event_release(event, "in_use")

    def event_release_broken(self, event):
        self.event_release(event, "broken")

    def event_release_disposed(self, event):
        self.event_release(event, "disposed")

    def event_release_shopping_cart(self, event):
        self.event_release(event, "cart")

    def event_release_unknown(self, event):
        self.event_release(event, "unknown")

    def update_server_room_number(self, *args):
        self.itemconfigure(self.tag_server_room_state_number, text=f"# {self.iv_server_room_number.get()}")

    def update_in_use_number(self, *args):
        self.itemconfigure(self.tag_in_use_state_number, text=f"# {self.iv_in_use_number.get()}")

    def update_broken_number(self, *args):
        self.itemconfigure(self.tag_broken_state_number, text=f"# {self.iv_broken_number.get()}")

    def update_disposed_number(self, *args):
        self.itemconfigure(self.tag_disposed_state_number, text=f"# {self.iv_disposed_number.get()}")

    def update_shopping_cart_number(self, *args):
        self.itemconfigure(self.tag_shopping_cart_state_number, text=f"# {self.iv_shopping_cart_number.get()}")

    def update_unknown_number(self, *args):
        self.itemconfigure(self.tag_unknown_state_number, text=f"# {self.iv_unknown_number.get()}")

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
        self.set_status_update()

    def animate(self, state_from, state_to):
        valid_states = {"in_use", "server", "broken", "disposed", "unknown"}
        assert state_from in valid_states, f"Error param 'state_from' not recognized: '{state_from}'"
        assert state_to in valid_states, f"Error param 'state_to' not recognized: '{state_to}'"
        self.locked_for_animation.set(True)

        n_steps = 25

        c_x, c_y = 0, 0
        s_x, s_y = 0, 0

        fss = state_from if state_from != "server" else "server_room"
        tss = state_to if state_to != "server" else "server_room"

        res_fss = eval(f"self.rect_{fss}_state")
        res_tss = eval(f"self.rect_{tss}_state")
        print(f"{res_fss=}, {res_tss=}")
        fx1, fy1, fx2, fy2 = res_fss
        tx1, ty1, tx2, ty2 = res_tss
        drag_width = self.ani_data_drag_object["x2"] - self.ani_data_drag_object["x1"]
        drag_height = self.ani_data_drag_object["y2"] - self.ani_data_drag_object["y1"]
        t_x = fx2 - fx1
        t_y = fy2 - fy1

        fxd = (t_x - drag_width) / 2
        fyd = (t_y - drag_height) / 2

        s_x = (tx1 - fx1) / (n_steps + 1)
        s_y = (ty1 - fy1) / (n_steps + 1)

        self.ani_data_drag_object["x1"] = fx1 + fxd
        self.ani_data_drag_object["y1"] = fy1 + fyd
        self.ani_data_drag_object["x2"] = fx2 - fxd
        self.ani_data_drag_object["y2"] = fy2 - fyd

        self.moveto(
            self.ani_data_drag_object["tag"],
            self.ani_data_drag_object["x1"],
            self.ani_data_drag_object["y1"]
        )

        self.itemconfigure(self.ani_data_drag_object["tag"], state="normal")

        def sub_animate(data):

            print(dict_print(self.ani_data_drag_object, "self.ani_data_drag_object"))

            if data.get("count", 0) >= 0:
                self.ani_data_drag_object["x1"] += s_x
                self.ani_data_drag_object["y1"] += s_y
                self.ani_data_drag_object["x2"] += s_x
                self.ani_data_drag_object["y2"] += s_y

                self.moveto(
                    self.ani_data_drag_object["tag"],
                    self.ani_data_drag_object["x1"],
                    self.ani_data_drag_object["y1"]
                )

                new_data = dict(data)
                new_data["count"] = new_data.get("count", 0) - 1
                interval = new_data.get("interval", 1)
                self.after(interval, sub_animate, new_data)
            else:
                self.itemconfigure(self.ani_data_drag_object["tag"], state="hidden")
                self.locked_for_animation.set(False)

        sub_animate({"count": n_steps, "interval": 25})

from tkinter_utility import *


# class ScannableEntry(tkinter.Entry):
#
#     def __init__(self, master):
#         super().__init__(master)
#
#         self.top_most = top_most_tk(master)
#
#         self.validated_text = tkinter.StringVar(self,
#                                                 value="")  # use this variable to ensure that the text has already been validated
#         self.text = tkinter.StringVar(self, value="")
#         self.passing_through = tkinter.BooleanVar(self, value=False)
#
#         self.valid_submission = tkinter.BooleanVar(self, value=False)  # use this to prevent early submissions.
#         self.accepting_counter_reset = 2000
#         self.accepting_counter = tkinter.IntVar(self,
#                                                 value=self.accepting_counter_reset)  # use this to prevent submission while editing.
#
#         self.entry = tkinter.Entry(self, textvariable=self.text, font=("Arial", 16), justify=tkinter.CENTER)
#
#         # show entry widget
#         self.entry.pack()
#
#         # bind and trace widgets and variables
#         self.accepting_counter.trace_variable("w", self.update_accepting_counter)
#         self.valid_submission.trace_variable("w", self.update_valid_submission)
#         self.text.trace_variable("w", self.update_text)
#         self.entry.bind("<Return>", self.return_text)
#         self.entry.bind("<FocusIn>",
#                         self.update_has_focus_in)  # prevents duplicate event firing when typing directly into the entry widget
#         self.entry.bind("<FocusOut>", self.update_has_focus_out)
#
#     def update_text(self, *args):
#         if len(args) == 1:
#             # print("\t\t\tFROM TOP MOST")
#             event, *rest = args
#             ch = event.char
#             if ch.isalnum():
#                 self.text.set(self.text.get() + ch)
#
#         self.accepting_counter.set(self.accepting_counter_reset)
#         self.valid_submission.set(False)
#         self.validated_text.set("")
#
#         self.count_stop_editing()
#
#     def return_text(self, event):
#         self.accepting_counter.set(0)
#
#     def count_stop_editing(self):
#         x = self.accepting_counter.get()
#         if x > 1:
#             self.accepting_counter.set(x - 1)
#             self.after(1, self.count_stop_editing)
#
#     def update_accepting_counter(self, *args):
#         if self.accepting_counter.get() <= 0:
#             self.valid_submission.set(True)
#
#     def update_valid_submission(self, *args):
#         # this is called when the entry is ready to be read.
#         if self.valid_submission.get() and self.text.get():
#             print(f"DONE!! '{self.text.get()}'")
#             self.validated_text.set(self.text.get())
#
#     def update_has_focus_in(self, *event):
#         self.top_most.unbind("<Return>")
#         self.top_most.unbind("<KeyPress>")
#
#     def update_has_focus_out(self, *event):
#         self.top_most.bind("<Return>", self.return_text)
#         self.top_most.bind("<KeyPress>", self.update_text)
#
#     def set_scan_pass_through(self):
#         print(
#             f"WARNING, this forces all keyboard and return key events through this widget.\nDo not use on a single form with multiple text / entry input widgets.")
#         self.passing_through.set(True)
#         self.top_most.unbind("<KeyPress>")
#         self.update_has_focus_out("")
#
# def win_keypress(event):
#     print(f"{event=}")


if __name__ == '__main__':

    WIN = tkinter.Tk()
    WIN.geometry("300x120")
    WIN.title("Scannable entry demo")

    # x = WIN.bind()
    # print(f"A {x=}")
    frame = tkinter.Frame(WIN)
    s_entry = ScannableEntry(frame)
    s_entry.set_scan_pass_through()
    # x = WIN.bind()
    # print(f"B {x=}")

    # WIN.bind("<KeyPress>", win_keypress)

    frame.pack()
    s_entry.pack()

    WIN.mainloop()

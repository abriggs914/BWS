import chardet
import textract
import tkinter as tk
import win32com.client
# from TkinterDnD2 import DND_FILES, TkinterDnD
import easygui
from tkinterdnd2 import DND_FILES, TkinterDnD

import locale
locale.getdefaultlocale()


valid_file_types = [
    {
        "ending": "txt",
        "encoding": None
    },
    {
        "ending": "doc",
        "encoding": "ANSI"
    },
    {
        "ending": "msg",
        "encoding": "ANSI"
    }
]
valid_file_types_lst = [d["ending"] for d in valid_file_types]
known_endings_idxs = [{k: v for k, v in d.items()} for i, d in enumerate(valid_file_types)]
known_endings_idxs = {d["ending"]: i for i, d in enumerate(known_endings_idxs)}
# known_endings_idxs = dict(zip([d["ending"] for d in valid_file_types_lst], list(range(len(valid_file_types_lst)))))


def drop_inside_list_box(event):
    listb.insert("end", event.data)


def drop_inside_textbox(event):
    tbox.delete("1.0", "end")
    print(f"{event.data=}, {type(event.data)=}")
    ed = [e.replace("{", "").replace("}", "") for e in event.data.split("} {")]
    for e in ed:
        if ending := e.split(".")[-1]:
            print(f"{ending=}")

            if ending not in valid_file_types_lst:
                easygui.msgbox(msg=f"Error file type '{ending}' is not supported as of right now", title="File Reading Error")
                return

            # chardet_results = chardet.detect(lines)
            # encoding = chardet_results["encoding"]
            # print(f"Chardet results: {chardet_results}")
            # # Hardcode known encodings
            # if ending in known_endings_idxs:
            #     new_encoding = valid_file_types[known_endings_idxs[ending]]["encoding"]
            #     if new_encoding is not None:
            #         print(f"Overwriting encoding with known encoding for '{ending}' files. OLD='{encoding}' => NEW='{new_encoding}'")
            #         encoding = new_encoding
            # if encoding:
            #     lines = lines.decode(encoding)
            # from bs4 import BeautifulSoup as bs
            # soup = bs(open(e).read())
            # [s.extract() for s in soup(['style', 'script'])]
            # tmpText = soup.get_text()
            # text = "".join("".join(tmpText.split('\t')).split('\n')).encode('utf-8').strip()
            # print(f"RESULT <{text}>")

            # word = win32com.client.Dispatch("Word.Application")
            # word.visible = False
            # wb = word.Documents.Open(e)
            # doc = word.ActiveDocument
            # print(f"result: {doc.Range().Text}")

            # LINUX ONLY
            # text = textract.process(e)
            # print(f"\n\t\tFINAL\n\n{text=}")
            # tbox.insert("end", f"{text}\n")

            # with open(e, "r", encoding='utf-16') as file:
            with open(e, "r", errors="ignore", encoding=locale.getdefaultlocale()[1]) as file:

                lines = file.read()
                # # # lines_j = "\n"
                # # print(f"-2 {lines=}")
                # lines_en = lines.encode(lines)
                # chardet_results = chardet.detect(lines_en)
                # encoding = chardet_results["encoding"]
                # print(f"Chardet results: {chardet_results}")
                # # print(f"-1 {type(lines)=}")
                #
                # # Hardcode known encodings
                # if ending in known_endings_idxs:
                #     new_encoding = valid_file_types[known_endings_idxs[ending]]["encoding"]
                #     if new_encoding is not None:
                #         print(f"Overwriting encoding with known encoding for '{ending}' files. OLD='{encoding}' => NEW='{new_encoding}'")
                #         encoding = new_encoding
                # if encoding:
                #     lines = lines.decode(encoding)
                #
                #
                # #     print(f"AAA {lines}")
                # # else:
                # #     print(f"BBB {lines}")

                print(f"\n\t\tFINAL\n\n{lines=}")
                tbox.insert("end", f"{lines}\n")
                # print(f"\n\t\tFINAL\n\n{naive_decoder(lines)=}")
                # file = file.decode("utf-16")
                # print(f"{file=}, {type(file)=}")
                # # for line in file:
                # #     print(f"A\t{line=}")
                # #     line = line.strip()
                # #     print(f"B\t{line=}")


def naive_decoder(str_in):
    res = []
    for c in str_in:
        # print(f"||{c=}")
        if chr(32) <= c <= chr(126):
            res.append(c)

    res = "".join(res)
    return res


if __name__ == '__main__':

    root = TkinterDnD.Tk()
    root.geometry("800x500")

    listb = tk.Listbox(root, selectmode=tk.SINGLE, background="#ffe0d6")
    listb.pack(fill=tk.X)
    listb.drop_target_register(DND_FILES)
    listb.dnd_bind("<<Drop>>", drop_inside_list_box)

    tbox = tk.Text(root)
    tbox.pack()
    tbox.drop_target_register(DND_FILES)
    tbox.dnd_bind("<<Drop>>", drop_inside_textbox)

    root.mainloop()

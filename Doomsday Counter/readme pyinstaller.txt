https://stackoverflow.com/questions/57811928/how-to-install-python-application-with-tkcalendar-module-by-pyinstaller

# use this tomake tkcalendar work in pyinstaller.
# also see overlay/window.py to edit the transparent colour of overlays. (Screeenshot 2022-07-21 004529.png)
pyinstaller --hidden-import babel.numbers --onefile main.py
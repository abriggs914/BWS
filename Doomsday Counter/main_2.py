import sys
from PyQt5 import QtGui, QtCore

class mymainwindow(QtGui.QMainWindow):
    def __init__(self):
        QtGui.QMainWindow.__init__(self, None, QtCore.Qt.WindowStaysOnTopHint)

if __name__ == "__main__":
    app = QtGui.QApplication(sys.argv)
    mywindow = mymainwindow()
    mywindow.show()
    app.exec_()
    mywindow.show()

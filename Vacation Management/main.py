from calendar_surfaces import *
from queries import *

if __name__ == '__main__':

    window = tkinter.Tk()
    W, H = 900, 750
    window.geometry(f"{W}x{H}")
    window.state("zoomed")
    window.title("Vacation Management")

    annual = AnnualFrameCalendar(window, calendar_width=1400, calendar_height=800)

    # StaffID#, Emp#, 2nd Name, 1st Name, Dept, DeptID, Date Hired, DOB
    df_list_of_employees = connect(**SQL_BWS_EMPLOYEE_LIST)

    window.mainloop()

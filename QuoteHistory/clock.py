import os
import datetime
import time
import easygui
from utility import *

clear = lambda: os.system('cls') #on Windows System

hours = [str(i%12 if i%12 != 0 else 12).rjust(2, "0") + (":00 AM" if i < 12 else ":00 PM") for i in range(24)]
minutes = [str(i).rjust(2, "0") for i in range(60)]
y_n = ["Yes", "No"]
printing_dict = False

def get_end_time():
	correct = False
	end_time = "05:00 PM"
	et = end_time
	while not correct:
		end_time = end_time if end_time in hours else et
		end_hour = easygui.choicebox(msg="Select the ending hour:", choices=hours, title="Hour Selection", preselect=hours.index(end_time))
		end_minute = easygui.choicebox(msg="Select the ending minute:", choices=minutes, title="Minute Selection", preselect=minutes.index("00"))
		end_time = end_hour.replace("00", end_minute)
		msg = "{t} is this correct?".format(t=end_time)
		correct = easygui.boolbox(msg=msg, title="Correct?", choices=y_n, default_choice=y_n[0], cancel_choice=y_n[0])
	return end_time

def get_start_time():
	correct = False
	start_time = "08:00 AM"
	st = start_time
	while not correct:
		start_time = start_time if start_time in hours else st
		start_hour = easygui.choicebox(msg="Select the starting hour:", choices=hours, title="Hour Selection", preselect=hours.index(start_time))
		start_minute = easygui.choicebox(msg="Select the starting minute:", choices=minutes, title="Minute Selection", preselect=minutes.index("00"))
		start_time = start_hour.replace("00", start_minute)
		msg = "{t} is this correct?".format(t=start_time)
		correct = easygui.boolbox(msg=msg, title="Correct?", choices=y_n, default_choice=y_n[0], cancel_choice=y_n[0])
	return start_time
	
def ask_custom_start():
	return easygui.boolbox(msg="Do you want a custom start time?", cancel_choice=y_n[1])
	
def ask_custom_end():
	return easygui.boolbox(msg="Do you want a custom end time?", cancel_choice=y_n[1])

def run():
	today = datetime.datetime.now()
	today_str = "{y}/{m}/{d} {H}:{M}:{S}".format(y=today.year, m=today.month, d=today.day, H=17, M=0, S=0)
	custom_start = ask_custom_start()
	if custom_start:
		start_time = get_start_time().split(":")
		h = int(start_time[0].strip())
		m = int(start_time[1].split()[0].strip())
		am_pm = start_time[1].split()[1].strip()
		if am_pm == "PM" and h != 12:
			h += 12
		if am_pm == "AM" and h == 12:
			h -= 12
		# today.hour = h
		# today.minute = m
		# today.second = 0
		date_str = "{y}/{m}/{d} {H}:{M}:{S}".format(y=today.year, m=today.month, d=today.day, H=h, M=m, S=0)
		today = datetime.datetime.strptime(date_str, "%Y/%m/%d %H:%M:%S")

	custom_end = ask_custom_end()
	if custom_end:
		end_time = get_end_time().split(":")
		h = int(end_time[0].strip())
		m = int(end_time[1].split()[0].strip())
		am_pm = end_time[1].split()[1].strip()
		if am_pm == "PM" and h != 12:
			h += 12
		if am_pm == "AM" and h == 12:
			h -= 12
		today_str = "{y}/{m}/{d} {H}:{M}:{S}".format(y=today.year, m=today.month, d=today.day, H=h, M=m, S=0)
		
	end_of_day = datetime.datetime.strptime(today_str, "%Y/%m/%d %H:%M:%S")
	diff = (end_of_day - today).total_seconds()
	
	print("today: " + str(today))
	print("end of day: " + str(end_of_day))
	print("diff: " + str(diff))
	
	start = today
	stop = end_of_day
	
	while diff > 0:
		clear()
		start = max(start, datetime.datetime.now())
		start_str = "{y}/{m}/{d} {H}:{M}:{S}".format(y=start.year, m=start.month, d=start.day, H=17, M=0, S=0)
		end_of_day = datetime.datetime.strptime(start_str, "%Y/%m/%d %H:%M:%S")
		diff = (end_of_day - start).total_seconds()
		t_hours, t_minutes, t_seconds = total_times(diff)
		time_left = time_str(start, end_of_day)
		diff = (min(start, end_of_day) - today).total_seconds()
		time_passed = time_str(today, min(start, end_of_day))
		e_hours, e_minutes, e_seconds = total_times(diff)
		time_elapsed = "\n\t{s1}\n\t{s2}\n\t\t{tp}".format(s1=today, s2=stop, tp=time_passed)
		if printing_dict:
			print(dict_print({
				"Current Time": start,
				"Start Time": today,
				"End Time": stop,
				"Time Left": time_left,
				"Total Time Left": {
										"Hours": t_hours,
										"Minutes": t_minutes,
										"Seconds": t_seconds,
									},
				"Time Elapsed": time_passed,
				"Total Time Elapsed": {
										"Hours": e_hours,
										"Minutes": e_minutes,
										"Seconds": e_seconds,
									}
			},
			"Current time"
			))
		else:
			print("\n\t" + str(start) + "\n\n\n\tTime Left\t" + str(time_left) + "\n\n\t\tTotal time:\n\tHours\t" + str(t_hours) + "\n\tMins\t" + str(t_minutes) + "\n\tSecs\t" + str(t_seconds) + "\n\n\tTime elapsed:\t" + str(time_elapsed))
		time.sleep(1)
		
	print("End of day!")
	
def total_times(t):
	return (t / (60*60), t / 60, t)

def time_str(t1, t2):
	diff = (t2 - t1).total_seconds()
	hours = str(int(diff / (60*60))).rjust(2, "0")
	minutes = str(int((diff - (60*60*int(hours))) / 60)).rjust(2, "0")
	seconds = str(int(diff - (60*60*int(hours)) - (60*int(minutes)))).rjust(2, "0")
	return "{h}:{m}:{s}".format(h=hours, m=minutes, s=seconds)

if __name__ == "__main__":
	run()

# clear()
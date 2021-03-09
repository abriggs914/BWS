import os
import datetime
import time

clear = lambda: os.system('cls') #on Windows System


def run():
	today = datetime.datetime.now()
	today_str = "{y}/{m}/{d} {H}:{M}:{S}".format(y=today.year, m=today.month, d=today.day, H=17, M=0, S=0)
	end_of_day = datetime.datetime.strptime(today_str, "%Y/%m/%d %H:%M:%S")
	diff = (end_of_day - today).total_seconds()
	
	print("today: " + str(today))
	print("end of day: " + str(end_of_day))
	print("diff: " + str(diff))
	
	while diff > 0:
		clear()
		today = datetime.datetime.now()
		today_str = "{y}/{m}/{d} {H}:{M}:{S}".format(y=today.year, m=today.month, d=today.day, H=17, M=0, S=0)
		end_of_day = datetime.datetime.strptime(today_str, "%Y/%m/%d %H:%M:%S")
		diff = (end_of_day - today).total_seconds()
		hours = str(int(diff / (60*60))).rjust(2, "0")
		minutes = str(int((diff - (60*60*int(hours))) / 60)).rjust(2, "0")
		seconds = str(int(diff - (60*60*int(hours)) - (60*int(minutes)))).rjust(2, "0")
		t_hours = diff / (60*60)
		t_minutes = diff / 60
		t_seconds = diff
		time_left = "{h}:{m}:{s}".format(h=hours, m=minutes, s=seconds)
		print("\n\t" + str(today) + "\n\n\n\tTime Left\t" + str(time_left) + "\n\n\t\tTotal time:\n\tHours\t" + str(t_hours) + "\n\tMins\t" + str(t_minutes) + "\n\tSecs\t" + str(t_seconds))
		time.sleep(1)
		
	print("End of day!")


if __name__ == "__main__":
	run()

# clear()
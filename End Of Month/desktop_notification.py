import os

def not_toast():
	# python -m pip install win10toast
	from win10toast import ToastNotifier

	# One-time initialization
	toaster = ToastNotifier()

	# Show notification whenever needed
	toaster.show_toast("Notification!", "Alert!", threaded=True,
					   icon_path=None, duration=3)  # 3 seconds

	# To check if any notifications are active,
	# use `toaster.notification_active()`
	import time
	while toaster.notification_active():
		time.sleep(0.1)
		
def not_plyer():
	# python -m pip install plyer
	from plyer import notification

	notification.notify(
		title='Here is the title',
		message='Here is the message',
		app_icon=("C:\\Users\\ABriggs\\Documents\\BWS\\End Of Month/BWS-Chrome-Final-WO-Manufacturing.ico"),  # e.g. 'C:\\icon_32x32.ico'
		timeout=5  # seconds
	)
	
if __name__ == "__main__":
	#not_toast()
	not_plyer()
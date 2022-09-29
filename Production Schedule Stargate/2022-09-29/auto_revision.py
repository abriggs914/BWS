import datetime
import os
import shutil


def make_dir_if_not_exists(path_in):
    print(f"Making {path_in=}")
    if not os.path.isdir(path_in):
        os.makedirs(path_in)
    else:
        print(f"already exists")


def copy_file(path_from, path_to):
    shutil.copy(path_from, path_to)


if __name__ == '__main__':
    today = datetime.datetime.now()
    df = today.strftime("%Y-%m-%d")
    hour = today.hour
    h_hour = int(today.strftime("%M")) / 60
    # print(f"{hour=}, {h_hour=}, {int(today.strftime('%M'))=}")
    if h_hour >= 0.5:
        hour += 1
    suffix = today.strftime("%p")

    archive_path_name_1 = f"D:\Access Backups\{df}\STG Prod Sched\{hour}{suffix}"
    archive_path_name_2 = f"D:\Access Backups\{df}\STG Prod Sched\{hour}{suffix}\Code"

    make_dir_if_not_exists(archive_path_name_1)
    make_dir_if_not_exists(archive_path_name_2)

    for file_name in os.listdir():
        copy_file(f"./{file_name}", archive_path_name_2)

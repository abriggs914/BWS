
import os
import shutil


# Press the green button in the gutter to run the script.
if __name__ == '__main__':

    # set the source directories
    # part_number = r"87TTB018-4"
    part_number = r"40955032"

    dir1 = (r"server4\Design\VaultWorkspace_BWS\PDFS", ".pdf", "top")
    dir2 = (r"server4\Design\DRAWINGS\STANDARDS", ".dwg", "walk")
    dir3 = (r"server4\Design\SheetMetal_Step_Files_", ".stp", "top")

    ans = r"\\server4\Design\VaultWorkspace_BWS\PDFS\40945500.pdf"
    ans = "\\server4\Design\DRAWINGS\STANDARDS\4095 Float & Tag Trailers (955)\40955032.dwg"

    # set the destination directory
    destination_dir = r"\\nas1\public\Yassin Nassar\TEMP"

    # search for files in each source directory
    for root_dir, suffix, status in [dir1, dir2, dir3]:
        f = f"\\\\{root_dir}\\{part_number}{suffix}" # .replace("\\")
        print(f"FILE = {f}")
        if status == "top":
            if os.path.exists(f):
                print(f"FOUND!!! {f=}")
            else:
                print(f"NOT FOUND {f=}")
        else:
            rd = f"\\\\{root_dir}"
            # print(rd)
            # print(f"{list(os.walk(rd))}")
            found = False
            for root, dirs, files in os.walk(rd):
                # print(f"WALK {root=} {dirs=} {files=}")
                for file in files:
                    if file == f"{part_number}{suffix}":
                        print(f"FOUND!!! {f=}")
                        found = True
                        break
                if found:
                    break

            # shutil.copy(f, f"{destination_dir}\{f}")
        print(f"\n")


        # for root, dirs, files in os.walk(root_dir):
        #     for file in files:
        #         # construct the full source path
        #         source_path = os.path.join(root, file)
        #         # construct the full destination path
        #         destination_path = os.path.join(destination_dir, file)
        #         # copy the file to the destination directory
        #         shutil.copy(source_path, destination_path)
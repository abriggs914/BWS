string = '\"C:\\Program Files\\Microsoft Office\\root\\Office16\\MSACCESS.EXE\" \"{}\" /decompile'

print("string:", string)
db_file = input("Enter the path name of the db file to decompile\n\t")

print("Run this command to decompile \"{}\":\n\t".format(db_file), string.format(db_file))
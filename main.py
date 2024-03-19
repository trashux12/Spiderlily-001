# import Files
import os , subprocess , re

def list_files(path):
    return os.listdir(path)

def match_files(filenames, pattern):
    matching_files = []
    for filename in filenames:
        if re.search(pattern, filename):
            matching_files.append(filename)
    return matching_files

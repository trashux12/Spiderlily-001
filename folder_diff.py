import os
import argparse

# Task 1: List all .txt files in the folder
def list_txt_files(folder_path):
    txt_files = [file for file in os.listdir(folder_path) if file.endswith('.txt')]
    return txt_files

# Task 2: Check for differences in text inside the files
def find_different_texts(folder_path, folder_path2, txt_files, txt_files2):
    file_contents = {}
    file_contents2 = {}
    
    for file in txt_files:
        with open(os.path.join(folder_path, file), 'r') as f:
            file_contents[file] = f.read()

    for file in txt_files2:
        with open(os.path.join(folder_path2, file), 'r') as f:
            file_contents2[file] = f.read()

    # Check for differences
    different_files = []
    for file1 in txt_files:
        for file2 in txt_files2:
            if file_contents[file1] != file_contents2[file2]:
                if (file1, file2) not in different_files:
                    different_files.append((file1, file2))

    return different_files

# Task 3: Add new content to a new file
def add_content_to_new_file(file_path, new_content):
    with open(file_path, 'a') as f:
        f.write(new_content + '\n')

# Main function
def main():
    parser = argparse.ArgumentParser(description="Compare text files in two folders")
    parser.add_argument("-f", "--folders", nargs=2, help="Paths to the folders containing text files")
    args = parser.parse_args()

    folder_path1, folder_path2 = args.folders

    # Task 1
    txt_files1 = list_txt_files(folder_path1)
    txt_files2 = list_txt_files(folder_path2)
    print("Text files in folder 1:", txt_files1)
    print("Text files in folder 2:", txt_files2)

    # Task 2
    different_texts = find_different_texts(folder_path1, folder_path2, txt_files1, txt_files2)
    if different_texts:
        print("Files with different text content:")
        for file_pair in different_texts:
            print(file_pair[0], "in", folder_path1, "and", file_pair[1], "in", folder_path2)
    else:
        print("All text files have the same content.")

    # Task 3
    new_file_path = "new_file.txt"
    # Extracting new content from the files
    new_content = set()
    for file in txt_files1:
        with open(os.path.join(folder_path1, file), 'r') as f:
            lines = f.readlines()
            for line in lines:
                line = line.strip()
                if line not in new_content:
                    new_content.add(line)
                    add_content_to_new_file(new_file_path, line)

if __name__ == "__main__":
    main()

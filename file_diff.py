import argparse

# Task 2: Check for differences in text between two files
def find_different_texts(file1_path, file2_path):
    with open(file1_path, 'r') as file1:
        content1 = file1.read()
    with open(file2_path, 'r') as file2:
        content2 = file2.read()

    if content1 != content2:
        return content1, content2
    else:
        return None, None

# Task 3: Add differences to a new file
def add_differences_to_new_file(new_file_path, diff_content1, diff_content2):
    with open(new_file_path, 'a') as new_file:
        new_file.write("Differences in content:\n")
        new_file.write("File 1:\n")
        new_file.write(diff_content1 + '\n')
        new_file.write("File 2:\n")
        new_file.write(diff_content2 + '\n')

# Main function
def main():
    parser = argparse.ArgumentParser(description='Find differences between two text files and append them to a new file.')
    parser.add_argument('-f', '--files', nargs=2, required=True, metavar=('file1', 'file2'), help='Paths to the two text files')
    parser.add_argument('-n', '--newfile', type=str, default='differences.txt', help='Path to the new file to append differences (default: differences.txt)')
    args = parser.parse_args()

    file1_path, file2_path = args.files
    new_file_path = args.newfile

    # Task 2
    diff_content1, diff_content2 = find_different_texts(file1_path, file2_path)
    if diff_content1 is not None and diff_content2 is not None:
        print("Differences found between", file1_path, "and", file2_path)
        print("Appending differences to", new_file_path)
        # Task 3
        add_differences_to_new_file(new_file_path, diff_content1, diff_content2)
    else:
        print("No differences found between", file1_path, "and", file2_path)

if __name__ == "__main__":
    main()

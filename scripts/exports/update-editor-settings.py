"""Update Editor Settings"""

import re
import argparse

def update_tres_file(file_path, key_value_updates):
    with open(file_path, 'r') as file:
        content = file.read()

    for key, value in key_value_updates.items():
        pattern = r'(^|\n){} = .*'.format(re.escape(key))
        replacement = r'\1{} = {}'.format(key, value)
        content = re.sub(pattern, replacement, content)

    with open(file_path, 'w') as file:
        file.write(content)

parser = argparse.ArgumentParser(
    prog="Update Editor Settings",
    description="Update the editor settings file")
parser.add_argument('--path', type=str, required=True)
parser.add_argument('--sdk', type=str, required=True)

args = parser.parse_args()

key_value_updates = {
    'export/android/android_sdk_path': f'"{args.sdk}"',
}

update_tres_file(args.path, key_value_updates)

"""Create Export Preset"""

import argparse

parser = argparse.ArgumentParser(
    prog="Create Export Preset",
    description="Populate the export preset in mobile-game/")

parser.add_argument('--path', type=str, required=True)
parser.add_argument('--alias', type=str, required=True)
parser.add_argument('--password', type=str, required=True)

args = parser.parse_args()
print(args.path, args.alias, args.password)
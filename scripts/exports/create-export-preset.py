"""Create Export Preset"""

import argparse

def replace_config_values(input_file, output_file, key_value_pairs):
    with open(input_file, 'r') as input_f:
        with open(output_file, 'w') as output_f:
            for line in input_f:
                for key, value in key_value_pairs.items():
                    if line.strip().startswith(key + '='):
                        line = f'{key}="{value}"\n'
                        break
                output_f.write(line)
config_file = './mobile-game/export_presets.cfg'
template_config_file = './scripts/exports/export_presets.cfg'

parser = argparse.ArgumentParser(
    prog="Create Export Preset",
    description="Populate the export preset in mobile-game/")

parser.add_argument('--path', type=str, required=True)
parser.add_argument('--alias', type=str, required=True)
parser.add_argument('--password', type=str, required=True)

args = parser.parse_args()

replacement_pairs = {
    'keystore/release': args.path,
    'keystore/release_user': args.alias,
    'keystore/release_password': args.password
}

replace_config_values(template_config_file, config_file, replacement_pairs)
def replace_config_values(input_file, output_file, key_value_pairs):
    with open(input_file, 'r') as input_f:
        with open(output_file, 'w') as output_f:
            for line in input_f:
                for key, value in key_value_pairs.items():
                    if line.strip().startswith(key + '='):
                        line = f'{key}="{value}"\n'
                        break
                output_f.write(line)


# Specify the original .cfg file path
input_config_file = './mobile-game/export_presets.cfg'

# Specify the new .cfg file path
output_config_file = './export_presets.cfg'

# Specify the key-value pairs for replacement
replacement_pairs = {
    'keystore/release': 'PATH',
    'keystore/release_user': 'ALIAS',
    'keystore/release_password': 'PASSWORD'
}

# Replace the values in the new config file
replace_config_values(input_config_file, output_config_file, replacement_pairs)

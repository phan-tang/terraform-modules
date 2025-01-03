import os
import sys
import json

def generate_config_file(folder_nane, file_name, source_name):
    files = os.listdir(f"{source_name}/{folder_nane}")
    data = {}
    for file in files:
        if ".py" in file:
            data.update({file[:-3]: "lambda_handler"})
    with open(f"{source_name}/{file_name}.json", "w") as f:
        f.write(json.dumps({"data": data}))

folder_nane = sys.argv[1] if len(sys.argv) > 1 else "functions"
file_name = sys.argv[2] if len(sys.argv) > 2 else "config"
source_name = sys.argv[3] if len(sys.argv) > 3 else "./lambda"
generate_config_file(folder_nane, file_name, source_name)
print({})
def read_text(path):
    parsed_data = []
    with open(path, "r") as file:
        for line in file:
            values = line.split(",\t")
            parsed_data.append(
                [float(values[0]), float(values[1])]
            )
    return parsed_data


def write_text(path, data):
    with open(path, "w") as file:
        for line in data:
            file.write("{}\n".format(line))
    return None

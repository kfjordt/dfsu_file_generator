import time

asc_file = input("enter file path of .asc file: ")
roughness_input = input("enter roughness of export: ")
roughness = int(roughness_input)

start = time.time()

with open(asc_file) as f:
    raw_data = f.read()

headers = raw_data.split("\n")[:6]

header_names = [header.split(" ")[0] for header in headers]
header_values = [header.split(" ")[-1] for header in headers]

headers_dict = {k: float(v) for k, v in zip(header_names, header_values)}

n_rows, n_cols = headers_dict["nrows"], headers_dict["ncols"]
y_corner, x_corner = headers_dict["yllcorner"], headers_dict["xllcorner"]
cellsize = headers_dict["cellsize"]

data = raw_data.split("\n")[6:]
data.reverse()

x_vals = [x_corner + idx * cellsize for idx in range(int(n_cols))]
y_vals = [y_corner + idx * cellsize for idx in range(int(n_rows))]

with open("out.xyz", "w") as f:

    for row_idx in range(0, int(n_rows), roughness):

        current_y = y_vals[row_idx]

        current_row = data[row_idx].split(" ")[1:]

        for cell_idx in range(0, int(n_cols), roughness):
            
            current_x = x_vals[cell_idx]
            current_z = current_row[cell_idx]

            export_str = f"{current_x} {current_y} {current_z} \n"

            f.write(export_str)

print(f"Run took {round(time.time() - start, 2)} seconds.")


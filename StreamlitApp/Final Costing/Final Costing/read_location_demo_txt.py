from location_utility import address_to_coords

address_file = r"C:\Access\location_output_demo.txt"
coords_file = r"C:\Access\location_output_demo_coords.txt"


if __name__ == '__main__':

    with open(address_file, "r") as f:
        address_lines = f.readlines()
        addresses = {}
        for i, line in enumerate(address_lines):
            print(f"{i=}, {line=}")
            address = line.strip()
            addresses[address] = address_to_coords(address)

    with open(coords_file, "w") as f:
        for address, coords in addresses.items():
            f.write(str(coords))

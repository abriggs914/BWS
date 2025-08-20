

aisles = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "R"]
shelves = list(range(1, 66))
sub_shelves = ["A", "B", "C", "D", "E", "F", "G"]

all_shelves = []
for a in aisles:
    for s in shelves:
        all_shelves.append(f"{a}{s}")
                
all_shelves.sort()

if __name__ == "__main__":

    print(f"{len(all_shelves)=}")
    print(f"{all_shelves[:25]=}")


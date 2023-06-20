import os.path

hidden_imports = [
    "babel.numbers"
]

if __name__ == '__main__':
    pth = r"./main.spec"
    if os.path.exists(pth):
        lines = []
        with open(pth, "r") as f:
            lines = f.readlines()

        with open(pth, "w") as f:
            for line in lines:
                if "hiddenimports=[" in line:
                    splt = line.split(",")
                    imports = [imp.strip() for imp in splt[1:-1]]
                    for hi in hidden_imports:
                        if hi not in imports:
                            imports.append(hi)
                    line = splt[0] + ", ".join(imports) + splt[-1]
                f.write(line)

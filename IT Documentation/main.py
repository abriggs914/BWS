import dataclasses
from dataclasses import dataclass
from utility import *


@dataclass
class Node:
    dept: str
    related: list = dataclasses.field(default_factory=list)


in_data = {
    "Admin", "HR", "Sales",
    "BOM", "Shipping", "Warranty",
    "Receiving", "Parts", "Subs",
    "Warehouse", "Maintenance", "Accounting",
    "Payroll", "Systems", "Finish",
    "Production", "Labour (Direct)", "Labour (Indirect)",
    "Scheduling", "Machine Shop", "Special Projects",
    "Paint", "Training", "Purchasing",
    "Engineering", "Axle", "Beams",
    "GNK", "Assembly", "IT",
    "QC", "Aluminum"
}

nodes = {dept: Node(dept) for dept in in_data}

nodes["Admin"].related.append("HR")
nodes["Admin"].related.append("Accounting")
nodes["Admin"].related.append("Payroll")
nodes["Admin"].related.append("Systems")

nodes["Production"].related.append("Finish")
nodes["Production"].related.append("Machine Shop")
nodes["Production"].related.append("Paint")
nodes["Production"].related.append("Axle")
nodes["Production"].related.append("Beams")
nodes["Production"].related.append("GNK")
nodes["Production"].related.append("Assembly")
nodes["Production"].related.append("Aluminum")
# for dept, dept_node in nodes.items():


if __name__ == '__main__':
    print(f"{in_data=}")
    print(f"RESULT: {dict_print(nodes)}")

# See PyCharm help at https://www.jetbrains.com/help/pycharm/

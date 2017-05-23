from ansible.parsing.dataloader import DataLoader
from ansible.vars import VariableManager
from ansible.inventory import Inventory,Host,Group

inventory_file = "/home/admin/ansible_resource/data/inventory/test_yml/jpol"
inventory = Inventory(loader=DataLoader(), variable_manager=VariableManager(), host_list=inventory_file)

print(inventory.list_hosts("G1_html-server1"))

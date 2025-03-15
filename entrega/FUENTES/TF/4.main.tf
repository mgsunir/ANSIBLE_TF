

# Create virtual machine
resource "azurerm_linux_virtual_machine" "practica_vm" {
  depends_on = [ 
    azurerm_network_interface.vm1nic
    ]

  name                  = var.vm_name
  location              = var.gr_recursos[1]
  resource_group_name   = var.gr_recursos[0]
  network_interface_ids = [azurerm_network_interface.vm1nic.id]
  #size                  = "Standard_DS1_v2"
  # az vm list-skus --location westeurope --size Standard_D --all --output table
  size                  = var.vm_size
  
 
  os_disk {
    name                 = "myOsDisk"
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
  }
  
  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }

  computer_name  = var.hostname
  admin_username = var.username
  custom_data  = filebase64("script.sh")

  admin_ssh_key {
    username   = var.username
    #public_key = azapi_resource_action.ssh_public_key_gen.output.publicKey
    #public_key = file("account_id")
    public_key = file("~/.ssh/id_rsa.pub")
  }

  boot_diagnostics {
    storage_account_uri = azurerm_storage_account.diag0lab0unir0022032.primary_blob_endpoint
  }
  
  tags = {
    Environment = "Test"
    Ceco = "UNIR"
  }
}

# https://stackoverflow.com/questions/45489534/best-way-currently-to-create-an-ansible-inventory-from-terraform

resource "null_resource" "copy_authorized_keys" {
  depends_on = [ 
    azurerm_linux_virtual_machine.practica_vm 
    ]

  provisioner "file" {
    source      = "~/.ssh/id_rsa.pub"
    destination = "/tmp/authorized_keys"
  }

  connection {
    host     = azurerm_linux_virtual_machine.practica_vm.public_ip_address
    type     = "ssh"
    agent    = "false"
    user     = var.username
    private_key = file("~/.ssh/id_rsa")
  }
}

# chmod go-w /home/user
# chmod 700 /home/user/.ssh
# chmod 600 /home/user/.ssh/authorized_keys
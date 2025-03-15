# resource "tls_private_key" "pk_private" {
#   algorithm = "RSA"
#   rsa_bits  = 4096
# }


# resource "random_pet" "ssh_key_name" {
#   prefix    = "ssh"
#   separator = "-"
  
# }

# resource "azapi_resource_action" "ssh_public_key_gen" {
#   type        = "Microsoft.Compute/sshPublicKeys@2022-11-01"
#   resource_id = azapi_resource.ssh_public_key.id
#   action      = "generateKeyPair"
#   method      = "POST"

#   response_export_values = ["publicKey", "privateKey"]
# }

# resource "azapi_resource" "ssh_public_key" {
#   type      = "Microsoft.Compute/sshPublicKeys@2022-11-01"
#   name      = random_pet.ssh_key_name.id
#   location  = var.gr_recursos[1]
#   #parent_id = var.gr_recursos.id
#   parent_id = azurerm_resource_group.recursos.id
# }

# resource "local_file" "private_key" {
#   content         = tls_private_key.pk_private.private_key_pem
#   filename        = "${var.hostname}.pem"
#   file_permission = "0600"
# }

# output "key_data" {
#   value = azapi_resource_action.ssh_public_key_gen.output.publicKey
# }

# output "private_key_pem" {
#   value     = tls_private_key.pk_private.private_key_pem
#   sensitive = true
# }


# chmod go-w /home/ansible
# chmod 700 /home/ansible/.ssh
# chmod 600 /home/ansible/.ssh/authorized_keys
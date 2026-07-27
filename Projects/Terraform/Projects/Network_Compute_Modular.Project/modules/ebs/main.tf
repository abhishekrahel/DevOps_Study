resource "aws_ebs_volume" "storage" {
    availability_zone = var.availability_zone
    size = var.disk_size

    tags = {
        Name = "Disk"
    }
}

resource "aws_volume_attachment" "ebs_attach" {
    instance_id = var.instance_id
    volume_id = var.volume_id
    device_name = var.device_name
}


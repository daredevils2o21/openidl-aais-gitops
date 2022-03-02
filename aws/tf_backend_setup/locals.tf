locals {
   tags = {
      application           = "openidl"
      managed_By            = "terraform"
   }
   bucket_tags = {
      application           = "openidl"
      managed_By            = "terraform"
      BucketOwner1          = "${var.owner1}"
      BucketOwner2          = "${var.owner2}"
      DataClassification    = "${var.classification}"
   }
}

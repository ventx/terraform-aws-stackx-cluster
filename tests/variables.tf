variable "tags" {
  type = map(string)
  default = {
    "repo"     = "terraform-aws-stackx-cluster"
    "test"     = "true",
    "deleteme" = "true"
  }
}

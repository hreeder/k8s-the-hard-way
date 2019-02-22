workflow "Deploy on Push to Master" {
  on       = "push"
  resolves = ["terraform-apply"]
}

action "only-master-branch" {
  uses = "actions/bin/filter@master"
  args = "branch master"
}

action "terraform-init" {
  uses    = "hashicorp/terraform-github-actions/init@v0.1.3"
  needs   = "only-master-branch"
  secrets = ["GITHUB_TOKEN", "GOOGLE_CREDENTIALS"]

  env = {
    TF_ACTION_WORKING_DIR = "infra"
  }
}

action "terraform-validate" {
  uses    = "hashicorp/terraform-github-actions/validate@v0.1.3"
  needs   = "terraform-init"
  secrets = ["GITHUB_TOKEN", "GOOGLE_CREDENTIALS"]

  env = {
    TF_ACTION_WORKING_DIR = "infra"
  }
}

action "terraform-plan" {
  uses    = "hashicorp/terraform-github-actions/plan@v0.1.3"
  needs   = "terraform-validate"
  secrets = ["GITHUB_TOKEN", "GOOGLE_CREDENTIALS"]

  env = {
    TF_ACTION_COMMENT     = "false"
    TF_ACTION_WORKING_DIR = "infra"
  }
}

action "terraform-apply" {
  uses    = "hreeder/terraform-github-actions/apply@master"
  needs   = "terraform-plan"
  secrets = ["GITHUB_TOKEN", "GOOGLE_CREDENTIALS"]

  env = {
    TF_ACTION_WORKING_DIR = "infra"
  }
}

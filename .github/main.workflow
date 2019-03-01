workflow "Deploy on Push to Master" {
  on       = "push"
  resolves = ["notify-complete"]
}

action "only-master-branch" {
  uses = "actions/bin/filter@master"
  args = "branch master"
}

action "notify-start" {
  uses    = "Ilshidur/action-slack@master"
  needs   = "only-master-branch"
  secrets = ["SLACK_WEBHOOK"]
  args    = "Starting Deployment"
}

action "terraform-init" {
  uses    = "hashicorp/terraform-github-actions/init@v0.1.3"
  needs   = "only-master-branch"
  secrets = ["GOOGLE_CREDENTIALS"]

  env = {
    TF_ACTION_COMMENT     = "false"
    TF_ACTION_WORKING_DIR = "infra"
  }
}

action "terraform-validate" {
  uses    = "hashicorp/terraform-github-actions/validate@v0.1.3"
  needs   = "terraform-init"
  secrets = ["GOOGLE_CREDENTIALS"]

  env = {
    TF_ACTION_COMMENT     = "false"
    TF_ACTION_WORKING_DIR = "infra"
  }
}

action "terraform-plan" {
  uses    = "hashicorp/terraform-github-actions/plan@v0.1.3"
  needs   = "terraform-validate"
  secrets = ["GOOGLE_CREDENTIALS"]

  env = {
    TF_ACTION_COMMENT     = "false"
    TF_ACTION_WORKING_DIR = "infra"
  }
}

action "terraform-apply" {
  uses    = "hreeder/terraform-github-actions/apply@master"
  needs   = "terraform-plan"
  secrets = ["GOOGLE_CREDENTIALS"]

  env = {
    TF_ACTION_WORKING_DIR = "infra"
  }
}

action "certification" {
  uses    = "./.build/certification"
  needs   = "terraform-apply"
  secrets = ["GOOGLE_CREDENTIALS"]
}

action "notify-complete" {
  uses    = "Ilshidur/action-slack@master"
  needs   = ["certification", "notify-start"]
  secrets = ["SLACK_WEBHOOK"]
  args    = "Kubernetes has been deployed. The hard way."
}

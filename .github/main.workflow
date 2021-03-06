# Staging

workflow "Deploy staging" {
  on = "push"
  resolves = ["deploy"]
}

action "filter branch master" {
  uses = "actions/bin/filter@master"
  args = "branch master"
}

action "install" {
  needs = "filter branch master"
  uses = "actions/npm@3c8332795d5443adc712d30fa147db61fd520b5a"
  args = "ci"
}

action "build" {
  needs = ["install"]
  uses = "actions/npm@3c8332795d5443adc712d30fa147db61fd520b5a"
  args = "run build"
}

action "deploy" {
  needs = ["build"]
  uses = "actions/npm@3c8332795d5443adc712d30fa147db61fd520b5a"
  args = "run deploy:staging"
  secrets = ["AWS_ACCESS_KEY_ID", "AWS_SECRET_ACCESS_KEY"]
}

# Production

workflow "Deploy production" {
  on = "release"
  resolves = ["deploy:production"]
}

action "install:aws" {
  uses = "actions/npm@3c8332795d5443adc712d30fa147db61fd520b5a"
  args = "install aws-sdk@2.395"
}

action "deploy:production" {
  needs = ["install:aws"]
  uses = "actions/npm@3c8332795d5443adc712d30fa147db61fd520b5a"
  args = "run deploy:production"
  secrets = ["AWS_ACCESS_KEY_ID", "AWS_SECRET_ACCESS_KEY", "DISTRIBUTION_ID"]
}
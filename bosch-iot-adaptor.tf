terraform {
    required_providers {
        azuredevops = {
            source = "microsoft/azuredevops"
        }
    }
}
provider "azuredevops"{
    org_service_url = "https://dev.azure.com/MobilityCloudPlatform"
    personal_access_token = "sng6xol3baktancm3sdceb3qrwhouum4a3rpryvvjt6pga6tkh7a"
}

data "azuredevops_project" "proj" {
  name = "MobilityCloudPlatform"
}

output "myout"{
    value = data.azuredevops_project.proj.name
}


data "azuredevops_git_repository" "myrepo" {
  project_id = data.azuredevops_project.proj.id
  name       = "Backend_Services"
}

resource "azuredevops_build_definition" "example" {
  project_id = data.azuredevops_project.proj.id
  name       = "YAML_Bosch_IOT_Adaptor"
  path       = "\\YAML Pipelines"

  ci_trigger {
    use_yaml = false
  }

  repository {
    # repo_type             = "GitHubEnterprise"
    repo_type = "TfsGit"
    repo_id               = data.azuredevops_git_repository.myrepo.id
    # github_enterprise_url = https://github.company.com
    branch_name           = "develop/integration"
    yml_path              = "/Test.yml"
    # service_connection_id = azuredevops_serviceendpoint_github_enterprise.example.id
  }

}
resource "azuredevops_variable_group" "example" {
  project_id   = data.azuredevops_project.proj.id
  name         = "Bosch_IOT_Adaptor "
  description  = "Bosch_IOT_Adaptor"
  allow_access = true
  
  variable {
    name  = "displayName"
    value = "Maven bosch-iot-adaptor/pom.xml"
  }
  variable {
    name  = "mavenpomFile"
    value = "bosch-iot-adaptor/pom.xml"
  }
  variable {
    name  = "Docker_image"
    value = "bosch-iot-adaptor image"
  }
  variable {
    name  = "repository"
    value = "bosch-iot-adaptor-service"
  }
  variable {
    name  = "Dockerfile"
    value = "bosch-iot-adaptor/Dockerfile"
  }
  variable {
    name  = "buildContext"
    value = "bosch-iot-adaptor"
  }
  variable {
    name  = "arguments"
    value = "--output $(build.artifactstagingdirectory)/bosch-iot-adaptor-service.image.tar bosch-iot-adaptor-service"
  }
}
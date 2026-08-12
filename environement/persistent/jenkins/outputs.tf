output "jenkins_instance_id" {
  value = module.jenkins.jenkins_instance_id
}

output "jenkins_private_ip" {
  value = module.jenkins.jenkins_private_ip
}

output "agent_instance_id" {
  value = module.jenkins.agent_instance_id
}

output "agent_private_ip" {
  value = module.jenkins.agent_private_ip
}
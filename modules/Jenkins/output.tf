output "jenkins_instance_id" {
  value = aws_instance.jenkins.id
}

output "jenkins_private_ip" {
  value = aws_instance.jenkins.private_ip
}

output "agent_instance_id" {
  value = aws_instance.agent.id
}

output "agent_private_ip" {
  value = aws_instance.agent.private_ip
}
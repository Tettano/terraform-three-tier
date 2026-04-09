output "launch_template_ids" {
  description = "IDs of the created launch templates"
  value       = { for k, v in aws_launch_template.web-server : k => v.id }
}

output "autoscaling_group_names" {
  description = "Names of the created autoscaling groups"
  value       = { for k, v in aws_autoscaling_group.web-server-asg : k => v.name }
}

output "autoscaling_group_arns" {
  description = "ARNs of the created autoscaling groups"
  value       = { for k, v in aws_autoscaling_group.web-server-asg : k => v.arn }
}
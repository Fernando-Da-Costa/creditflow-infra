resource "aws_athena_workgroup" "workgroup_creditflow" {
  name = "workgroup_creditflow"

  state = "ENABLED"

  configuration {
    enforce_workgroup_configuration = false

    result_configuration {
      output_location = "s3://bucket-athena-query-results-fernando/result_consulta_athena/"
    }
  }
}
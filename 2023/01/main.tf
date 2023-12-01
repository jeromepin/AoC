locals {
  # Load all calibration values from the file into an array 
  inputs = split("\n", file("${path.module}/input"))

  # Extract digits from every calibration values
  calibrations_numbers = [for calibration_value in local.inputs: regexall("[0-9]{1}", calibration_value)]
  
  # Every single digit is returned twice into a list : [7] => "77"
  single_digits = [for sublist in local.calibrations_numbers: "${sublist[0]}${sublist[0]}" if length(sublist) == 1]
  
  # When a calibration value has multiple digits, the first and last one are returned : [1, 2, 3, 4, 5] => "15"
  several_digits = [for sublist in local.calibrations_numbers: "${sublist[0]}${reverse(sublist)[0]}" if length(sublist) > 1]
  
  res = sum(concat(local.single_digits, local.several_digits))
}

output "out" {
  value = local.res
  sensitive = false
}

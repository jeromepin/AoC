locals {
  # Load all calibration values from the file into an array 
  inputs = split("\n", file("${path.module}/input"))

  # replace all numbers written as strings with a similar string containg the number : one -> on1e
  # It allows to easily handle overlapping numbers : nineight (with the common "e") -> nin9eigh8t (-> 98)
  replaced_strings = compact([for str in local.inputs: replace(replace(replace(replace(replace(replace(replace(replace(replace(str, "nine", "nin9e"), "eight", "eigh8t"), "seven", "seve7n"), "six", "si6x"), "five", "fiv5e"), "four", "fou4r"), "three", "thre3e"), "two", "tw2o"), "one", "on1e")])

  # Extract digits from every strings
  extracted_digits = [for str in local.replaced_strings: regexall("[0-9]{1}", str)]
  
  # the first and last digit are returned : [1, 2, 3, 4, 5] => "15"
  calibration_value = [for sublist in local.extracted_digits: "${sublist[0]}${reverse(sublist)[0]}"]
}

output "out" {
  value = sum(local.calibration_value)
  sensitive = false
}

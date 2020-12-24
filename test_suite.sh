test_reverse_string_204() {
  printf "test_reverse_string_204\n"
  resp_body="$(mktemp)"
  reversed_example="$(mktemp)"

  aws lambda invoke \
    --function-name reverse-string-handler \
    --payload '{"from":"example.json","to":"reversed_example.json"}' \
    $resp_body \
  > /dev/null

  status=$(cat $resp_body | jq .statusCode)
  assert_equal $status 204

  printf "test_reversed_string\n"
  aws s3api get-object \
    --bucket reversed-string-bucket \
    --key reversed_example.json \
    $reversed_example
  > /dev/null

  assert_equal $reversed_example 'efil si llab'
}

test_reverse_string_400() {
  printf "test_reverse_string_400\n"
  resp_body="$(mktemp)"

  aws lambda invoke \
    --function-name reverse-string-handler \
    --payload '{}' \
    $resp_body \
  > /dev/null

  status=$(cat $resp_body | jq .statusCode)
  assert_equal $status 400
}

test_reverse_string_500() {
  printf "test_reverse_string_500\n"
  resp_body="$(mktemp)"

  aws lambda invoke \
    --function-name reverse-string-handler \
    --payload '{"from":"^a)f","to":"e>"}' \
  $resp_body \
  > /dev/null

  status=$(cat $resp_body | jq .statusCode)
  assert_equal $status 500
}

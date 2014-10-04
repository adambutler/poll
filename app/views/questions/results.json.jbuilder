json.array!(@options) do |option|
  json.value option.votes
  json.label option[:title]
end

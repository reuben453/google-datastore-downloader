require "google/cloud/datastore"
require 'csv'

datastore = Google::Cloud::Datastore.new()

if ARGV[0].nil?
  puts "Please specify the GQL string as an argument"
  return
end

gql_query = Google::Cloud::Datastore::GqlQuery.new
gql_query.allow_literals = true
gql_query.query_string = ARGV[0]
begin
  raw_pkts = datastore.run gql_query
rescue
  puts "Invalid GQL string! Please correct your GQL string and try again."
  raise
end

column_names = raw_pkts.first.properties.to_h.keys
s=CSV.generate do |csv|
  csv << column_names
  raw_pkts.each_with_index do |x, index|
    temp_hash = x.properties.to_h
    if temp_hash.keys.sort != column_names.sort
      raise "All values do not have the same columns. Columns of 1st value: #{column_names.sort}, Columns of #{index+1} value: #{temp_hash.keys.sort}"
    end
    values = []
    column_names.each do |property|
      values << temp_hash[property]
    end
    csv << values
  end
end

puts s
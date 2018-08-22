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

first_loop = true

catch :foreverloop do
  while true do
    s=CSV.generate do |csv|

      # Add the column headers to the csv if this is the first loop
      if first_loop
        csv << column_names
        first_loop = false
      end

      raw_pkts.each_with_index do |x, index|
        temp_hash = x.properties.to_h

        # Make sure the columns that this row has is the same as the columns of the first row
        if temp_hash.keys.sort != column_names.sort
          raise "All rows do not have the same columns. Columns of 1st row: #{column_names.sort}, Columns of #{index+1} row: #{temp_hash.keys.sort}"
        end

        # Add each column of this row in the same order as the csv header row
        values = []
        column_names.each do |property|
          values << temp_hash[property]
        end

        csv << values
      end

    end

    # Print the generated csv
    puts s

    # If there was a limit set in the query, reduce the limit and check if we need to continue.
    if !raw_pkts.query.limit.nil? && raw_pkts.query.limit.value > 0
      # Reduce the limit by the number of rows we got in the last run
      raw_pkts.query.limit.value -= raw_pkts.length

      # Exit the forever loop if we have the number of desired rows.
      if raw_pkts.query.limit.value <= 0
        throw :foreverloop
      end
    end

    # Check if more results are available.
    if raw_pkts.next?
      # Get the next batch of results.
      raw_pkts = raw_pkts.next
    else
      throw :foreverloop
    end

  end
end
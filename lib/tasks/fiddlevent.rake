require 'active_record/fixtures'

namespace :fiddle do
  
  desc "Updates Roles and Perms"
  task :update_roles => :environment do
    TaskHelper.reload_roles_and_perms
  end
  
  
  desc "Load remote data to be saved with local data"
  task :load_from_remote => :environment do
    puts "Loading remote data into local database..."
    load_fixtures :filters, :roles
    puts "done."
  end
  
  desc "Save local data to be synchronized with remote data"
  task :save_to_remote => :environment do
    puts "Saving local data to fixtures... "
    dump_fixtures(:roles, :filters)
    puts "done."
  end
end
  
  
private

def dump_fixtures(*tables)
  sql  = "SELECT * FROM %s ORDER BY id DESC"
    tables.each do |table_name|
      i = "000"
      File.open("#{Rails.root}/db/fixtures/#{table_name}.yml", 'w') do |file|
        data = ActiveRecord::Base.connection.select_all(sql % table_name)
        file.write data.inject({}) { |hash, record|
          hash["#{table_name}_#{i.succ!}"] = record
          hash
        }.to_yaml
      end
    end
end

def load_fixtures(*tables)
  tables.each do |table|
    ActiveRecord::Fixtures.create_fixtures("#{Rails.root}/db/fixtures", table)
  end
end


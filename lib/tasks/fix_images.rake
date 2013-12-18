
# need an isk database running
namespace :images do
  desc "Fix a common image problem"
  task :fix => :environment do
    Edition.all.each do |e|	
      if e.cover_url && e.cover_url.ends_with?(".php")
        begin
          puts "fixing edition #{e.id}"
          File.rename(Rails.public_path+e.cover_url,Rails.public_path+e.cover_url.sub("php","jpg"))
          e.remote_cover_url="http://dev.redemmas.org/"+e.cover_url.sub("php","jpg")
          e.save!
          File.delete(Rails.public_path+e.cover_url.sub("jpg","php"))
        rescue
          puts "PROBLEM fixing edition #{e.id}"
        end
      end
    end
  end
end











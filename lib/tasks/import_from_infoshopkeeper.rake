# need an isk database running
namespace :infoshopkeeper do
  desc "Import from infoshopkeeper"
  task :import => :environment do
    
    isk_db="isk"
    isk_db_user="isk"
    isk_db_password="isk"

    only_do_books=true

    puts "Connecting to old database...."
    DB = Sequel.connect(:adapter => 'mysql', :user => isk_db_user, :host => 'localhost', :database => isk_db,:password=>isk_db_password)    
    puts "Success!"			 
    

    titles=DB[:title]
    books=DB[:book]
    authors=DB[:author]
    titletags=DB[:titletag]
    author_title=DB[:author_title]


    #Get the list of titles from isk    
    if only_do_books
      titles_to_import=titles.where(:kind_id => 1)
    else
      titles_to_import=titles
    end
    
    c=0
    titles_to_import.each do |t|   # Only grab books
      if c>10
        next
      end
      c=c+1

      puts "Processing title: #{t[:booktitle]}"

      #each title becomes a borges title
      new_title=Title.new(:title => t[:booktitle] )
      
      unless t[:publisher].blank?
        new_publisher=Publisher.find_or_create_by_name(t[:publisher])
      end

      old_isbn=Lisbn.new(t[:isbn])
      
      if old_isbn.valid?
        new_isbn10=old_isbn.isbn10
        new_isbn13=old_isbn.isbn13
        
        #We'll try openlibrary.org for a cover image
        new_cover_url="http://covers.openlibrary.org/b/isbn/#{new_isbn13}-L.jpg"
        
        #HIT GOOGLE API FOR DATE OF PUBLICATION
        gbooks = GoogleBooks.search('isbn:'+new_isbn13) # yields a collection of one result
        gbook = gbooks.first
        unless gbook.nil?
          gpublished_date=gbook.published_date
          unless gpublished_date.blank?
            new_published_date=gpublished_date[0,4]
          end
        end
      end
      

      #and each title gets its own unique edition
      new_edition=Edition.new(:isbn10=>new_isbn10,
                              :isbn13=>new_isbn13,
                              :publisher=>new_publisher,
                              :in_print=>true,
                              :year_of_publication => new_published_date,
                              :remote_cover_url => new_cover_url)
      
      #each book gets made into a copy attached to that edition

      books_for_title=books.where(:title_id => t[:id])
      
      books_for_title.each do |b|
        
        new_copy = Copy.new(:cost => b[:wholesale],
                            :price => b[:listprice],
                            :inventoried_when => b[:inventoried_when],
                            :deinventoried_when => b[:sold_when],
                            :status => b[:status],
                            :owner => (Owner.find_or_create_by_name(b[:owner]) unless b[:owner].blank?),
                            :distributor => (Distributor.find_or_create_by_name(b[:distributor]) unless b[:distributor].blank?),
                            :notes => b[:notes],
                            :is_used => (b[:distributor] == "used" ? true : false),
                            )
        
        unless new_copy.valid?
          puts new_copy.errors.messages
        end

        new_edition.copies << new_copy

        new_edition.list_price=new_edition.copies.collect{|c| c.price }.max
                                       
      end
      
      new_title.editions << new_edition

      author_titles = author_title.where(:title_id => t[:id])
      authors_for_title=author_titles.collect {|a_t| authors.where(:id => a_t[:author_id]).first}
      
      authors_for_title.each do |a|
        new_title.authors << Author.find_or_create_by_full_name(a[:author_name])
      end

      
      tags=titletags.where(:title_id => t[:id],:tagkey => "section")
      tags.each do |tag|
        new_title.categories << Category.find_or_create_by_name(tag[:tagvalue])
      end
      
      new_title.save!

    end
       
  end

end












